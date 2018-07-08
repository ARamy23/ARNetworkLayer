//
//  RequestHandler.swift
//  WiFi Metropolis
//
//  Created by Ahmed Ramy on 6/24/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

/// Response completion handler beautified.
typealias CallResponse<T> = ((ServerResponse<T>) -> Void)?


/// API protocol, The alamofire wrapper
protocol APIRequestHandler: HandleResponse {
    
    /// Calling network layer natively, this implementation can be replaced anytime in one place which is the protocol itself, applied everywhere.
    ///
    /// - Parameters:
    ///   - decoder: Codable confirmed class/struct, Model.type.
    ///   - requestURL: Server request.
    ///   - completion: Results of the request, general errors cases handled.
    /// - Returns: Void.
    func send<T: CodableInit>(_ decoder: T.Type, completion: CallResponse<T>)
}

extension APIRequestHandler where Self: URLRequestConvertible
{
    
    func send<T: CodableInit>(_ decoder: T.Type, completion: CallResponse<T>)
    {
        
        request(self){(response) in
            DispatchQueue.main.async
            {
                self.handleResponse(response, completion: completion)
            }
        }
    }
    
    func request(_ requestURL: URLRequestConvertible,_ onRespond: @escaping (ResponseTuble) -> Void)
    {
        let request = try? requestURL.asURLRequest()
        
        if let urlRequest = request
        {
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                onRespond((data, response, error))
            }.resume()
        }
    }
}
