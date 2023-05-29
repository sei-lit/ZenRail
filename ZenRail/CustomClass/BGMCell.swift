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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        waveImageView.isHidden = true
        chekmarkImageView.isHidden = true
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func tappedPlayButton(sender: IndexPath) {
        playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
    }
    
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


