//  WifiViewController.swift
//  FirebaseLoginAndSignUp
//
//  Created by Violeta Recio Sansón on 29/11/2020.


import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
import FirebaseDatabase

class WifiViewController: UIViewController {

	var refFichajes : DatabaseReference = Database.database().reference(withPath: "fichajes")
	var refConfig : DatabaseReference = Database.database().reference(withPath: "config/wifiname")
	//Variable para guardar el nombre de la wifi q me de firebase
	var officeWifi : NSString = ""
	//Variable para guardar el nombre de la wifi q estoy conectada
	var miWifi : String?
	var signDateString: String = ""
	private let titleLabel = UILabel()
	private let containerImage: UIImageView = UIImageView()
	private let image: UIImageView = UIImageView()


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		//Recupero wifiname del firebase
		refConfig.observe(DataEventType.value, with: { (snapshot) in
			self.officeWifi = snapshot.value as! NSString
			print(self.officeWifi)

			//Recupero el nombre de la wifi q estoy conectada
			let miWifi = self.getWiFiName()
			print("El nombre de mi Wifi es: \(miWifi)")
		})
		verifyWifiEnterOffice()
		setupTitleLabel()
		setupContainerImage()
		setupImage()


	}

	//Método para obtener la wifi a la que estoy conectada
	func getWiFiName() -> String? {
		if let interfaces = CNCopySupportedInterfaces() as NSArray? {
			for interface in interfaces {
				if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
					miWifi = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
					break
				}
			}
		}
		return miWifi
	}

	//Método para comprobar si wifiName = miWifi
	func checkWifi() -> Bool {
		if (miWifi == officeWifi as String) {
			print("son iguales")
			return true

		} else {
			print("son diferentes")
			return false
		}
	}

	func verifyWifiEnterOffice() {
		if (self.checkWifi()){
			self.enterOffice()
		} else {
			self.exitOffice()
			self.alertWifi()
		}
	}

	func enterOffice(){
		let date = Date()
		let formatter1 = DateFormatter()
		formatter1.dateStyle = .short
		formatter1.timeStyle = .short
		self.signDateString = formatter1.string(from: date)

		refFichajes.childByAutoId().setValue(["Nombre":"Violeta", "Fecha": self.signDateString, "Acción" : "Entrada. Conexión a wifi de la oficina"])
	}

	func exitOffice(){
		let date = Date()
		let formatter1 = DateFormatter()
		formatter1.dateStyle = .short
		formatter1.timeStyle = .short
		self.signDateString = formatter1.string(from: date)

		refFichajes.childByAutoId().setValue(["Nombre":"Violeta", "Fecha": self.signDateString, "Acción" : "Salida. Desconexión de wifi de la oficina"])
	}

	func alertWifi() {
		var dialogMessage = UIAlertController(title: "Alert", message: "Su dispositivo no se encuentra conectado a la wifi de la oficina", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
			print("Ok button tapped")
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}
}

extension WifiViewController {

	private func setupTitleLabel() {
		view.addSubview(titleLabel)
		titleLabel.numberOfLines = 0
		titleLabel.text = "Fichaje a través de red Wifi"
		titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
	}

	private func setupContainerImage() {
		view.addSubview(containerImage)
		containerImage.translatesAutoresizingMaskIntoConstraints = false
		containerImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
		containerImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		containerImage.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 90/100).isActive = true
		containerImage.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 30/100).isActive = true
	}

	private func setupImage() {
		let imageWifi = "fondoWifi.png"
		let image = UIImage(named: imageWifi)
		let imageView = UIImageView(image: image!)

		view.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
		imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 90/100).isActive = true
		imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 30/100).isActive = true
	}
}

