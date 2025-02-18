//
//  SceneDelegate.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 01/07/24.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        // example showing customizing apperance (images,fonts, colors)
        ISMAppearance.default.colors.appColor = UIColor(red: 202/255, green: 220/255, blue: 252/255, alpha: 1) 
        ISMAppearance.default.colors.appSecondary = UIColor(red: 0/255, green: 36/255, blue: 107/255, alpha: 1)
        
        //ISMAppearance.default.images.analytics = UIImage(systemName: "rectangle.portrait.and.arrow.forward")!
        //ISMAppearance.default.colors.appColor = .red
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        ISMIAPManager.shared.stopObserving()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        ISMIAPManager.shared.startObserving()
    }

    // MARK: - Apple Universal Link
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL,
              let components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            return
        }
        
        // Extract the path components
        let pathComponents = components.path.split(separator: "/")

        // Ensure that the path is in the expected format
        guard pathComponents.count > 1, pathComponents[0] == "stream" else {
            return
        }
        
        // The stream ID is the last component in the path
        let streamId = String(pathComponents.last ?? "")
        
        let isometrikInstance = IsometrikSDK.getInstance()
        let externalActions = ISMExternalActions(isometrik: isometrikInstance)
        externalActions.openStream(streamId: streamId, scene: scene as? UIWindowScene)
        
    }
    
    //:
    
}

