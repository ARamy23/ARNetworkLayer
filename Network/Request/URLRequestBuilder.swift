//
//  URLRequestBuilder.swift
//  WiFi Metropolis
//
//  Created by Ahmed Ramy on 6/24/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

protocol URLRequestBuilder {
    
    var mainURL: URL { get }
    var requestURL: URL { get }
    // MARK: - Path
    var path: ServerPath { get }
    
    // MARK: - Parameters
    var parameters: Parameters? { get }
    
    var headers: HTTPHeaders? { get }
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
}


extension URLRequestBuilder {
    var mainURL: URL  {
        return URL(string: Constants.NetworkSettings.baseURL)!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path.rawValue, isDirectory: false)
    }
    
    var headers: HTTPHeaders {
        let header = HTTPHeaders()
        //write default headers here
        return header
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return request
    }
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

protocol URLRequestConvertible
{
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    /// The URL request.
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

protocol ParameterEncoding
{
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
}

struct URLEncoding: ParameterEncoding
{
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let url = request.url else { throw NetworkErrors.missingURL}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), parameters != nil, !parameters!.isEmpty
        {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters!
            {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            
            request.url = urlComponents.url
        }
        
        return request
    }
}

struct JSONEncoding: ParameterEncoding
{
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted)
            request.httpBody = jsonData
            
        }
        catch
        {
            throw NetworkErrors.encodingFailed
        }
        return request
    }
}

extension URLRequest: URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    public func asURLRequest() throws -> URLRequest { return self }
}






