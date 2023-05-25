//
//  CustomTabBar.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit

class CustomTabBar: UIView {

    var customTabBar: UIView!
    
    let homeIconImage: UIImage = UIImage(systemName: "house")!
    let toDoIconImage: UIImage = UIImage(systemName: "list.bullet")!

    // イニシャライザ
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customTabBar.backgroundColor = UIColor(hex: "3C6255")
        customTabBar.layer.shadowColor = UIColor(hex: "3C6255", alpha: 0.5).cgColor
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        customTabBar.layer.shadowRadius = 15
        customTabBar.layer.shadowOpacity = 1
        customTabBar.frame = frame
        addSubview(customTabBar)
    }

    // 必須イニシャライザ
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
