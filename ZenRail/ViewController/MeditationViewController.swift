//
//  MeditationViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit
import AVFoundation
import MapKit
import AudioToolbox

var soundPlayer: AVAudioPlayer!


class MeditationViewController: UIViewController {
    
    @IBOutlet var backwardButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var setDestinationButton: UIButton!
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var bgmLabel: UILabel!
    @IBOutlet var bgmTimeLabel: UILabel!
    @IBOutlet var bgmDurationLabel: UILabel!
    @IBOutlet var discriptionTextView: UITextView!
    @IBOutlet var pageView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var progressView: UIProgressView!
        
    var index: Int = 0
    var views: [UIView] = []
    var playingBgm: String!
    
    var locationManager: CLLocationManager!
    var didStartUpdatingLocation: Bool = false
    
    var locationDictionary: [String : Any]? {
        didSet {
            print(self.locationDictionary)
        }
    }
    
    let headlines = [
        "心地よい姿勢を取る",
        "集中力を高める呼吸法",
        "無駄な考えを排除する",
        "身体の感覚に集中する",
        "自然の音に耳を傾ける",
        "瞑想の時間を設定する",
        "終了時にゆっくりと動く"
    ]
    
    let discriptions = [
        "座位や横になるなど自分がリラックスできる姿勢を選びましょう。背筋を伸ばし身体に緊張感がないようにします。",
        "深くゆっくりとした呼吸を行います。鼻から息を吸い込み口からゆっくりと息を吐きます。吸うときに数えることで集中力を高めることができます。",
        "頭の中に浮かんでくるさまざまな考えを無視し心を静かに保ちます。何か思考が浮かんでもそれにくっつかずに過ぎ去らせましょう。",
        "自分の身体の感覚に意識を集中させます。息を吸うときの風の感触や身体の重さなどに注意を向けましょう。感覚に意識を向けることで現在の瞬間に集中しやすくなります。",
        "自然の音に耳を傾けてみてください。電車の音や周りの声など、周囲の音を静かに感じることで、リラックス効果が高まります。",
        "初めは一駅、二駅程度から始めてみましょう。その後徐々に時間を延ばしましょう。自分に合った時間を選び継続的に実践することが大切です。",
        "瞑想が終わったらゆっくりと身体を動かしましょう。徐々に日常の活動に戻っていくことで瞑想の効果を自然に取り入れることができます。"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backwardButton.isHidden = true
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = pageView.frame
        blurEffectView.center = pageView.center
        //        blurEffectView.frame.size.height = pageView.frame.height - 93
        blurEffectView.layer.cornerRadius = 24
        blurEffectView.clipsToBounds = true
        scrollView.addSubview(blurEffectView)
        scrollView.bringSubviewToFront(pageView)
        
        pageView.layer.borderWidth = 1.0
        pageView.layer.borderColor = UIColor(hex: "3C6255").cgColor
        pageView.clipsToBounds = false
        pageView.layer.masksToBounds = false
        pageView.layer.cornerRadius = 24
        pageView.layer.shadowOffset = CGSizeMake(0, 4)
        pageView.layer.shadowPath = UIBezierPath(rect: pageView.bounds).cgPath
        pageView.layer.shadowColor = UIColor(hex: "3C6255").cgColor
        pageView.layer.shadowRadius = 30
        pageView.layer.shadowOpacity = 0.3
        
        createIndicaterView()
        indicater()
        setupCoreLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initLocation(locationManager)
    }
    
    @IBAction func tappedForwardButton() {
        index += 1
        if index >= headlines.count - 1 {
            forwardButton.isHidden = true
        }
        backwardButton.isHidden = false
        
        stepLabel.text = "STEP \(index + 1)"
        headlineLabel.text = headlines[index]
        discriptionTextView.text = discriptions[index]
        indicater()
    }
    
    @IBAction func tappedBackwardButton() {
        index -= 1
        if index == 0 {
            backwardButton.isHidden = true
        }
        forwardButton.isHidden = false
        
        stepLabel.text = "STEP \(index + 1)"
        headlineLabel.text = headlines[index]
        discriptionTextView.text = discriptions[index]
        indicater()
    }
    
    @IBAction func tappedExitButton() {
        dismiss(animated: true)
    }
    
    @IBAction func tappedMusicListButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectBGMViewController = storyboard.instantiateViewController(identifier: "SelectBGMViewController") as! SelectBGMViewController
        selectBGMViewController.modalPresentationStyle = .formSheet
        selectBGMViewController.presentationController?.delegate = self
        selectBGMViewController.bgmDelegate = self
        present(selectBGMViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedSetDestinationButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectDestinationViewController = storyboard.instantiateViewController(withIdentifier: "SelectDestinationViewController") as! SelectDestinationViewController
        selectDestinationViewController.modalPresentationStyle = .formSheet
        selectDestinationViewController.presentationController?.delegate = self
        selectDestinationViewController.destinationDelegate = self
        present(selectDestinationViewController, animated: true, completion: nil)
    }
    
