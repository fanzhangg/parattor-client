//
//  HTTPRequest.swift
//  ParotterClient
//
//  Created by Fan Zhang on 8/23/19.
//  Copyright © 2019 Fan Zhang. All rights reserved.
//

import Foundation
import os.log

public enum HTTPMethodType : String {
    case POST
    case GET
}

public class HTTPRequest: NSObject, URLSessionDataDelegate {

    public typealias SuccessHandler = (Data, HTTPURLResponse) -> Void
    public typealias FailureHandler = (Error) -> Void
    
    // Properties to initialize request
    var timeoutInterval: TimeInterval = 60
    var hTTPShouldHandleCookies: Bool = false
    let url: URL
    let HTTPMethod: String
    let parameters: [String: String]
    var headers: Dictionary<String, String> = [:]
    
    // URL Session
    var dataTask: URLSessionDataTask?
    var request: URLRequest?
    var response: HTTPURLResponse!
    var responseData: Data = Data()
    
    // handler
    var successHandler: SuccessHandler?
    var failureHandler: FailureHandler?

    init (url: URL, method: String = "GET", parameters: [String: String] = [:]) {
        self.url = url
        self.HTTPMethod = method
        self.parameters = parameters
    }
    
    public func start() {
        if request == nil {
            self.request = URLRequest(url: self.url)
            self.request!.httpMethod = self.HTTPMethod
            self.request!.timeoutInterval = self.timeoutInterval
            self.request!.httpShouldHandleCookies = self.hTTPShouldHandleCookies
            
            // Init header
            for (key, value) in headers {
                self.request!.setValue(value, forHTTPHeaderField: key)
            }
            
            os_log("Request: set the header")
            
            //TODO: Set other parameters in headers
        }
        DispatchQueue.main.async {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
            self.dataTask = session.dataTask(with: self.request!)
            self.dataTask?.resume()
            os_log("Start the request: %s", self.dataTask.debugDescription)
        }
        
    }
    
    public func stop() {
        
    }
    
//    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if let error = error {
//            self.failureHandler?(error)
//            return
//        }
//        guard self.successHandler?(self.response)
//    }
    
}
