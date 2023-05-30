//
//  MeditationViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit
import AVFoundation

var soundPlayer: AVAudioPlayer!


class MeditationViewController: UIViewController {
    
    @IBOutlet var backwardButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
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
    
    func setupBGM() {
        
        print("setupBGM")
        
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

extension MeditationViewController: BGMDelegate {
    func gettingBgmTitle(title: String) {
        print("gettingBgmTitle")
        self.playingBgm = title
        print("playingBgm is " + playingBgm)
    }
}

extension MeditationViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerDidDismiss")
        setupBGM()
    }
}
