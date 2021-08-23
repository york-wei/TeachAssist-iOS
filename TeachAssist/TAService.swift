//
//  TAService.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-02.
//

import Foundation
import Alamofire

enum TAServiceError: Error {
    case noConnection
    case badRequest
    case invalidLogin
}

class TAService {
    
    static let shared = TAService()
    
    func authenticateStudent(username: String,
                             password: String,
                             completion: @escaping (Result<AuthenticationResponse, TAServiceError>) -> ()) {
        // Check connection
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(.noConnection))
            return
        }
        
        URLSession.shared.dataTask(with: getLoginRequest(username: username, password: password)) { data, response, error in
            // Check request
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.badRequest))
                return
            }
            
            // Check login
            guard let responseUrl = response.url,
                  responseUrl != TAUrl.errorUrl,
                  !username.isEmpty,
                  !password.isEmpty else {
                completion(.failure(.invalidLogin))
                return
            }
            
            // Check data
            guard let dataString = String(data: data, encoding: .utf8),
                  let cookies = HTTPCookieStorage.shared.cookies,
                  cookies.count >= 2 else {
                completion(.failure(.badRequest))
                return
            }
            
            completion(.success(AuthenticationResponse(dataString: dataString,
                                                       sessionToken: cookies[0].value,
                                                       studentId: cookies[1].value)))
        }.resume()
    }
}

extension TAService {
    private func getLoginRequest(username: String, password: String) -> URLRequest {
        var request = URLRequest(url: TAUrl.loginUrl)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "subject_id", value: "0"),
                                            URLQueryItem(name: "username", value: username),
                                            URLQueryItem(name: "password", value: password),
                                            URLQueryItem(name: "submit", value: "Login")]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        return request
    }
}
