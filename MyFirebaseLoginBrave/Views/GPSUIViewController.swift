//
//  GPSUIViewController.swift
//  MyFirebaseLoginBrave
//
//  Created by YONGKI LEE on 2020/02/01.
//  Copyright © 2020 Brave Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GPSUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()

        // Do any additional setup after loading the view.
    }
    var locationManager: CLLocationManager!
    var currentRegion: MKCoordinateRegion?
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBAction func backbuttonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func setupLocationManager(){
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else {
            return
        }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func showMapButtonTapped(_ sender: UIButton) {
        guard let currentRegion = currentRegion else { return }
        let options = MKMapSnapshotter.Options()
        options.region = currentRegion
        options.size = locationImageView.frame.size
        options.scale = UIScreen.main.scale
        
        let shotter = MKMapSnapshotter(options: options)
        shotter.start { [weak self] (shot, error) in
            guard error == nil else { return }
            self?.locationImageView.image = shot?.image
            
        }
    }
    
}
extension GPSUIViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
    
        currentRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        latitudeLabel.text = "latitude: \(latitude)"
        longitudeLabel.text = "longitude: \(longitude)"
    }
}

