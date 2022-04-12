//
//  Endpoint.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/12.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String:String]? { get }
    var body: [String:String]? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.upbit.com/v1/"
    }
}
