//
//  HTTPClient.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/12.
//


import Combine
import Foundation

protocol HTTPClient {
    func sendRequest<T>(endpoint: Endpoint) -> AnyPublisher<T, RequestError> where T: Decodable, T: Encodable
}

extension HTTPClient {
    func sendRequest<T>(endpoint: Endpoint) -> AnyPublisher<T, RequestError> where T: Decodable, T: Encodable {

        guard let url = URL(string: endpoint.endURL) else {
            return AnyPublisher(
                Fail<T, RequestError>(error: RequestError.invalidURL)
            )
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 10.0

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw RequestError.noResponse
                }
                
                guard response.statusCode == 200 else {
                    throw RequestError.unexpectedStatusCode
                }
                
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                RequestError.decode
            }
            .eraseToAnyPublisher()
    }
}
