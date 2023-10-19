//
//  DetailViewModel.swift
//  TestingPractice
//
//  Created by NH on 9/20/23.
//

import Foundation

final class DetailViewModel: ObservableObject {
    // source of truth for updates
    @Published private(set) var userInfo: UserDetailResponse?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    @Published private(set) var isLoading = false
    
    private let networkingManager: NetworkingManagerImpl
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
//    func fetchDetails(for id: Int) {
//        isLoading = true
//        NetworkingManager.shared.request(.detail(id: id),
//                                         type: UserDetailResponse.self) { [weak self] res in
//            DispatchQueue.main.async {
//                defer {
//                    self?.isLoading = false
//                }
//                switch res {
//                case .success(let response):
//                    // accessed by main
//                    self?.userInfo = response
//                case .failure(let error):
//                    self?.hasError = true
//                    self?.error = error as? NetworkingManager.NetworkingError
//                }
//            }
//
//        }
//    }
    
    @MainActor
    func fetchDetails(for id: Int) async {
        // background
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            // suspension point --> waits to store into response & then go into next line
            self.userInfo = try await networkingManager.request(session: .shared, .detail(id: id),
                                                                      type: UserDetailResponse.self)
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
