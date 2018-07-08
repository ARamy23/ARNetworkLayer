//
//  ResponseHandler.swift
//  WiFi Metropolis
//
//  Created by Ahmed Ramy on 6/24/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

public typealias ResponseTuble = (data: Data?, response: URLResponse?, error: Error?)

protocol HandleResponse {
    /// Handles request response, never called anywhere but APIRequestHandler
    ///
    /// - Parameters:
    ///   - response: response from network request, for now alamofire Data response
    ///   - completion: completing processing the json response, and delivering it in the completion handler
    func handleResponse<T: CodableInit>(_ response: ResponseTuble, completion: CallResponse<T>)
}

extension HandleResponse {
    
    func handleResponse<T: CodableInit>(_ response: ResponseTuble, completion: CallResponse<T>) {
        if let error = response.error {
            // handle errors
            completion?(ServerResponse<T>.failure(error as? LocalizedError))
            print(error.localizedDescription)
            return
        }
        guard let data = response.data else {
            completion?(ServerResponse<T>.failure(response.error as? LocalizedError))
            
            return
        }
        do
        {
            let modules = try T(data: data)
            completion?(ServerResponse<T>.success(modules))
        }
        catch
        {
            completion?(ServerResponse<T>.failure(error as? LocalizedError))
            print(error.localizedDescription)
        }
    }
}