    func createIndicaterView() {
        let pageViewCenterX = CGFloat((scrollView.frame.width) / 2)
        let pageViewCenterY = CGFloat(pageView.frame.minY)
        let initialViewX = CGFloat(pageViewCenterX - 105 - 12.5)
        for i in 0...6 {
            let view = UIView(frame: CGRect(x: initialViewX + CGFloat(35 * i), y: pageViewCenterY + 20, width: 25, height: 3))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 1.5
            view.clipsToBounds = true
            views.append(view)
            self.scrollView.addSubview(view)
        }
    }
    
    func indicater() {
        
        for i in 0...6 {
            if i == index {
                views[index].backgroundColor = UIColor(hex: "EAE75B")
            } else {
                views[i].backgroundColor = UIColor(hex: "FFFFFF")
            }
        }
    }
    
    //MARK: CoreLocation
    
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
    
    func updateLocation(currentLocation: CLLocation) -> Bool {
//        print("Location:\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
//
        guard let stationlatitude = locationDictionary?["latitude"] as? Double else {
            print("locationDictionary?[y] is nil")
            return false
        }
        
        guard let stationlongitude = locationDictionary?["longitude"] as? Double else {
            print("locationDictionary?[x] is nil")
            return false
        }
        
        let distance = calculateDistance(y1: Double(currentLocation.coordinate.latitude), x1: Double(currentLocation.coordinate.longitude), y2: stationlatitude , x2: stationlongitude)
        
        if distance <= 1.00000 {
            return true
        } else {
            return false
        }
        
    }
    
    func calculateDistance(y1: Double, x1: Double, y2: Double, x2: Double) -> Double {
        
        print(y1, x1, y2, x2)
        
        let r = 6378.137
        let deltaX = x2 - x1
        let cos = acos(
            (sin((y1 * Double.pi) / 180) * sin((y2 * Double.pi) / 180)) + (cos((y1 * Double.pi) / 180) * cos((y2 * Double.pi) / 180) * cos((deltaX * Double.pi) / 180))
        )
        let distance = r * cos
        
        return distance
    }
    
    //MARK: API
    func setupApi(station: String) {
        let baseUrl = "https://express.heartrails.com/api/json?method=getStations&name="
        ///remove "駅"
        let stationName = String(station.prefix(station.count - 1))
        guard let stationEncodeString = stationName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("URL encode is failed")
            return
        }
        guard let apiUrl = URL(string: baseUrl + stationEncodeString) else {
            print("apiUrl is invalid", baseUrl + stationEncodeString)
            return
        }
                
        let task: URLSessionTask = URLSession.shared.dataTask(with: apiUrl, completionHandler: {data, response, error in
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] else {
                    print("json is nil")
                    return
                }
                ///cast json to dictionary
                let responseJson = json["response"] as? [String : Any]
                let stationJson = responseJson?["station"] as? [Any]
                let stationDictionary = stationJson?[0] as? [String : Any]
                let locationDictionary = [
                    "latitude" : stationDictionary?["y"],
                    "longitude" : stationDictionary?["x"]
                ] as? [String : Any]
                DispatchQueue.main.async() { () -> Void in
                    self.locationDictionary = locationDictionary
                }
            }
            catch {
                print(error)
            }
        })
        task.resume()
    }
    
    func setupBGM() {
                
        guard let player = soundPlayer else {
            print("soundPlayer is nil")
            return
        }
        
        print(playingBgm)
        bgmLabel.text = playingBgm
        
        bgmDurationLabel.text = convertSecond(second: soundPlayer.duration)
        let soundTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(time: Timer) in
            
            if soundPlayer.isPlaying {
                self.progressView.progress = Float(soundPlayer.currentTime) / Float(soundPlayer.duration)
                self.bgmTimeLabel.text = self.convertSecond(second: soundPlayer.currentTime)
            } else {
                soundPlayer.currentTime = 0
                soundPlayer.play()
            }
        })
    }
    
    func convertSecond(second: TimeInterval) -> String {
        let intSecond = Int(second)
        let StringTime = intSecond % 60 < 10 ? "\(intSecond / 60):0\(intSecond % 60)" : "\(intSecond / 60):\(intSecond % 60)"
        return StringTime
    }
}

//MARK: CLLocationManagerDelegate
extension MeditationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
               if updateLocation(currentLocation: location) {
                   print("getting close destination")
                   AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                   let alert = UIAlertController(title: "もうすぐ降車駅に到着します", message: "心のリフレッシュはできましたか？", preferredStyle: .alert)
                   let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in 
                       self.dismiss(animated: true)
                   })
                   alert.addAction(ok)
                   present(alert, animated: true)
               } else {
                   print("not yet...")
               }
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

extension MeditationViewController: BGMDelegate {
    func gettingBgmTitle(title: String) {
        self.playingBgm = title
    }
}

extension MeditationViewController: DestinationDelegate {
    func getDestination(destination: String) {
        setDestinationButton.setTitle(destination, for: .normal)
    }
    
    
}

extension MeditationViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        switch presentationController.presentedViewController.title! {
        case "SelectBGMViewController":
            setupBGM()
        case "SelectDestinationViewController":
            setupApi(station: setDestinationButton.titleLabel?.text ?? "")
        default:
            break
        }
    }
}
