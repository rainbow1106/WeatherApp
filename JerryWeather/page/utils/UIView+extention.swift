//
//  UIView+extention.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit


extension UIView{
    
    
    func showSubviews(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        
        self.subviews.forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.blue.cgColor
        }
    }
}
