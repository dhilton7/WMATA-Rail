//
//  WMATASwiftTests.swift
//  WMATASwiftTests
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import WMATASwift

class WMATASwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let wrapper = WMATASwift(apiKey: "6b700f7ea9db408e9745c207da7ca827")
        let expectation = expectationWithDescription("Get next train")

        wrapper.getNextTrain("B03", success: { (json:JSON) in
            expectation.fulfill()
        }) { (error:NSError) in
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectationsWithTimeout(10) { error in
            if (error != nil) {
                XCTFail(error!.description)
            }
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
