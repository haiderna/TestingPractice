//
//  PeopleView.swift
//  TestingPractice
//
//  Created by NH on 9/14/23.
//

import Foundation
import SwiftUI

struct PeopleView: View {
    //lazygrid -> Two column layout
    
    @StateObject private var vm = PeopleViewModel()
    private let colums = Array(repeating: GridItem(.flexible()), count: 2)
    @State private var shouldShowCreate = false
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                if vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: colums, spacing: 16) {
                            ForEach(vm.users, id: \.id) { user in
                                NavigationLink {
                                    DetailView(userId: user.id)
                                } label: {
                                    PersonItemView(user: user)
                                        .task {
                                            if vm.hasReachedEnd(of: user) && !vm.isFetching {
                                                await vm.fetchNextSetOfUsers()
                                                // potential issue -> trigger calls all at the start -> check state of vm to prevent this 
                                            }
                                    }
                                }
                              
                            }
                        }
                        .padding()
                       
                    }
                    .overlay(alignment: .bottom) {
                        if vm.isFetching {
                            ProgressView()
                        }
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    create
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    refresh
                }
            }
            .onAppear {
//                vm.fetchUsers()
                // how to do async from here
                // 1) task Closure -> but not recommended
                // 2) Use task modifier -> allows you to kick of async task when view appears -> automatically cancels for you
            }
            .task {
                // task modifier is on appear basically
                // better to make it onLoad --> then choose to refresh via button
                if !hasAppeared {
                    await vm.fetchUsers()
                    hasAppeared = true
                }
               
            }
            .sheet(isPresented: $shouldShowCreate) {
                CreateView()
                    .onAppear {
                    haptic(.success)
                }
            }
            .alert(isPresented: $vm.hasError,
                   error: vm.error) {
                Button("Retry") {
                    Task {
                        await vm.fetchUsers()
                    }
                    // Can't use task modifier because it happens after tap --> async after tap not waiting for it to appear
                    // use Task closure here
                }
            }
            
        }
        
    }
}

private extension PeopleView {
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    var create: some View {
        Button {
            shouldShowCreate.toggle()
        } label: {
            Symbols.plus
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                )
        }
        .disabled(vm.isLoading)
    }
    
    var refresh: some View {
        Button {
            Task {
                await vm.fetchUsers()
            }
        } label: {
            Symbols.refresh
        }
        .disabled(vm.isLoading)
    }
    
    
}

// MVVM architecture
// model view, viewModel
// easily separate out logic and view code
// model = data layer
// view = ui
// viewmodel = business logic
// separate concerns --> good for unit testing and reusability

/// 📜📜📜📜📑📑📑 PAGINATION + Infinite Scrolling 📚📚📚📚📚
///  1) Go to API
///  2) Add a query string to specify pages
///  3) Allow users to scroll through pages, when you get to certain item it fetches next set
///  4) Create a property to allow someone to pass in pages number 

// fetching more data on loading
// whenever you see tracy -> make another call to the service to get page 2
// vm -> func tto tell you when you reach end 
