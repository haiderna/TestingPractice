//
//  Models.swift
//  TestingPractice
//
//  Created by NH on 9/13/23.
//

import Foundation

struct User: Codable, Equatable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
}

struct Support: Codable, Equatable {
    let url: String
    let text: String
}
