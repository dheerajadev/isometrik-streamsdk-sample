//
//  AppDelegate.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 01/07/24.
//

import UIKit
import netfox
import IsometrikStreamUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startLogger()
        ISMIAPManager.shared.startObserving()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func startLogger(){
        NFX.sharedInstance().start()
        NFX.sharedInstance().ignoreURLs(["https://lh3.googleusercontent.com",
                                         "https://graph.facebook.com",
                                         "https://iid.googleapis.com",
                                         "https://googleads.g.doubleclick.net",
                                         "https://data.mongodb-api.com",
                                         "https://firebaselogging-pa.googleapis.com","https://app-measurement.com"])
    }


}

