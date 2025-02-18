import Foundation
import IsometrikStream

struct UserResponseModel: Decodable {
    let userToken: String?
    let userId: String?
    let msg: String?
}

struct UserDetailResponseModel: Decodable {
    let userProfileImageUrl: String?
    let userName: String?
    let userIdentifier: String?
    let userId: String?
    let metaData: UserMetaData?
    
}

struct UserMetaData: Decodable {
    let userName: String?
    let profilePic: String?
    let lastName: String?
    let firstName: String?
}
