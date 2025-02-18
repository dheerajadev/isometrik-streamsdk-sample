//
//  UserAuthenticateResponseModel.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 18/07/24.
//

import Foundation

struct UserAuthBodyData: Encodable {
    let userIdentifier: String?
    let password: String?
}

struct CreateUserBody: Encodable {
    let userProfileImageUrl: String?
    let userName: String?
    let userIdentifier: String?
    let password: String?
}
