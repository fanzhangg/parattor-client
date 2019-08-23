//
//  Auth.swift
//  ParotterClient
//
//  Created by Fan Zhang on 8/23/19.
//  Copyright © 2019 Fan Zhang. All rights reserved.
//

import Foundation
import os.log

// MARK: properties
public extension Twitter {
    typealias TokenSuccessHandler = (String, URLResponse) -> Void
    
    func authorize(callback: URL, success: TokenSuccessHandler?, failure: FailureHandler? = nil) {
        self.postOAuthRequestToken(callback: callback, success: { token, response in
            print(token)
            os_log("Token: %s", token)
        }, failure: failure)
    }
    
    func postOAuthRequestToken(callback: URL, success: @escaping TokenSuccessHandler, failure: FailureHandler?) {
        let path = "oauth/request_token"
        let parameters = ["oauth_callback": callback.absoluteString]
        
        self.client.post(path: path, baseURL: .oauth, parameters: parameters, success: { data, response in
            let responseString = String(data: data, encoding: .utf8)
            let accessToken = responseString!
            success(accessToken, response)
        }, failure: failure)
    }
}
