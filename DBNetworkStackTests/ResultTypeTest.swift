//
//  ResultTypeTest.swift
//  DBNetworkStack
//
//	Legal Notice! DB Systel GmbH proprietary License!
//
//	Copyright (C) 2015 DB Systel GmbH
//	DB Systel GmbH; Jürgen-Ponto-Platz 1; D-60329 Frankfurt am Main; Germany; http://www.dbsystel.de/

//	This code is protected by copyright law and is the exclusive property of
//	DB Systel GmbH; Jürgen-Ponto-Platz 1; D-60329 Frankfurt am Main; Germany; http://www.dbsystel.de/

//	Consent to use ("licence") shall be granted solely on the basis of a
//	written licence agreement signed by the customer and DB Systel GmbH. Any
//	other use, in particular copying, redistribution, publication or
//	modification of this code without written permission of DB Systel GmbH is
//	expressly prohibited.

//	In the event of any permitted copying, redistribution or publication of
//	this code, no changes in or deletion of author attribution, trademark
//	legend or copyright notice shall be made.
//
//  Created by Lukas Schmidt on 01.09.16.
//

import XCTest
@testable import DBNetworkStack

struct Error: JSONMappable, RootKeyProviding {
    let description: String
    init(object: Dictionary<String, AnyObject>) throws {
        description = object["description"] as! String
    }
    
    static func rootKey() -> String {
        return "error"
    }
}

extension Train: RootKeyProviding {
    static func rootKey() -> String {
        return "train"
    }
}

class ResultTypeTest: XCTestCase {
   
    
    func testValidResult() {
        let json = "{\"train\": { \"name\": \"ICE\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let dict = try! NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments) as! Dictionary<String, AnyObject>
        let result: Result<Train, Error> = try! Result(object: dict)
        
        switch result {
        case .sucess(let result):
            XCTAssertEqual(result.name, "ICE")
        case .error:
            XCTFail()
        }
    }
    
    func testErrorResult() {
        let json = "{\"error\": { \"description\": \"text\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let dict = try! NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments) as! Dictionary<String, AnyObject>
        let result: Result<Train, Error> = try! Result(object: dict)
        
        switch result {
        case .sucess:
            XCTFail()
        case .error(let result):
            XCTAssertEqual(result.description, "text")
        }
    }
}
