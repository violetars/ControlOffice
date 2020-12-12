//
//  AppDelegate.swift
//  FirebaseLoginAndSignUp
//
//  Created by Violeta Recio Sansón on 27/11/2020.
//

import UIKit
import Firebase
import CoreLocation

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var locationManager : CLLocationManager?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		locationManager = CLLocationManager()
		locationManager?.requestWhenInUseAuthorization()
		FirebaseApp.configure()
		return true

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UINavigationController(rootViewController: MainHomeViewController())
		window?.makeKeyAndVisible()
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


}

