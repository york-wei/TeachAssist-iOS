//
//  TAService.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-02.
//

import Foundation

class TAService {
    
    static let shared = TAService()
    
    func authenticateStudent(username: String,
                             password: String,
                             completion: @escaping (Result<AuthenticationResponse, TAError>) -> ()) {
        // Check connection
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(.noConnection))
            return
        }
        
        URLSession.shared.dataTask(with: getLoginRequest(username: username, password: password)) {
            data, response, error in
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
    
    func fetchCourse(link: String,
                     sessionToken: String,
                     studentId: String,
                     completion: @escaping (Result<FetchCourseResponse, TAError>) -> ()) {
        // Check connection
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(.noConnection))
            return
        }
        
        URLSession.shared.dataTask(with: getCourseFetchRequest(link: link,
                                                               sessionToken: sessionToken,
                                                               studentId: studentId)) {
            data, response, error in
            // Check request
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.badRequest))
                return
            }
            
            // Check data
            guard let dataString = String(data: data, encoding: .utf8) else {
                completion(.failure(.badRequest))
                return
            }
            
            completion(.success(FetchCourseResponse(dataString: dataString)))
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
    
    private func getCourseFetchRequest(link: String, sessionToken: String, studentId: String) -> URLRequest {
        var request = URLRequest(url: TAUrl.courseUrl(link: link))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded",
                                       "Cookie": "session_token=\(sessionToken); student_id=\(studentId)"]
        return request
    }
}
