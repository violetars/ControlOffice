//  GEOViewController.swift
//  FirebaseLoginAndSignUp
//
//  Created by Violeta Recio Sansón on 29/11/2020.
//

import UIKit
import MapKit
import FirebaseDatabase
import CoreLocation

@available(iOS 13.0, *)
class GEOViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

	let mapView = MKMapView()
	var locationManager : CLLocationManager?

	var refFichajes : DatabaseReference = Database.database().reference(withPath: "fichajes")
	var refConfig : DatabaseReference = Database.database().reference(withPath: "config/officeLocation")
	var officeLat : NSString? = ""
	var officeLong : NSString? = ""
	var signDateString: String = ""


	override func viewDidLoad() {
		super.viewDidLoad()

		refConfig.observe(DataEventType.value, with: { (snapshot) in
			let snapshotValue = snapshot.value as! [String:AnyObject]
			self.officeLat = snapshotValue["officeLat"] as? NSString
			self.officeLong = snapshotValue["officeLong"] as? NSString
			let annotation = MKPointAnnotation()
			annotation.coordinate = CLLocationCoordinate2D(latitude: self.officeLat?.doubleValue ?? 0.0, longitude: self.officeLong?.doubleValue ?? 0.0)
			self.mapView.addAnnotation(annotation)
			//llamo al metodo de monitorizar region.
			self.regionToMonitor()
		})

		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			locationManager = appDelegate.locationManager
			locationManager?.desiredAccuracy = kCLLocationAccuracyBest
			locationManager?.delegate = self
		}

		//hacemos zoom en el mapa en la localización del usuario
		if let userLocation = locationManager?.location?.coordinate {
			let viewRegion = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
			mapView.setRegion(viewRegion, animated: false)
		}
	}

	// Pinto mapa en la vista
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let leftMargin: CGFloat = 10
		let topMargin: CGFloat = 60
		let mapWidth: CGFloat = view.frame.size.width-20
		let mapHeight: CGFloat = 700

		mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)

		mapView.mapType = MKMapType.standard
		mapView.isZoomEnabled = true
		mapView.isScrollEnabled = true

		mapView.center = view.center
		view.addSubview(mapView)
	}

	//método que crea una region de 100 m de radio en la latitud y longitud de la oficina y la monitoriza.
	func regionToMonitor() -> Void {
		let office = CLCircularRegion(center: CLLocationCoordinate2D(latitude: self.officeLat?.doubleValue ?? 0, longitude: self.officeLong?.doubleValue ?? 0), radius: 100, identifier: "Oficina")
		office.notifyOnExit = true
		office.notifyOnEntry = true
		locationManager?.startMonitoring(for: office)
	}

	//metodo para cuando entramos en la region
	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		print("entrando en oficina")
		enterOffice()
		alertEnterRegion()
		
	}

	//método para cuando salimos de la region
	func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		print("saliendo de oficina")
		exitOffice()
		alertExitRegion()
	}

	func alertEnterRegion() {
		var dialogMessage = UIAlertController(title: "Bienvenid@!", message: "Estás entrando en la oficina", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
			print("Ok button tapped")
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}

	func alertExitRegion() {
		var dialogMessage = UIAlertController(title: "Hasta pronto!", message: "Estás saliendo de la oficina", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
			print("Ok button tapped")
		}
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}

	func enterOffice(){
		let date = Date()
		let formatter1 = DateFormatter()
		formatter1.dateStyle = .short
		formatter1.timeStyle = .short
		self.signDateString = formatter1.string(from: date)

		refFichajes.childByAutoId().setValue(["Nombre":"Violeta", "Fecha": self.signDateString, "Acción" : "Entrada. Posición de usuario en coordenadas de la oficina"])
	}

	func exitOffice(){
		let date = Date()
		let formatter1 = DateFormatter()
		formatter1.dateStyle = .short
		formatter1.timeStyle = .short
		self.signDateString = formatter1.string(from: date)

		refFichajes.childByAutoId().setValue(["Nombre":"Violeta", "Fecha": self.signDateString, "Acción" : "Salida. Posición usuario en coordenadas fuera de la oficina"])
	}
}
