//
//  AuthTests.swift
//  ParotterClientTests
//
//  Created by Fan Zhang on 8/23/19.
//  Copyright © 2019 Fan Zhang. All rights reserved.
//

import XCTest
import os.log
@testable import ParotterClient

class AuthTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequestAccessToken() {
        let consumerKey = "VQDFZmAR5pc0bWt1ja6ejK6Gs"
        let consumerSecret = "45h2w0EbZmoYQGUb7PYT7KMekSR0wmfKuqhG1omPNxifKdv23y"
        let twitter = Twitter(consumerKey: consumerKey, consumerSecret: consumerSecret)
        let callback = URL(string: "swifter://success")!
        twitter.authorize(callback: callback, success: <#T##Twitter.TokenSuccessHandler?##Twitter.TokenSuccessHandler?##(String, URLResponse) -> Void#>)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
