//
//  TwitterOAuthClientTests.swift
//  ParotterClientTests
//
//  Created by Fan Zhang on 8/22/19.
//  Copyright © 2019 Fan Zhang. All rights reserved.
//

import XCTest
import os.log
@testable import ParotterClient

class OAuthClientTests: XCTestCase {
    var client: OAuthClient!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        client = OAuthClient(consumerKey: "xvz1evFS4wEEPTGEFPHBog", consumerSecret: "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw")
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        client = nil
    }
    
    func testCollectParameter() {
        let parameters = ["include_entities": "true",
                          "oauth_consumer_key": "xvz1evFS4wEEPTGEFPHBog",
                          "oauth_nonce": "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
                          "oauth_signature_method": "HMAC-SHA1",
                          "oauth_timestamp": "1318622958",
                          "oauth_token": "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
                          "oauth_version": "1.0",
                          "status": "Hello Ladies + Gentlemen, a signed OAuth request!"]
        let paramString = client.getParamString(parameters: parameters)
        let expectedString =  "include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21"
        XCTAssertEqual(paramString, expectedString)
    }
    
    func testGetBaseString() {
        let parameters = ["include_entities": "true",
                          "oauth_consumer_key": "xvz1evFS4wEEPTGEFPHBog",
                          "oauth_nonce": "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
                          "oauth_signature_method": "HMAC-SHA1",
                          "oauth_timestamp": "1318622958",
                          "oauth_token": "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
                          "oauth_version": "1.0",
                          "status": "Hello Ladies + Gentlemen, a signed OAuth request!"]
        let baseURL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!
        let paramString = client.getParamString(parameters: parameters)
        let baseString = client.getBaseString(HTTPMethod: "POST", baseURL: baseURL, paramString: paramString)
        let expectedString = "POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521"
        XCTAssertEqual(baseString, expectedString)
    }
    
    func testGetSigningKey() {
        let consumerSecret = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
        let tokenSecret = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
        XCTAssertEqual(client.getSigningKey(consumerSecret: consumerSecret, tokenSecret: tokenSecret), "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE")
    }

    func testGetSignature() {
        // A example from https://developer.twitter.com/en/docs/basics/authentication/guides/creating-a-signature.html
        let parameters = ["include_entities": "true",
                        "oauth_consumer_key": "xvz1evFS4wEEPTGEFPHBog",
                        "oauth_nonce": "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
                        "oauth_signature_method": "HMAC-SHA1",
                        "oauth_timestamp": "1318622958",
                        "oauth_token": "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
                        "oauth_version": "1.0",
                        "status": "Hello Ladies + Gentlemen, a signed OAuth request!"]
        let baseURL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!
        let signature = client.getSignature(for: "POST", url: baseURL, parameters: parameters, tokenSecret: "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE")
        XCTAssertEqual(signature, "hCtSmYh+iHYCEqBWrE7C7hYmtUk=")
    }
    
    func testGetHeader() {
        let parameters = ["oauth_consumer_key": "xvz1evFS4wEEPTGEFPHBog"]
        let baseURL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!

        let headerString = client.getAuthorizationHeader(for: "POST", url: baseURL, parameters: parameters, comsumerKey: "xvz1evFS4wEEPTGEFPHBog", tokenSecret: "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb")
        //TODO: note tested
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
