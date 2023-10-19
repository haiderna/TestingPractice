//
//  PeopleViewModel.swift
//  TestingPractice
//
//  Created by NH on 9/19/23.
//

import Foundation

//@MainActor
final class PeopleViewModel: ObservableObject {
    // only set inside?
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    @Published private(set) var viewState: ViewState?
    private(set) var page = 1
    
    private let networkingManager: NetworkingManagerImpl!
    
    var totalPages: Int?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    // CLOSURE BASED VERSION
//    func fetchUsers() {
//        // background
//        isLoading = true
//        NetworkingManager.shared.request(.people,
//                                         type: UsersResponse.self) { [weak self] res in
//            DispatchQueue.main.async {
//                defer { self?.isLoading = false }
//                switch res {
//                case .success(let response):
//                    // accessed by main
//                        self?.users = response.data
//                case .failure(let error):
//
//                    self?.hasError = true
//                    self?.error = error as? NetworkingManager.NetworkingError
//                }
//            }
//
//        }
//    }
    
    // testing viewstates, getting users when we expect
    // don't wanna test against real service 
    @MainActor /// not everything is on main thread now 
    func fetchUsers() async {
        reset()
        // background
        viewState = .loading
        defer { viewState = .finished }
        
        do {
            
            // suspension point --> waits to store into response & then go into next line
            let response = try await networkingManager.request(session: .shared,
                                                               .people(page: page),
                                                                      type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users = response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfUsers() async {
        
        guard page != totalPages else {
            return
        }
        viewState = .fetching
        defer { viewState = .finished }
        page += 1
        
        do {
            
            // suspension point --> waits to store into response & then go into next line
            let response = try await networkingManager.request(session: .shared, .people(page: page),
                                                                      type: UsersResponse.self)
            self.users += response.data
            self.totalPages = response.totalPages
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachedEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
}
// performing updates from background thread (publisher var in View)
// code -> instructions that need somewhere to run each step
// thread -> set of instructions executed on it
// Process -> execution of program that executes certain tasks on threads 
// Syncronous or async
// sync -> one after another (blocking)
// async -> wait for to finish (nonblocking)
//UI - main thread -> latest and most current data -> Ui always updated on main thread
// UI background -> could be out of sync with application --> don't know when background thread will finish and complete
// fetching data on background
// updating UI on main

extension PeopleViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

private extension PeopleViewModel {
    func reset() {
        if viewState == .finished {
            users.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}
