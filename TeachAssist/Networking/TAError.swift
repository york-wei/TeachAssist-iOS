//
//  TAError.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-24.
//

import Foundation

enum TAError: String, Error {
    case noConnection = "Connection Error"
    case badRequest = "Could Not Reach TeachAssist"
    case invalidLogin = "Invalid Login"
    case parsingError = "Unexpected Error"
    case unknownError = "Unknown Error"
    
    var description: String {
        return self.rawValue
    }
    
    static func getTAError(_ error: Error) -> TAError {
        guard let error = error as? TAError else {
            return .unknownError
        }
        return error
    }
}
