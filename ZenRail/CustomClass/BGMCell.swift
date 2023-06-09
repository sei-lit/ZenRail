//
//  TableViewCell.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/29.
//

import UIKit
import AVFoundation

//protocol bgmCellDelegate {
//    func pauseImage()
//    func playImage()
//    func swapBgm()
//}

class BGMCell: UITableViewCell {
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var waveImageView: UIImageView!
    @IBOutlet var chekmarkImageView: UIImageView!
    @IBOutlet var bgmLabel: UILabel!
        
//    var delegate: bgmCellDelegate? = nil
    
    let bgmtitles = [
        "New Morning" : "new_morning",
        "Somehow" : "somehow",
        "曇った宝石" : "fog_up_gem",
        "青空空港" : "blue_sky_airport",
        "Cecilia" : "cecilia",
        "painted from memory" : "painted_from_memory",
        "川のせせらぎ" : "bird_river",
        "小鳥のさえずり" : "bird",
        "さざなみ" : "wave"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        waveImageView.isHidden = true
        chekmarkImageView.isHidden = true
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            waveImageView.isHidden = false
            chekmarkImageView.isHidden = false
            playBgm(title: bgmLabel.text ?? "New Morning")

        } else {
            playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            waveImageView.isHidden = true
            chekmarkImageView.isHidden = true
        }
        
    }
    
    func playBgm(title: String) {
        soundPlayer = try! AVAudioPlayer(data: NSDataAsset(name: bgmtitles[title]!)!.data)
        soundPlayer.currentTime = 0
        soundPlayer.play()
        
//        print(title)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let meditationViewController = storyboard.instantiateViewController(identifier: "MeditationViewController") as! MeditationViewController
//        meditationViewController.playingBgm = title
    }
    
//    @IBAction func tappedPlayButton() {
//        playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
//    }
    
//    func pauseImage() {
//        if let dg = self.delegate {
//            dg.pauseImage()
//        } else {
//            print("delegate is nil")
//        }
//    }
//    
//    func playImage() {
//        if let dg = self.delegate {
//            dg.playImage()
//        } else {
//            print("delegate is nil")
//        }
//    }
//    
//    func swapBgm() {
//        if let dg = self.delegate {
//            dg.swapBgm()
//        } else {
//            print("delegate is nil")
//        }
//    }
    
}


