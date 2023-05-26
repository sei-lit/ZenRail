//
//  ToDoViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit

class ToDoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        homeButton.tintColor = UIColor.white
        toDoButton.tintColor = UIColor(hex: "EAE75B")
        
        customTabBar.layer.masksToBounds = false
        customTabBar.backgroundColor = UIColor(hex: "3C6255")
        customTabBar.layer.shadowColor = UIColor(hex: "3C6255", alpha: 0.5).cgColor
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        customTabBar.layer.shadowRadius = 15
        customTabBar.layer.shadowOpacity = 1
        
        customTabBar.clipsToBounds = false
        customTabBar.layer.cornerRadius = 12
        
        homeButton.addTarget(self, action: #selector(tappedHomeButton), for: .touchUpInside)
        
        view.addSubview(customTabBar)
        view.addSubview(homeButton)
        view.addSubview(toDoButton)
    }
    
    @objc func tappedHomeButton() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! ViewController
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: false, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
