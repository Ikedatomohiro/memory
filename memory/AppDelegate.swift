//
//  AppDelegate.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/11.
//

import UIKit
import Firebase
import GoogleSignIn
//import FirebaseAuth
//import FirebaseDynamicLinks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // Firebase
        FirebaseApp.configure()

        window = UIWindow(frame: UIScreen.main.bounds)
       
        let eventListVC: EventListViewController = EventListViewController()
        navigationController = UINavigationController(rootViewController: eventListVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}

