//
//  SelectBGMViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit
import AVFoundation

class SelectBGMViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var bgmTableView: UITableView!
    
    let bgmtitles = [
        "New Morning",
        "Somehow",
        "曇った宝石",
        "青空空港",
        "Cecilia",
        "painted from memory"
    ]
    
    var playingBgm: String?
    var bgmDelegate: BGMDelegate?
    
    let meditationViewController = MeditationViewController()
//    let bgmCell = BGMCell()
//    let cellDelegate = SelectBGMViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.cornerRadius = 15
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 10), forImageIn: .normal)
        
//        bgmCell.delegate = cellDelegate
        bgmDelegate = meditationViewController
        
        bgmTableView.dataSource = self
        bgmTableView.delegate = self
        bgmTableView.register(UINib(nibName: "BGMCell", bundle: nil), forCellReuseIdentifier: "bgmCell")
        
    }
    
    @IBAction func tappedBackButton() {
        if let presentationController = presentationController {
            bgmDelegate?.gettingBgmTitle(title: playingBgm ?? "未設定")
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
        print("dismiss")
        self.dismiss(animated: true,completion: nil)
    }

}

extension SelectBGMViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bgmtitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bgmCell", for: indexPath) as! BGMCell
        cell.bgmLabel.text = bgmtitles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playingBgm = bgmtitles[indexPath.row]
        print(playingBgm)
    }
}

//extension SelectBGMViewController: bgmCellDelegate {
//    func pauseImage() {
//        let bgmTableViewCell = UINib(nibName: "BGMCell", bundle: nil) as! BGMCell
//        bgmTableViewCell.playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
//    }
//
//    func playImage() {
//        let bgmTableViewCell = UINib(nibName: "BGMCell", bundle: nil) as! BGMCell
//        bgmTableViewCell.playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
//    }
//
//    func swapBgm() {
//        print("swapBgm")
//    }
//}
