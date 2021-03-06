/*

 ValidationResultTests.swift
 Validator

 Created by @adamwaite.

 Copyright (c) 2015 Adam Waite. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

*/

import XCTest
@testable import Validator

class ValidationResultTests: XCTestCase {
    
    func testThatAValidResultIsDeemedValid() {
        let valid = ValidationResult.Valid
        XCTAssertTrue(valid.isValid)
       
        let err = testError
        
        let invalid = ValidationResult.Invalid([err])
        XCTAssertFalse(invalid.isValid)
    }
    
    func testThatItCanBeMergedWithOtherValidationResults() {
        
        let success1 = ValidationResult.Valid
        let success2 = ValidationResult.Valid
        let err1 = testError
        let err2 = ValidationError(message: "💣💣")
        
        let fail1 = ValidationResult.Invalid([err1])
        let fail2 = ValidationResult.Invalid([err2])
        
        let sbj1 = success1.merge(success2)
        XCTAssertEqual(sbj1, ValidationResult.Valid)
        
        let sbj2 = success1.merge(fail1)
        XCTAssertEqual(sbj2, ValidationResult.Invalid([err1]))

        let sbj3 = fail1.merge(fail2)
        XCTAssertEqual(sbj3, ValidationResult.Invalid([err1, err2]))

        let sbj4 = sbj3.merge(sbj3)
        XCTAssertEqual(sbj4, ValidationResult.Invalid([err1, err2, err1, err2]))
        
    }
    
    func testThatMultipleResultsCanBeCombined() {
        let success1 = ValidationResult.Valid
        let success2 = ValidationResult.Valid
        let err1 = testError
        let err2 = ValidationError(message: "💣💣")
        let fail1 = ValidationResult.Invalid([err1])
        let fail2 = ValidationResult.Invalid([err2])

        let results: [ValidationResult] = [success1, success2, fail1, fail2]
        let combined = ValidationResult.combine(results)
        XCTAssertEqual(combined, ValidationResult.Invalid([err1, err2]))
    }
    
}