//
//  UserViewModel.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 24/07/24.
//

import Foundation
import IsometrikStream
import IsometrikStreamUI

struct UserData {
    let userName: String
    let userIdentifier: String
    let password: String
}

enum SignupInputField: Int {
    case userName = 0
    case email
    case password
    case confirmPassword
}

let demoUsers = [
    UserData(userName: "Monikahi", userIdentifier: "6583075c0308465abfea17fe", password: "6583075c0308Da$"),
    UserData(userName: "Krutin", userIdentifier: "64df4c2c768dfe8eec21d5ce", password: "64df4c2c768dDa$"),
    UserData(userName: "Hero", userIdentifier: "654b37e21b05bd7a84c763b4", password: "654b37e21b05Da$")
]

class UserViewModel {
    
    // MARK: - PROPERTIES
    
    var userName: String = ""
    var password: String = ""
    var profilePic: String = "https://picsum.photos/500/500"
    var userIdentifier: String = ""
    var userDetails: UserDetailResponseModel?
    
    var validPass: Bool = false
    var validConfirmPass: Bool = false
    
    var secureEntry = true
    var confirmPassSecureEntry = true
    
    var action_callback: (()->Void)?
    var logout_callback: (()->Void)?
    
    // MARK: - FUNCTIONS
    
    func loginUser(completion: @escaping(Bool, String?)->Void){
        
        UserRequest.shared.authenticateUser(userName: userName, password: password) { response in
            
            let userId = response.userId.unwrap
            let userToken = response.userToken.unwrap
            UserDefaults.standard.set(userId, forKey: "USERID")
            UserDefaults.standard.set(userToken, forKey: "USERTOKEN")
            
            self.getUserDetails { success,error in
                if success {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                let errorMessage = CustomErrorHandler.getErrorMessage(error)
                completion(false, errorMessage)
            }
        }
        
    }
    
    func createUser(completion: @escaping(Bool, String?)->Void) {
        let bodyData = CreateUserBody(userProfileImageUrl: profilePic, userName: userName, userIdentifier: userIdentifier, password: password)
        UserRequest.shared.createUser(bodyData: bodyData) { response in
            
            let userId = response.userId.unwrap
            let userToken = response.userToken.unwrap
            UserDefaults.standard.set(userId, forKey: "USERID")
            UserDefaults.standard.set(userToken, forKey: "USERTOKEN")
            
            self.getUserDetails { success,error in
                if success {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                let errorMessage = CustomErrorHandler.getErrorMessage(error)
                completion(false, errorMessage)
            }
        }
    }
    
    func getUserDetails(completion: @escaping(Bool, String?)->Void){
        UserRequest.shared.userDetails { response in
            
            let profilePic = response.userProfileImageUrl.unwrap
            var fullName = ""
            var userName = ""
            var userIdentifier = ""
            
            if !response.userName.unwrap.isEmpty {
                userName = response.userName.unwrap
            }
            
            if !response.userIdentifier.unwrap.isEmpty {
                userIdentifier = response.userIdentifier.unwrap
            }
            
            if let metaData = response.metaData {
                if !metaData.firstName.unwrap.isEmpty || !metaData.lastName.unwrap.isEmpty {
                    fullName = "\(metaData.firstName.unwrap) \(metaData.lastName.unwrap)"
                } else {
                    fullName = userName
                }
                
                if !metaData.userName.unwrap.isEmpty {
                    userName = metaData.userName.unwrap
                }
            }
            
            UserDefaults.standard.set(profilePic, forKey: "PROFILEURL")
            UserDefaults.standard.set(userName, forKey: "USERNAME")
            UserDefaults.standard.set(fullName, forKey: "NAME")
            
            DispatchQueue.main.async {
                self.userDetails = response
                completion(true, nil)
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                completion(false, "Unknown error!")
            }
        }
    }
    
    func resetUserDefaults(){
        UserDefaults.standard.removeObject(forKey: "USERID")
        UserDefaults.standard.removeObject(forKey: "USERTOKEN")
        UserDefaults.standard.removeObject(forKey: "USERNAME")
        UserDefaults.standard.removeObject(forKey: "PROFILEURL")
        UserDefaults.standard.removeObject(forKey: "NAME")
        UserDefaults.standard.synchronize()
    }
    
    func validatePassword(_ password: String) -> String? {
        let capitalLetterRegEx = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = texttest.evaluate(with: password)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = numberTest.evaluate(with: password)
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let specialCharacterTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = specialCharacterTest.evaluate(with: password)
        
        let lengthResult = password.count > 8
        
        if !capitalResult {
            return "Password must contain at least one capital letter."
        }
        if !numberResult {
            return "Password must contain at least one number."
        }
        if !specialResult {
            return "Password must contain at least one special character."
        }
        if !lengthResult {
            return "Password must be more than 8 characters long."
        }
        
        return nil
    }
    
}

