//
//  LoginViewController.swift
//  FirebaseLoginAndSignUp
//
//  Created by Violeta Recio Sansón on 27/11/2020.
//

import UIKit
import FirebaseAuth

@available(iOS 13.0, *)

class LoginViewController: UIViewController {

	@IBOutlet var email: UITextField!
	@IBOutlet var password: UITextField!


	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	@IBAction func loginTapped(_ sender: Any) {
		validateFields()
	}

	@IBAction func createAccountTapped(_ sender: Any) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(identifier: "signUp")
		vc.modalPresentationStyle = .overFullScreen
		present(vc, animated: true)
	}

	func validateFields() {
		if email.text?.isEmpty == true {
			print("No Email Text")
			alertEmailEmpty()
			return
		}

		if password.text?.isEmpty == true {
			print("No Password")
			alertPasswordEmpty()
			return
		}

		login()
	}

	func login() {
		Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] (authResult, err) in
			if let err = err {
				print(err.localizedDescription)
			}
			if authResult != nil {
				self!.checkUserInfo()
			} else {
				self!.alertUserError()
			}
		}
	}

	func checkUserInfo() {
		if Auth.auth().currentUser != nil {
			print(Auth.auth().currentUser?.uid)
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(identifier: "mainHome")
			vc.modalPresentationStyle = .overFullScreen
			present(vc, animated: true)
		}
	}

	func alertEmailEmpty() {
		var dialogMessage = UIAlertController(title: "Alert", message: "El campo email no puede estar vacío", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}

	func alertPasswordEmpty() {
		var dialogMessage = UIAlertController(title: "Alert", message: "El campo password no puede estar vacío", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}

	func alertUserError() {
		var dialogMessage = UIAlertController(title: "Error", message: "El usuario o password es incorrecto", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}
}
