//
//  UsersResponse.swift
//  TestingPractice
//
//  Created by NH on 9/13/23.
//

import Foundation

struct UsersResponse: Codable, Equatable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
    
}
