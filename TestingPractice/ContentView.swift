//
//  ContentView.swift
//  TestingPractice
//
//  Created by NH on 9/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!").onAppear {
                print("users response 😎😎😎")
                dump (
                    try? StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
                )
            }
        }
        .padding()
    }
}

// JSON - how and when it's used (sending and getting data)
// javascript object notation -> sending data over REST API -> one of most common
// collection of object aka dictionary
// data types - strings, number, object, array, bool, null
// date -> ISO8601 year month date time

// POSTMan -> interact with a service --> test against using this
//    Postman - to see endpoints working instead of testing on device
//    Three endpoints --> for getting people and showing on view, for getting a detail of one person and for creating a user

// Codable --> protocol to send and receive data with JOSN and REST API
//transforming our data to JSON represntation (Codable = Decodable && Encodable)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
