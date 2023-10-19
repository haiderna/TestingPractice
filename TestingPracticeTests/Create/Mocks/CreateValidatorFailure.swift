//
//  CreateValidatorFailure.swift
//  TestingPracticeTests
//
//  Created by NH on 10/9/23.
//

import Foundation
@testable import TestingPractice

struct CreateValidatorFailureMock: CreateValidatorImpl {
    func validate(_ person: NewPerson) throws {
        throw CreateValidator.CreateValidatorError.invalidFirstName
    }
}
// to see if validation fails 
