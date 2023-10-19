//
//  JSONMaperTests.swift
//  TestingPracticeTests
//
//  Created by NH on 9/29/23.
//

import Foundation
import XCTest
@testable import TestingPractice

class JSONMapperTests: XCTestCase {
    
    func test_with_valid_json_successfully_decodes() {
        XCTAssertNoThrow(try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self), "no error should be thrown")
        
        let usersResponse = try? StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        XCTAssertNotNil(usersResponse?.data, "Shouldn't be nil")
        XCTAssertEqual(usersResponse?.page, 1)
        XCTAssertEqual(usersResponse?.perPage, 6)
        XCTAssertEqual(usersResponse?.total, 12)
        XCTAssertEqual(usersResponse?.totalPages, 2)
        
        XCTAssertEqual(usersResponse?.data.count, 6)
        
        // testing further down parts of file
        
        XCTAssertEqual(usersResponse?.data[0].id, 1)
        XCTAssertEqual(usersResponse?.data[1].id, 2)
        
    }
    
    func test_with_missing_file_error_thrown() {
        
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "", type: UsersResponse.self))
        do {
            _ = try StaticJSONMapper.decode(file: "", type: UsersResponse.self)
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                // not a mapping error --> can decode empty file just nothing there
                XCTFail("This is wrong type of error")
                return
            }
            
            XCTAssertEqual(mappingError, StaticJSONMapper.MappingError.failedToGetContents)
        }
    }
    
    func test_with_invalid_file_name_error_thrown() {
        
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "asfasdfasdf", type: UsersResponse.self))
        do {
            _ = try StaticJSONMapper.decode(file: "", type: UsersResponse.self)
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is wrong type of error")
                return
            }
            
            XCTAssertEqual(mappingError, StaticJSONMapper.MappingError.failedToGetContents)
        }
    }
    
    func test_with_invalid_json_error_thrown() {
        // wrong type on purpose
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "UsersStaticData", type: UserDetailResponse.self))
        
        do {
            _ = try StaticJSONMapper.decode(file: "UsersStaticData", type: UserDetailResponse.self)
        } catch {
            if error is StaticJSONMapper.MappingError {
                XCTFail("not supposed to be a mapping error -> shouldn't decode anything")
            }
        }
    }
}
