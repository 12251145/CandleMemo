//
//  ContentView-Viewmodel.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/17.
//

import Combine
import Foundation
import SwiftUI
import Starscream

protocol WebsocketManagerProtocol {
    func webSocketConnect()
    func webSocketDisconnect()
    func updateTickers(data: Data)
}

protocol ContentViewModelProtocol {
    func getAllMarkets() -> AnyPublisher<[Market], RequestError>
}

final class ContentViewViewModel: HTTPClient, ObservableObject {
    @Published var krwMarkets: [Market] = []
    @Published var tickers: [String : Ticker] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private var socket: WebSocket?
    private var shouldPause = false
    private var retries = 0

    let scrollingSubject: PassthroughSubject<Void, Never>
    let scrollingPublisher: AnyPublisher<Void, Never>
    
    let scrollEndSubject: PassthroughSubject<Void, Never>
    let scrollEndPublisher: AnyPublisher<Void, Never>
    
    
    init() {
        // 스크롤 끝
        let scrollEndSubject = PassthroughSubject<Void, Never>()
        
        self.scrollEndPublisher = scrollEndSubject
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        self.scrollEndSubject = scrollEndSubject
        
        // 스크롤링
        let scrollingSubject = PassthroughSubject<Void, Never>()
        
        self.scrollingPublisher = scrollingSubject
            .eraseToAnyPublisher()
        
        self.scrollingSubject = scrollingSubject
        
        
        // 구독
        self.scrollingPublisher
            .dropFirst(1)
            .sink(receiveValue: {
                print("scrolling")
                self.shouldPause = true })
            .store(in: &cancellables)
        
        self.scrollEndPublisher
            .dropFirst(1)
            .sink(receiveValue: {
                print("scroll end")
                self.shouldPause = false })
            .store(in: &cancellables)
    }
    
    func pausePublishTickers() {
        print("pause")
        shouldPause = true
    }
    
    func resumePublishTickers() {
        shouldPause = false
    }
    
    func requestKRWMarkets() {
        getAllMarkets()
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
}

extension ContentViewViewModel: WebSocketDelegate {
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
}

extension ContentViewViewModel: WebsocketManagerProtocol {
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
    
    func updateTickers(data: Data) {
        //print(shouldPause)
        if !shouldPause {
            if let tickerData = try? JSONDecoder().decode(Ticker.self, from: data) {                
                tickers[tickerData.code] = tickerData
            }
        }
    }
}

extension ContentViewViewModel: ContentViewModelProtocol {
    func getAllMarkets() -> AnyPublisher<[Market], RequestError> {
        return sendRequest(endpoint: UpbitEndpoint.market)
    }
}
