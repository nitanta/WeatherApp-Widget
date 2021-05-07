//
//  Endpoint.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case delete
    case update
    case put
}

public enum ParameterEncoding {
    case json
    case url
    case urlformencoded
    case none
}

protocol EndpointProtocol {
        
    var baseURL: String { get }
    
    var absoluteURL: String { get }
        
    var params: [String: Any] { get }
    
    var headers: [String: String] { get }
    
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
}


enum AppEndpoint: EndpointProtocol {
    case getWheather(latitude: Float, longitude: Float)

    var baseURL: String {
        switch self {
        case .getWheather:
            return Global.baseUrl
        }
    }
    
    var absoluteURL: String {
        switch self {
        case .getWheather:
            return baseURL + "data/2.5/weather"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .getWheather(let latitude, let longitude):
            return [
                "lat": "\(latitude)",
                "lon": "\(longitude)",
                "appid": Global.apiKey
            ]
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getWheather:
            return [
                "Content-type": "application/json",
                "Accept": "application/json"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWheather: return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getWheather: return .url
        }
    }
}
