//
//  UserDetailResponse.swift
//  TestingPractice
//
//  Created by NH on 9/13/23.
//

import Foundation

struct UserDetailResponse: Codable, Equatable {
    let data: User
    let support: Support
}
