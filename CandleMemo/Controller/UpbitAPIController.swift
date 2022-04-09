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
    
    private var socket: WebSocket?
    
    var cancellables = Set<AnyCancellable>()
    
    var isScrolliing = false


    init() {
        
        self.isScrolliing = false
        getKRWMarkets()
    }
    
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
                break
            case .text(let string):
                parse(data: string.data(using: .utf8)!)
                
                break
            case .binary(let data):
                parse(data: data)
                
                break
            case .error(let error):
                print(error?.localizedDescription ?? "")
                break
            default:
                break
        }
    }
    
    func parse(data: Data) {
        if !isScrolliing {
            if let tickerData = try? JSONDecoder().decode(Ticker.self, from: data) {
                print(tickerData)
                tickers[tickerData.code] = tickerData
            }
        }
    }
    
    func getKRWMarkets() {
        guard let url = URL(string: "https://api.upbit.com/v1/market/all?isDetails=false") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [Market].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in

            } receiveValue: { [weak self] returnedMarkets in
                self?.krwMarkets = returnedMarkets.filter { $0.code.hasPrefix("KRW") }
            }
            .store(in: &cancellables)
    }
}

