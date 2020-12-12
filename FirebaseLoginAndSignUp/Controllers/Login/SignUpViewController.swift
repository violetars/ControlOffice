//
//  SignUpViewController.swift
//  FirebaseLoginAndSignUp
//
//  Created by Violeta Recio Sansón on 27/11/2020.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

	@IBOutlet var email: UITextField!
	@IBOutlet var password: UITextField!

	override func viewDidLoad() {
        super.viewDidLoad()
    }

	@IBAction func signUpTapped(_ sender: Any) {
		if email.text?.isEmpty == true {
			print("No text in email field")
			alertEmailEmpty()
			return
		}

		if password.text?.isEmpty == true {
			print("No text in password field")
			alertPasswordEmpty()
			return
		}

		signUp()
	}

	@IBAction func alreadyHaveAccountLoginTapped(_ sender: Any) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "login")
		vc.modalPresentationStyle = .overFullScreen
		present(vc, animated: true)
	}

	func signUp() {
		Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
			guard let user = authResult?.user, error == nil else {
				print("Error \(error?.localizedDescription)")
				return
			}

			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "mainHome")
			vc.modalPresentationStyle = .overFullScreen
			self.present(vc, animated: true)
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
}
