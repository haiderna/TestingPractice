//
//  CreateViewModel.swift
//  TestingPractice
//
//  Created by NH on 9/20/23.
//

import Foundation

final class CreateViewModel: ObservableObject {
    @Published var person = NewPerson()
    @Published private(set) var state: SubmissionState?
    // different types of Error = Form Error (both validation and network errors
    @Published private(set) var error: FormError?
    @Published var hasError = false
    
    private let networkingManager: NetworkingManagerImpl
    private let validator: CreateValidatorImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared, validator: CreateValidatorImpl = CreateValidator()) {
        self.networkingManager = networkingManager
        self.validator = validator
    }
    
    @MainActor
    func create() async {
        do {
            // successful submission
            try validator.validate(person) // dependent -> inject instead for a mock 
            
            state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(person)
            
            try await networkingManager.request(session: .shared, .create(submissionData: data)) // dependent -> inject instead for a mock
            
            state = .successful
        } catch {
            // test that errors are thrown
            self.hasError = true
            self.state = .unsuccessful
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            case is CreateValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
    }
    
//    func create() {
//
//        do {
//
//            try validator.validate(person)
//
//            state = .submitting
//            // need to pass person to NetworkManager
//            // can do that by passing in data
//
//            // convert model into data
//            let encoder = JSONEncoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
//            let data = try? encoder.encode(person)
//
//            // make post request
//            NetworkingManager.shared.request(.create(submissionData: data)) { [weak self] res in
//                DispatchQueue.main.async {
//                    switch res {
//                    case .success:
//                        self?.state = .successful
//                        self?.hasError = false
//                    case .failure(let error):
//                        self?.hasError = true
//                        if let networkError = error as? NetworkingManager.NetworkingError {
//                            self?.error = .networking(error: networkError)
//
//                        }
//                    }
//                }
//            }
//
//        } catch {
//            self.hasError = true
//            if let validationError = error as? CreateValidator.CreateValidatorError {
//                self.error = .validation(error: validationError)
//            }
//            print(error)
//        }
//
//
//    }
   
    
}
extension CreateViewModel {
    enum SubmissionState {
        case unsuccessful
        case successful
        case submitting
    }
}

extension CreateViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(error: let err),
                .validation(error: let err):
            return err.errorDescription
        case .system(error: let err):
            return err.localizedDescription
        }
    }
}

extension CreateViewModel.FormError: Equatable {
    static func == (lhs: CreateViewModel.FormError, rhs: CreateViewModel.FormError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.validation(let lhsType), .validation(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false 
        }
    }
    
    
}
