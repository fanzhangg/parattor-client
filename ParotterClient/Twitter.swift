//
//  Twitter.swift
//  ParotterClient
//
//  Created by Fan Zhang on 8/23/19.
//  Copyright © 2019 Fan Zhang. All rights reserved.
//

import Foundation

public class Twitter {
    var client: ClientProtocol
    
    // Handler
//    public typealias SuccessHandler = (JSON) -> Void
    public typealias FailureHandler = (_ error: Error) -> Void

    
    public init(consumerKey: String, consumerSecret: String) {
        self.client = OAuthClient(consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
}

// MARK: - Twitter URL
public enum TwitterURL {
    
    case api
    case upload
    case stream
    case publish
    case userStream
    case siteStream
    case oauth
    
    var url: URL {
        switch self {
        case .api:          return URL(string: "https://api.twitter.com/1.1/")!
        case .upload:       return URL(string: "https://upload.twitter.com/1.1/")!
        case .stream:       return URL(string: "https://stream.twitter.com/1.1/")!
        case .userStream:   return URL(string: "https://userstream.twitter.com/1.1/")!
        case .siteStream:   return URL(string: "https://sitestream.twitter.com/1.1/")!
        case .oauth:        return URL(string: "https://api.twitter.com/")!
        case .publish:        return URL(string: "https://publish.twitter.com/")!
        }
    }
}
