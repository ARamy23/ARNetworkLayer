//
//  ServerResponse.swift
//  WiFi Metropolis
//
//  Created by Ahmed Ramy on 6/24/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

enum ServerResponse<T> {
    case success(T), failure(LocalizedError?)
}
