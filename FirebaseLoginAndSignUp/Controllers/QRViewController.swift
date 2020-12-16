//  QRViewController.swift
//  FirebaseLoginAndSignUp
//
//  Created by Violeta Recio Sansón on 29/11/2020.
//

import UIKit
import FirebaseDatabase
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	@IBOutlet weak var qrLabel: UIImageView!

	enum FirstViewControllerError: Error {
		case initDeviceInputFail
		case captureSessionCantAddInput
		case captureSessionCantAddOutput
	}

	var refFichajes : DatabaseReference = Database.database().reference(withPath: "fichajes")
	var refConfig : DatabaseReference = Database.database().reference(withPath: "config/qrCode")
	//Variable para guardar el código que me de firebase
	var qrCodeOffice: String = ""
	var scannedStringValue : String = ""

	var captureSession: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	var metadataOutput: AVCaptureMetadataOutput!
	var videoInput: AVCaptureDeviceInput!
	var signDateString: String = ""


	override func viewDidLoad(){
		super.viewDidLoad()
		do{
			failed()
			view.backgroundColor = UIColor.white
			captureSession = AVCaptureSession()
			try prepareCaptureSession()
		} catch {
			print(error)
		}
	}

	func prepareCaptureSession() throws{
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }

		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			throw FirstViewControllerError.initDeviceInputFail
		}

		if (captureSession.canAddInput(videoInput)) {
			captureSession.addInput(videoInput)
		} else {
			failed()
			throw FirstViewControllerError.captureSessionCantAddInput
		}

		metadataOutput = AVCaptureMetadataOutput()

		if (captureSession.canAddOutput(metadataOutput)) {
			captureSession.addOutput(metadataOutput)

			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.qr]
		} else {
			failed()
			throw FirstViewControllerError.captureSessionCantAddOutput
		}
		//Inicializo una capa de previsualización para poder ver lo que ha cámara captura
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.layer.bounds
		previewLayer.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer)

		self.startCaptureSession()
		self.checkStopCaptureSession()
	}

	func startCaptureSession () {
		captureSession.startRunning()
	}

	func checkStopCaptureSession () {
		if (captureSession?.isRunning == true) {
			captureSession.stopRunning()
		}
	}

	//Método para avisar de error
	func failed() {
		let controller = UIAlertController(title: "Error en el escaneado", message: "Su dispositivo no admite el escaneo del código. Por favor, utilice otro.", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		controller.addAction(action)
		self.show(controller, sender: nil)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if (captureSession?.isRunning == false) {
			captureSession.startRunning()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		captureSession.stopRunning()
		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
			self.scannedStringValue = readableObject.stringValue!
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			print("El código escaneado es " + scannedStringValue)
			//Recupero qrCode del firebase
			refConfig.observe(DataEventType.value, with: { (snapshot) in
				self.qrCodeOffice = snapshot.value as! String
				print("El qrCode de Firebase es " + self.qrCodeOffice)
				if self.checkQr() {
					self.registerFirebase()
				}
			})
			dismiss(animated: true)
		}

		var prefersStatusBarHidden: Bool {
			return true
		}

		var supportedInterfaceOrientations: UIInterfaceOrientationMask {
			return .portrait
		}
	}

	//Método para escribir en Firebase
	func registerFirebase(){

		let date = Date()
		let formatter1 = DateFormatter()
		formatter1.dateStyle = .short
		formatter1.timeStyle = .short
		self.signDateString = formatter1.string(from: date)

		refFichajes.childByAutoId().setValue(["Nombre":"Violeta", "Fecha": self.signDateString, "Acción" : "Fichaje validado con QR"])
	}

	//Método para comprobar que el qr coincide con el código guardado en firebase
	func checkQr() -> Bool {
		if (scannedStringValue == qrCodeOffice) {
			alertReadQR()
			print("Coinciden códigos qr")
			return true
		} else {
			alertReadQRNotValid()
			print("Los códigos qr no coinciden")
			return false
		}
	}

	func alertReadQR() {
		var dialogMessage = UIAlertController(title: "Alert", message: "Has leído un QR de la oficina", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
			print("Ok button tapped")
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}

	func alertReadQRNotValid() {
		var dialogMessage = UIAlertController(title: "Alert", message: "Código QR no válido", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
			print("Ok button tapped")
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}
}

