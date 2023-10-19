//
//  Symbols.swift
//  TestingPractice
//
//  Created by NH on 9/11/23.
//

import SwiftUI

// enum can't accidentally initialize --> Type safe way to access symbols you want
enum Symbols {
    static let person = Image(systemName: "person.2")
    static let gear = Image(systemName: "gear")
    static let plus = Image(systemName: "plus")
    static let link = Image(systemName: "link")
    static let checkmark = Image(systemName: "checkmark")
    static let refresh = Image(systemName: "arrow.clockwise")
}

// can't create an instance of an ENUM (has static properties)
// prevents mispellings
// do similar for colors 


