//
//  APIErrors.swift
//  WiFi Metropolis
//
//  Created by Ahmed Ramy on 6/24/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

public enum NetworkErrors: String, Error
{
    case encodingFailed = "Parameter Encoding Failed"
    case missingURL = "URL is nil"
}
