//
//  UserRequest.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 18/07/24.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI

class UserRequest {
    
    static let shared = UserRequest()
    
    func authenticateUser(userName: String, password: String, completionHandler: @escaping (UserResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let bodyData = UserAuthBodyData(userIdentifier: userName, password: password)
        let request = ISMLiveAPIRequest(endPoint: UserRouter.authenticateUser, requestBody: bodyData)
        CustomLoader.shared.startLoading()
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<UserResponseModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let response, _) :
                DispatchQueue.main.async {
                    completionHandler(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    func createUser(bodyData: CreateUserBody, completionHandler: @escaping (UserResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request = ISMLiveAPIRequest(endPoint: UserRouter.createUser, requestBody: bodyData)
        CustomLoader.shared.startLoading()
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<UserResponseModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let response, _) :
                DispatchQueue.main.async {
                    completionHandler(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
    func userDetails(completionHandler: @escaping (UserDetailResponseModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request = ISMLiveAPIRequest<Any>(endPoint: UserRouter.userDetails, requestBody: nil)
        CustomLoader.shared.startLoading()
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<UserDetailResponseModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let response, _) :
                DispatchQueue.main.async {
                    completionHandler(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
    }
    
}
