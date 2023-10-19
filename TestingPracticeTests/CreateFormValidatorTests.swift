//
//  CreateFormValidatorTests.swift
//  TestingPracticeTests
//
//  Created by NH on 9/19/23.
//

import XCTest
@testable import TestingPractice

// unit tests -> asserting values means does outcome match what you provided/expect 

final class CreateFormValidatorTests: XCTestCase {
    
    private var validator: CreateValidator! // never nil -> setup between tests
    
    
    override func setUp() {
        // same each time
        validator = CreateValidator()
    }
    
    override func tearDown() {
        validator = nil
    }
    
    func test_with_empty_entire_first_name_thrown() {
        // diff each time
        let person = NewPerson()
        
        XCTAssertThrowsError(try validator.validate(person))
        
        do {
            _ = try validator.validate(person)
            
        } catch {
            guard let validationError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("wrong type of error")
                return
            }
            
            XCTAssertEqual(validationError, CreateValidator.CreateValidatorError.invalidFirstName)
        }
    }
    
    func test_with_empty_first_name_error_thrown() {
        let person = NewPerson(lastName: "H", job: "Senior iOS Dev")
        
        XCTAssertThrowsError(try validator.validate(person))
        
        do {
            _ = try validator.validate(person)
            
        } catch {
            guard let validationError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("wrong type of error")
                return
            }
            
            XCTAssertEqual(validationError, CreateValidator.CreateValidatorError.invalidFirstName)
        }
        
    }
    
    func test_with_empty_last_name_error_thrown() {
        let person = NewPerson(firstName: "N", job: "Senior iOS Dev")
        
        XCTAssertThrowsError(try validator.validate(person))
        
        do {
            _ = try validator.validate(person)
            
        } catch {
            guard let validationError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("wrong type of error")
                return
            }
            
            XCTAssertEqual(validationError, CreateValidator.CreateValidatorError.invalidLastName)
        }
        
    }
    
    func test_with_empty_job_error_thrown() {
        let person = NewPerson(firstName: "person", lastName: "lastName")
        
        XCTAssertThrowsError(try validator.validate(person))
        
        do {
            _ = try validator.validate(person)
            
        } catch {
            guard let validationError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("wrong type of error")
                return
            }
            
            XCTAssertEqual(validationError, CreateValidator.CreateValidatorError.invalidJob)
        }
        
    }
    
    func test_with_valid_person_no_error_thrown() {
        let person = NewPerson(firstName: "N", lastName: "H", job: "Senior iOS Dev")

        do {
            _ = try validator.validate(person)
            
        } catch {
            XCTFail("No errror should be thrown -> shouldn't get to this point")
        }
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
