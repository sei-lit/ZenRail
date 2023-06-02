//
//  SelectDestinationViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit
import CoreLocation

class SelectDestinationViewController: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    
    var locationManager: CLLocationManager!
    var didStartUpdatingLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 15
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 10), forImageIn: .normal)
        
        setupCoreLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initLocation(locationManager)
    }
    
    func initLocation(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            //ユーザーが位置情報の許可をまだしていないので、位置情報許可のダイアログを表示する
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showPermissionAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            if !didStartUpdatingLocation{
                didStartUpdatingLocation = true
                locationManager.startUpdatingLocation()
            }
        @unknown default:
            break
        }
        
    }
    
    func setupCoreLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func showPermissionAlert(){
        //位置情報が制限されている/拒否されている
        let alert = UIAlertController(title: "位置情報の取得", message: "設定アプリから位置情報の使用を許可して下さい。プライバシー>位置情報サービス>ZenRailから変更できます", preferredStyle: .alert)
        let goToSetting = UIAlertAction(title: "設定アプリを開く", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("キャンセル", comment: ""), style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(goToSetting)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateMap(currentLocation: CLLocation){
           print("Location:\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
    }
    
    @IBAction func tappedBackButton() {
        dismiss(animated: true)
    }
    
}

extension SelectDestinationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
               locationManager.stopUpdatingLocation()
               updateMap(currentLocation: location)
           }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
    
    func locationManager(_ manager: CLLocationManager,
                                     didChangeAuthorization status: CLAuthorizationStatus){
           if status == .authorizedWhenInUse {
               if !didStartUpdatingLocation{
                   didStartUpdatingLocation = true
                   locationManager.startUpdatingLocation()
               }
           } else if status == .restricted || status == .denied {
               showPermissionAlert()
           }
       }
}
