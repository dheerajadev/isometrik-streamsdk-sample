//
//  ViewController.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 01/07/24.
//

import UIKit
import IsometrikStream

class ViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    var isometrik: IsometrikSDK?
    
    // MARK: - MAIN

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = UserDefaults.standard.object(forKey: "USERTOKEN"), let _ = UserDefaults.standard.object(forKey: "USERID") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.initializeApp()
            }
        } else {
            userLogin()
        }
    }
    
    // MARK: - FUNCTIONS
    
    func initializeApp(){
        
        guard let loggedUserId = UserDefaults.standard.object(forKey: "USERID") as? String,
              let loggedUserToken = UserDefaults.standard.object(forKey: "USERTOKEN") as? String
        else { return }
        
        var identifier = ""
        var imagePath = ""
        var name = ""
        
        if let userName = UserDefaults.standard.object(forKey: "USERNAME") as? String {
            identifier = userName
        }
        
        if let profilePic = UserDefaults.standard.object(forKey: "PROFILEURL") as? String {
            imagePath = profilePic
        }
        
        if let fullName = UserDefaults.standard.object(forKey: "NAME") as? String {
            name = fullName
        }
        
        
        let userId = loggedUserId
        let userToken = loggedUserToken
        
        let accountId = "61092d67c4fac30001405d7f"
        let projectId = "0113c44d-86d3-423d-b92a-1be6511f7b8f"
        let keySetId = "76ecdf10-8e3b-4efe-846d-5742f861f838"
        let licensekey = "lic-IMK/+mao5KikRmifcmkjavAZa4vGnIwiRTz"
        let appSecret = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDYxMDkyZDY3YzRmYWMzMDAwMTQwNWQ3Zm0AAAAIa2V5c2V0SWRtAAAAJDc2ZWNkZjEwLThlM2ItNGVmZS04NDZkLTU3NDJmODYxZjgzOG0AAAAJcHJvamVjdElkbQAAACQwMTEzYzQ0ZC04NmQzLTQyM2QtYjkyYS0xYmU2NTExZjdiOGZkAAZzaWduZWRuBgDRqeZ4hgE.1GhE6fDbTPUWBbHNEptDylNxFHv67AMSH6nWq4OC8pY"
        let userSecret = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDYxMDkyZDY3YzRmYWMzMDAwMTQwNWQ3Zm0AAAAIa2V5c2V0SWRtAAAAJDc2ZWNkZjEwLThlM2ItNGVmZS04NDZkLTU3NDJmODYxZjgzOG0AAAAJcHJvamVjdElkbQAAACQwMTEzYzQ0ZC04NmQzLTQyM2QtYjkyYS0xYmU2NTExZjdiOGZkAAZzaWduZWRuBgDRqeZ4hgE.DkR1H6BMWCQn1njtbaDc8WNBnIdALzjBAs_8Ks7AERE"
        let rtcAppId = "55d24a4c22ba4577877be9705b24be09"
        
        let userData = ISMStreamUser(
            userId: userId,
            identifier: identifier,
            name: name,
            imagePath: imagePath,
            userToken: userToken
        )
        
        let streamOptionsConfig = ISMOptionsConfiguration(
            enableProfileDelegate: true,
            enableGroupStream: true,
            enablePKStream: true,
            enableProductInStream: false,
            enableRTMPStream: true,
            enablePaidStream: true,
            enableRestream: true,
            enableScheduleStream: true
        )
        
        IsometrikSDK.getInstance().createConfiguration(
            accountId: accountId,
            projectId: projectId,
            keysetId: keySetId,
            licenseKey: licensekey,
            appSecret: appSecret,
            userSecret: userSecret,
            rtcAppId: rtcAppId,
            userInfo: userData,
            streamOptionsConfiguration: streamOptionsConfig
        )
        
        UserDefaultsProvider.shared.setIsometrikDefaultProfile(imageStringUrl: "https://www.gravatar.com/avatar/?d=identicon")
        ISMLogManager.shared.isLoggingEnabled = true
        
        isometrik = IsometrikSDK.getInstance()
        
        guard let isometrik else { return }
        
        let homeViewModel = StreamListViewModel(isometrik: isometrik)
        homeViewModel.changeUser_actionCallback = { [weak self] in
            self?.userLogin()
        }
        
        let VC = StreamListViewController(viewModel: homeViewModel)
        let navVC = UINavigationController(rootViewController: VC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: false)
        
    }
    
    func userLogin(){
        DispatchQueue.main.async {
            let userViewModel = UserViewModel()
            userViewModel.action_callback = { [weak self] in
                guard let self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.initializeApp()
                }
            }
            
            let controller = LoginUserViewController(viewModel: userViewModel)
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: false)
        }
    }
    
}

