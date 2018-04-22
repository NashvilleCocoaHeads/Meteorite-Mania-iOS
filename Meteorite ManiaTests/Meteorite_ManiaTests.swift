//
//  Meteorite_ManiaTests.swift
//  Meteorite ManiaTests
//
//  Created by Jonathan Wiley on 4/18/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import XCTest
@testable import Meteorite_Mania

class Meteorite_ManiaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testImportNASAMeteoritesCSVPerformance() {
        // This is an example of a performance test case.
        self.measure {
            MeteoritesCoreDataStore.importNASAMeteoritesCSV(csvFileName: "Meteorite_Landings_First_1000")
        }
    }
    
}
