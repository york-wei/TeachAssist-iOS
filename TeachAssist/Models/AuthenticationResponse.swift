//
//  AuthenticationResponse.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation

class AuthenticationResponse {
    let dataString: String
    let sessionToken: String
    let studentId: String
    init(dataString: String, sessionToken: String, studentId: String) {
        self.dataString = dataString
        self.sessionToken = sessionToken
        self.studentId = studentId
    }
}
