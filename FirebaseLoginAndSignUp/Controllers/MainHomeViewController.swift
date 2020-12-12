//
//  MainHomeViewController.swift
//  FirebaseLoginAndSignUp
//
//  Created by Violeta Recio Sansón on 29/11/2020.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class MainHomeViewController: UITabBarController, UITabBarControllerDelegate {

	var tabBarCnt: UITabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
		createTabBarController()
    }

	func createTabBarController() {
		tabBarCnt = UITabBarController()
		tabBarCnt.delegate = self
		tabBarCnt.tabBar.barStyle = .blackOpaque

		let firstViewController = QRViewController()
		firstViewController.title = "QR"
		firstViewController.view.backgroundColor = .white

		let secondViewController = GEOViewController()
		secondViewController.title = "GEO"
		secondViewController.view.backgroundColor = .white

		let thirdViewController = WifiViewController()
		thirdViewController.title = "WIFI"
		thirdViewController.view.backgroundColor = .white

		tabBarCnt.viewControllers = [firstViewController,secondViewController, thirdViewController]
		self.view.addSubview(tabBarCnt.view)
	}

	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		print("TabBar controller tapped\(tabBarController.selectedIndex)")
	}
}
