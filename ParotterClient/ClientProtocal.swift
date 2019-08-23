//
//  ClientProtocal.swift
//  ParotterClient
//
//  Created by Fan Zhang on 8/23/19.
//  Copyright © 2019 Fan Zhang. All rights reserved.
//

import Foundation

public protocol ClientProtocol {
    @discardableResult
    func post(path: String,
        baseURL: TwitterURL,
        parameters: [String: String], success: HTTPRequest.SuccessHandler?, failure: HTTPRequest.FailureHandler?) -> HTTPRequest
}
