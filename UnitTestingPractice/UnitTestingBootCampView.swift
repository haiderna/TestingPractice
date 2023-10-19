//
//  UnitTestingBootCampView.swift
//  TestingPractice
//
//  Created by NH on 10/19/23.
//

import SwiftUI

// unit tests -> business logic (VM, data service, utility)
// UI tests -> testing UI

struct UnitTestingBootCampView: View {
    @StateObject var vm: UnitTestingBootCampViewModel
    
    init(isPremium: Bool) {
        // setting up property wrapper
        _vm = StateObject(wrappedValue: UnitTestingBootCampViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

struct UnitTestingBootCampView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTestingBootCampView(isPremium: true)
    }
}
