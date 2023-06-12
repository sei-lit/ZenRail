//
//  SelectDestinationViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit
import CoreLocation
import MapKit

class SelectDestinationViewController: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    var didStartUpdatingLocation: Bool = false
    var searchCompleter = MKLocalSearchCompleter()
    
    weak var destinationDelegate: DestinationDelegate?
    
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let pointOfInterestFilter = MKPointOfInterestFilter(including: [.publicTransport])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 15
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 10), forImageIn: .normal)
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DestinationTableViewCell", bundle: nil), forCellReuseIdentifier: "destinationCell")
        
        searchCompleter.delegate = self
        searchCompleter.pointOfInterestFilter = pointOfInterestFilter
        searchCompleter.resultTypes = .pointOfInterest
        
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
    
    func updateLocation(currentLocation: CLLocation){
        print("Location:\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")

        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), span: span)

        searchCompleter.region = region
    }
    
    @IBAction func tappedBackButton() {
        if let presentationController = presentationController {
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
        dismiss(animated: true)
    }
    
}

extension SelectDestinationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
               locationManager.stopUpdatingLocation()
               updateLocation(currentLocation: location)
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

extension SelectDestinationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let station = searchBar.text {
            searchCompleter.queryFragment = station
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let station = searchBar.text {
            searchCompleter.queryFragment = station
        }
    }
}

extension SelectDestinationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("searchCompleter didn't work because: ", error)
    }
}

extension SelectDestinationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleter.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell") as! DestinationTableViewCell
        let completion = searchCompleter.results[indexPath.row]
        cell.destinationLabel.text = completion.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destinationDelegate?.getDestination(destination: searchCompleter.results[indexPath.row].title)
        
        let alert = UIAlertController(title: "降車駅を\(searchCompleter.results[indexPath.row].title)に設定しました", message: "瞑想を始めましょう！", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let presentationController = self.presentationController {
                presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
            }
            self.dismiss(animated: true)
        })
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    
}
