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
        
//        let BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
//        let blurEffectView = UIVisualEffectView(effect: BlurEffect)
//        blurEffectView.frame = titleLabel.frame
//        blurEffectView.center = titleLabel.center
//        blurEffectView.layer.cornerRadius = 12
//        blurEffectView.alpha = 0.75
//        blurEffectView.clipsToBounds = true
//        backgroundImageView.addSubview(blurEffectView)
        
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
        
        createTabBar(x: CGFloat(view.frame.width / 2), y: CGFloat(view.frame.height / 10 * 9), width: 320, height: 50)
    }
    
    func createTabBar(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let rect = CGRect(x: x - (width / 2), y: y, width: width, height: height)
        let customTabBar = UIView(frame: rect)
        
        let homeIconImage: UIImage = UIImage(systemName: "house")!
        let toDoIconImage: UIImage = UIImage(systemName: "list.bullet")!
        
        let homeButton = UIButton(frame: CGRect(x: CGFloat((customTabBar.frame.width / 2) - 50), y: y + 7.5, width: 35, height: 35))
        let toDoButton = UIButton(frame: CGRect(x: CGFloat((customTabBar.frame.width / 2) + 85), y: y + 7.5, width: 35, height: 35))
        
        homeButton.setImage(homeIconImage, for: .normal)
        toDoButton.setImage(toDoIconImage, for: .normal)
        homeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        toDoButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        
        homeButton.contentMode = .scaleAspectFit
        toDoButton.contentMode = .scaleAspectFit
        
        homeButton.tintColor = UIColor(hex: "EAE75B")
        toDoButton.tintColor = UIColor.white
        
        customTabBar.layer.masksToBounds = false
        customTabBar.backgroundColor = UIColor(hex: "3C6255")
        customTabBar.layer.shadowColor = UIColor(hex: "3C6255", alpha: 0.5).cgColor
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        customTabBar.layer.shadowRadius = 15
        customTabBar.layer.shadowOpacity = 1
        
        customTabBar.clipsToBounds = false
        customTabBar.layer.cornerRadius = 12
        
        toDoButton.addTarget(self, action: #selector(tappedToDoButton), for: .touchUpInside)
        
        view.addSubview(customTabBar)
        view.addSubview(homeButton)
        view.addSubview(toDoButton)
    }
    
    @objc func tappedToDoButton() {
        let toDoViewController = storyboard?.instantiateViewController(withIdentifier: "ToDoViewController") as! ToDoViewController
        toDoViewController.modalPresentationStyle = .fullScreen
        self.present(toDoViewController, animated: false, completion: nil)
        
    }
    
    
}

