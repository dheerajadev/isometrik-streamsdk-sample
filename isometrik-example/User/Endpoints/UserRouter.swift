
import UIKit
import IsometrikStream

enum UserRouter: ISMLiveURLConvertible, CustomStringConvertible {
    
    case authenticateUser
    case createUser
    case userDetails
    
    var description: String {
        switch self {
        case .authenticateUser:
            return "get user details."
        case .createUser:
            return "create user."
        case .userDetails:
            return "user details."
        }
    }
    
    var baseURL: URL{
        return URL(string:"https://apis.isometrik.io")!
    }
    
    var method: ISMLiveHTTPMethod {
        switch self {
        case .authenticateUser, .createUser:
            return .post
        case .userDetails:
            return .get
        }
    }
    
    var path: String {
        let path: String
        switch self {
        case .authenticateUser:
            path = "/chat/user/authenticate"
        case .createUser:
            path = "/chat/user"
        case .userDetails:
            path = "chat/user/details"
        }
        return path
    }
    
    var headers: [String : String]?{
        
        var headers: [String: String] = [:]
        
        let userSecret = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDYxMDkyZDY3YzRmYWMzMDAwMTQwNWQ3Zm0AAAAIa2V5c2V0SWRtAAAAJDc2ZWNkZjEwLThlM2ItNGVmZS04NDZkLTU3NDJmODYxZjgzOG0AAAAJcHJvamVjdElkbQAAACQwMTEzYzQ0ZC04NmQzLTQyM2QtYjkyYS0xYmU2NTExZjdiOGZkAAZzaWduZWRuBgDRqeZ4hgE.DkR1H6BMWCQn1njtbaDc8WNBnIdALzjBAs_8Ks7AERE"
        let appSecret = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDYxMDkyZDY3YzRmYWMzMDAwMTQwNWQ3Zm0AAAAIa2V5c2V0SWRtAAAAJDc2ZWNkZjEwLThlM2ItNGVmZS04NDZkLTU3NDJmODYxZjgzOG0AAAAJcHJvamVjdElkbQAAACQwMTEzYzQ0ZC04NmQzLTQyM2QtYjkyYS0xYmU2NTExZjdiOGZkAAZzaWduZWRuBgDRqeZ4hgE.1GhE6fDbTPUWBbHNEptDylNxFHv67AMSH6nWq4OC8pY"
        let licenseKey = "lic-IMK/+mao5KikRmifcmkjavAZa4vGnIwiRTz"
        
        var userToken = ""
        
        if let token = UserDefaults.standard.object(forKey: "USERTOKEN") as? String {
            userToken = token
        }
        
        switch self {
        case .authenticateUser, .createUser:
            headers += [
                "appsecret":"\(appSecret)",
                "licensekey":"\(licenseKey)",
                "usersecret":"\(userSecret)"
            ]
        case .userDetails:
            headers += [
                "appsecret":"\(appSecret)",
                "licensekey":"\(licenseKey)",
                "userToken":"\(userToken)"
            ]
        }
       
        return headers
        
    }
    
    var queryParams: [String : String]? {
        return [:]
    }
    
}

public typealias userPayloadResponse = ((Result<Any?, IsometrikError>) -> Void)

