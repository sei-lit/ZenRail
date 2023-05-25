//
//  ViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: BlurEffect)
        blurEffectView.frame = titleLabel.frame
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.alpha = 0.75
        blurEffectView.clipsToBounds = true
        backgroundImageView.addSubview(blurEffectView)
        
        titleLabel.clipsToBounds = true
        titleLabel.layer.masksToBounds = true
        titleLabel.backgroundColor = UIColor(hex: "ffffff", alpha: 0.25)
        titleLabel.layer.borderWidth = 1.0
        titleLabel.layer.borderColor = UIColor.white.cgColor
        titleLabel.layer.cornerRadius = 12
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.layer.shadowPath = UIBezierPath(rect: titleLabel.bounds).cgPath
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.25
        titleLabel.layer.shadowRadius = 10
        
    }
    
    func createTabBar(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        let tabBarCenter = CGPoint(x: x + width / 2, y: y + height / 2)
        let customTabBar = UIView(frame: rect)
        customTabBar.center = tabBarCenter
        
        let homeIconImage: UIImage = UIImage(systemName: "house")!
        let toDoIconImage: UIImage = UIImage(systemName: "list.bullet")!
        
        let homeImageView = UIImageView(frame: CGRect(x: x, y: y, width: 30, height: 30))
        let toDoImageView = UIImageView(frame: CGRect(x: x, y: y, width: 30, height: 30))
        
        homeImageView.image = homeIconImage
        toDoImageView.image = toDoIconImage
        
        customTabBar.backgroundColor = UIColor(hex: "3C6255")
        customTabBar.layer.shadowColor = UIColor(hex: "3C6255", alpha: 0.5).cgColor
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        customTabBar.layer.shadowRadius = 15
        customTabBar.layer.shadowOpacity = 1
        
        
        
        view.addSubview(customTabBar)
    }
    
    
}

