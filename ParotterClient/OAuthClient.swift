//
//  TwitterOAuthClient.swift
//  ParotterClient
//
//  Created by Fan Zhang on 8/22/19.
//  Copyright © 2019 Fan Zhang. All rights reserved.
//

import Foundation

internal class OAuthClient: ClientProtocol {    
    struct OAuth {
        static let version = "1.0"
        static let signatureMethod = "HMAC-SHA1"
    }
    
    var consumerKey: String
    var consumerSecret: String
    
    let dataEncoding: String.Encoding = .utf8

    // temp
    var callback: String
    var url: URL
    
    
    
    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.callback = ""
        self.url = URL(string: "examnpe://")!
    }
    
    func stop() {
        
    }
    
    func post(path: String, baseURL: TwitterURL, parameters: [String: String], success: HTTPRequest.SuccessHandler?, failure: HTTPRequest.FailureHandler?) -> HTTPRequest {
        let url = URL(string: path, relativeTo: baseURL.url)!
        let request = HTTPRequest(url: url, method: "POST", parameters: parameters)
        request.headers = ["Authorization:": self.getAuthorizationHeader(for: "POST", url: url, parameters: parameters, comsumerKey: self.consumerKey)]
        
        request.successHandler = success
        request.failureHandler = failure
        
        request.start()
        return request
    }
    
    // Get authorization header for getting access token in user authentication
    // ref: https://developer.twitter.com/en/docs/basics/authentication/guides/authorizing-a-request
    func getAuthorizationHeader(for method: String, url: URL, parameters: [String: String], comsumerKey: String, tokenSecret: String = "", token: String = "") -> String {
        var oauthParameters = [String: String]()
        oauthParameters["oauth_version"] = "1.0"
        oauthParameters["oauth_signature_method"] = "HMAC-SHA1"
        oauthParameters["oauth_consumer_key"] = consumerKey // identify the application
        oauthParameters["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))  // indicate when the request was created
        oauthParameters["oauth_nonce"] = UUID().uuidString  // a unique token for each unique request
        oauthParameters["oauth_callback"] = self.callback
        if token != "" {  // add `oauth_token` only when it is available
            oauthParameters["oauth_token"] = token// represent permission to share access to the account with the application
        }
        oauthParameters["oauth_signature"] = self.getSignature(for: method, url: url, parameters: parameters, tokenSecret: tokenSecret)
        return "OAuth " + (oauthParameters.compactMap({ (key, value) -> String in
            return "\(key)=\"\(value)\""
        }) as Array).joined(separator: ", ")
    }
    
    /// Convert Parameters to a URL encoded string
    /// - Parameters:
    ///   - parameters: parameters included in the request (queryString, request body, `oauth_*` parameters)
    /// - Returns: A URL encoded string of parameters by:
    ///   - Percent encode every key and value that will be signed.
    ///   - Sort the list of parameters alphabetically [1] by encoded key [2].
    ///   - For each key/value pair:
    ///   - Append the encoded key to the output string.
    ///   - Append the ‘=’ character to the output string.
    ///   - Append the encoded value to the output string.
    ///   - If there are more key/value pairs remaining, append a ‘&’ character to the output string.
    /// - Note: https://developer.twitter.com/en/docs/basics/authentication/guides/creating-a-signature.html
    func getParamString(parameters: [String: String]) -> String {
        let parameterComponents = parameters.urlEncodedQueryString(using: dataEncoding).components(separatedBy: "&").sorted()
        return parameterComponents.joined(separator: "&")
    }
    
    /// Get a base string by combining HTTP Method, Base URL and parameters
    /// - Parameters:
    ///   - HTTPMethod:
    ///   - baseURL:
    ///   - paramString: a string of percentage encoded keys and values
    ///   - HTTP Method: mostly POST and GET
    /// - Returns: A base string by:
    ///   - Convert the HTTP Method to uppercase and set the output string equal to this value.
    ///   - Append the ‘&’ character to the output string.
    ///   - Percent encode the URL and append it to the output string.
    ///   - Append the ‘&’ character to the output string.
    ///   - Percent encode the parameter string and append it to the output string.
    func getBaseString(HTTPMethod: String, baseURL: URL, paramString: String) -> String {
        let encodedMethod = HTTPMethod.uppercased() // convert to upper case
        let urlString = baseURL.absoluteString
        let encodedURL = urlString.urlEncodedString()
        let encodedParam = paramString.urlEncodedString()
        return "\(encodedMethod)&\(encodedURL)&\(encodedParam)"
    }
    
    /// Get the signing key
    /// - parameters:
    ///   - Can be empty
    /// - returns: Percentage encoded consumer secrete + "&" + percentage encoded token secret / ""
    func getSigningKey(consumerSecret: String, tokenSecret: String) -> String {
        let encodedConsumerSecret = consumerSecret.urlEncodedString()
        let encodedTokenSecret = tokenSecret.urlEncodedString()
        return "\(encodedConsumerSecret)&\(encodedTokenSecret)"
    }
    
    /// Get the signature
    /// - returns: a base64 Encoded signature calculated by passing the signature base string and signing key to the HMAC-SHA1 hashing algorithm
    /// - Note:  https://developer.twitter.com/en/docs/basics/authentication/guides/creating-a-signature.html
    func getSignature(for method: String, url: URL, parameters: [String: String], tokenSecret: String) -> String {
        let signingKey = getSigningKey(consumerSecret: self.consumerSecret, tokenSecret: tokenSecret)
        let paramString = getParamString(parameters: parameters)
        let signatureBaseString = getBaseString(HTTPMethod: method, baseURL: url, paramString: paramString)
        let key = signingKey.data(using: .utf8)!
        let msg = signatureBaseString.data(using: .utf8)!
        let sha1 = HMAC.sha1(key: key, message: msg)!
        return sha1.base64EncodedString(options: [])
    }
    
//    func request(){
//        let session = URLSession.shared
//
//        let url = URL(string: "https://api.twitter.com/oauth/request_token")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let oauthString = self.getAuthorizationHeader(url: url)
//
//        request.setValue(oauthString, forHTTPHeaderField: "Authorization")
//
//
//        let json = [
//            "oauth_callback": "VQDFZmAR5pc0bWt1ja6ejK6Gs",
//            "oauth_consumer_key": "swift://success"
//        ]
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
//
//        let task = session.uploadTask(with: request, from: nil) {
//            data, response, error in
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("data: ",dataString)
//            }
//            if let httpResponse = response as? HTTPURLResponse {
//                print("response: ", httpResponse.statusCode)
//            }
//            if (error != nil) {
//                print("Error: \(error!)")
//            }
//        }
//
//        task.resume()
//    }
}

