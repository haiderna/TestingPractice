//
//  NetworkingManager.swift
//  TestingPractice
//
//  Created by NH on 9/15/23.
//

import Foundation

protocol NetworkingManagerImpl {
    
    func request<T: Codable>(session: URLSession,
                             _ endPoint: Endpoint,
                             type: T.Type) async throws -> T
    
    func request(session: URLSession,
                 _ endpoint: Endpoint) async throws
}

//Singleton - create once and use everywhere
// needs to be class because reference type
final class NetworkingManager: NetworkingManagerImpl {
    
    static let shared = NetworkingManager() // only ever have one
    
    // so you can't make it anywhere else
    private init() {}
    // closures --> update to use concurrency
    // concurrency - easier, readable, error cases
    
    ///
    // CLOSURE BASED
    ///
    //
//    func request<T: Codable>(_ endPoint: Endpoint,
//                             type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//
//        guard let url = endPoint.url else {
//            completion(.failure(NetworkingError.invalidUrl))
//            return
//        }
//
//        let request = buildRequest(from: url, methodType: endPoint.methodType)
//
//        // can't use return type in closure
//        // closure based here
//        let data = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.custom(error: error!)))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NetworkingError.invalidData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let res = try decoder.decode(T.self, from: data)
//                completion(.success(res))
//            } catch {
//
//                completion(.failure(NetworkingError.failedToDecode(error: error)))
//            }
//        }
//
//
//        data.resume() // won't see request being made if you don't include this
//    }
    
    //
    //
    // ASYNC VERSION
    //
    //
    
    func request<T: Codable>(session: URLSession = .shared,
                             _ endPoint: Endpoint,
                             type: T.Type) async throws -> T {
        
        // check if URL is valid
        guard let url = endPoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        // build request
        let request = buildRequest(from: url, methodType: endPoint.methodType)
        
        // try fetch request
        let (data, response) = try await session.data(for: request)
        //check status code
        guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        // decode data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let res = try decoder.decode(T.self, from: data)
        // return data
        return res
    }
    
    // method overloading
    // CLOSURE BASED
//    func request(_ endpoint: Endpoint,
//                 completion: @escaping (Result<Void, Error>) -> Void) {
//        // check to see if you're within status code
//        guard let url = endpoint.url else {
//            completion(.failure(NetworkingError.invalidUrl))
//            return
//        }
//
//        let request = buildRequest(from: url, methodType: endpoint.methodType)
//
//        // can't use return type in closure
//        let data = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.custom(error: error!)))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
//                return
//            }
//
//            completion(.success(()))
//
//        }
//
//
//        data.resume()
//    }
    
    func request(session: URLSession = .shared,
                 _ endpoint: Endpoint) async throws {
        // check to see if you're within status code
        
        guard let url = endpoint.url else {
           throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (_, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
    }
}

extension NetworkingManager {
    enum NetworkingError: LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension NetworkingManager.NetworkingError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL isnt' valid"
        default:
            return "other"
        }
    }
}

extension NetworkingManager.NetworkingError: Equatable {
    static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidUrl, .invalidUrl): return true
        case (.custom(let lhsType), .custom(let rhsType)): return lhsType.localizedDescription == rhsType.localizedDescription
        case (.invalidStatusCode(statusCode: let lhsType), .invalidStatusCode(statusCode: let rhsType)):
            return lhsType == rhsType
        case (.invalidData, .invalidData): return true
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)): return lhsType.localizedDescription == rhsType.localizedDescription
        default: return false
            
        }
    }
    
    
}

// private extension --> not outside networkingmanager

private extension NetworkingManager {
    func buildRequest(from url: URL,
                      methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        }
        return request
    }
}

// 💉💉💉💉 DEPENDENCY INJECTION 💉💉💉💉 //
// an object or function depends on another for a piece of functionality
// Best for separation of concerns and minmize files
// reusability -> reuse code for testing (aka networking manager) call nm instead of doing func each time
//easier to test -> breaking up business logic makes it easier to test
// protocols to inject dep of similar types
// protocols aka define a blueprint of methods and properties
// integration and unit tests especially --> don't test against real service
// if API goes down, so does test --> focus on business logic (stubbing and mocks)
// mocks vs stubs - allow fake flow and data
// stub - simple fake object to help with tests (fake data from fake service)
// Mock - helps stimulate interactions and data that we want to send back -> verifying a fake request -> correct data --> to validate a flow
// stub -> stub validation code --> stub data for true or false (person with no last name)
// mock networking manager for entire flow
// could also do a mock for validator 
