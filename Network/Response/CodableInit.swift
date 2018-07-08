//
//  CodableInit.swift
//  WiFi Metropolis
//
//  Created by Ahmed Ramy on 6/24/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

protocol CodableInit {
    init(data: Data) throws
}

extension CodableInit where Self: Codable {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try decoder.decode(Self.self, from: data)
    }
}
