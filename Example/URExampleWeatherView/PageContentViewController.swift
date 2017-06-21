//
//  PageContentViewController.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 10..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
//import GoogleMaps

// TODO: Trying to integrate the real weather as where the user or device is...
class PageContentViewController: UIViewController {//, CLLocationManagerDelegate , GMSMapViewDelegate {
    var index: Int = 0 {
        didSet {
            if self.index == 0 {
//                self.mapView = GMSMapView(frame: self.view.bounds)
//                self.mapView.settings.myLocationButton = true
//                self.mapView.settings.compassButton = true
//                self.mapView.isMyLocationEnabled = true
//
//                self.mapView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
//
//                self.mapView.delegate = self
//
//                self.view.addSubview(self.mapView)

//                self.locationManager.delegate = self
//                self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//                self.locationManager.startUpdatingLocation()
            }
        }
    }

//    var mapView: GMSMapView!

//    var locationManager: CLLocationManager = CLLocationManager()

    // MARK: - CLLocationManagerDelegate
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            let camera = GMSCameraPosition(target: location.coordinate, zoom: 16.0, bearing: 0.0, viewingAngle: 0.0)
//            self.mapView.moveCamera(GMSCameraUpdate.setCamera(camera))
//        }
//    }

    // MARK: - GMSMapViewDelegate
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        let coordinate = position.target
//
//        let geocoder = GMSGeocoder()
//        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] (response, error) in
//            guard let wself = self else { return }
//
//            var message: String = ""
//            let alert = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertControllerStyle.alert)
//            let action1 = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action) in
//                //
//            })
//            let action2 = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (action) in
//                //
//            })
//            alert.addAction(action1)
//            alert.addAction(action2)
//
//            if let err = error {
//                message = err.localizedDescription
//                alert.message = message
//                wself.present(alert, animated: true, completion: nil)
//            } else {
//                if let addresses: [GMSAddress] = response?.results() {
//                    for address in addresses {
//                        message.append(address.description)
//                    }
//                    alert.message = message
//                    wself.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//    }
}
