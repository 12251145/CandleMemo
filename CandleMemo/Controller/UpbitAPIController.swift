//
//  UpbitAPIController.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/09.
//

import Combine
import SwiftUI
import Starscream


class UpbitAPIController: ObservableObject, WebSocketDelegate {
    @Published var krwMarkets: [Market] = []
    @Published var tickers: [String : Ticker] = [:]
    @Published var candles: [String : [Candle]] = [:]
    
    let service = UpbitAPIService()
    
    private var socket: WebSocket?
    private var cancellables = Set<AnyCancellable>()
    private var shouldPause = false
    
    private var retries = 0
    
    let apiQueue = DispatchQueue.init(label: "API")

    func webSocketConnect() {
        
        let url = "wss://api.upbit.com/websocket/v1"
        
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 10

        socket = WebSocket(request: request, certPinner: FoundationSecurity(allowSelfSigned: true))
        socket?.delegate = self
        socket?.connect()
    }
    
    func webSocketDisconnect() {
        socket?.disconnect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch(event) {
            case .connected(let headers):
                print(".connected - \(headers)")

                let params = [["ticket":"test"],
                              ["type":"ticker","codes": krwMarkets.map{ $0.code }]]
                    
                let jParams = try! JSONSerialization.data(withJSONObject: params, options: [])
                client.write(string: String(data:jParams, encoding: .utf8)!, completion: nil)
                break
            case .disconnected(let reason, let code):
                print(".disconnected - \(reason), \(code)")
                
                if retries < 2 {
                    webSocketConnect()
                    retries += 1
                }
            
                break
            case .text(_):
                break
            case .binary(let data):
                updateTickers(data: data)
                
                break
            case .error(let error):
                print(error?.localizedDescription ?? "")
                break
            default:
                break
        }
    }
    
    func updateTickers(data: Data) {
        if !shouldPause {
            if let tickerData = try? JSONDecoder().decode(Ticker.self, from: data) {
                tickers[tickerData.code] = tickerData
            }
        }
    }
    
    func requestKRWMarkets() {
        
        service.getAllMarkets()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("get all markets!")
                case .failure(let error):
                    print(error.customMessage)
                }
            } receiveValue: { [weak self] markets in
                self?.krwMarkets = markets.filter { $0.code.hasPrefix("KRW") }
            }
            .store(in: &cancellables)
        
    }
    
    func requestCandles(code: String, type: CandleType, to: String? = nil, count: String? = "200") {
        service.getCandles(from: code, type: type, to: to, count: count)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("get all candles!")
                case .failure(let error):
                    print(error.customMessage)
                }
            } receiveValue: { [weak self] candles in
                self?.candles[code] = candles
            }
            .store(in: &cancellables)
    }
    
    func pausePublishTickers() {
        shouldPause = true
    }
    
    func resumePublishTickers() {
        shouldPause = false
    }
}

