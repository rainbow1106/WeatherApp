//
//  CommonVManager.swift
//  JerryWeather
//
//  Created by 박병준 on 8/11/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation
import UIKit


final class CommonVManager{
    
    class func showConfirmAlert( msg: String?,
                                 completion: ( () -> Void)? = nil){
    
        let alert = UIAlertController.init(title: "안내",
                                           message: msg,
                                           preferredStyle: UIAlertController.Style.alert)
        
        
        let action = UIAlertAction(
            title: "확인",
            style: UIAlertAction.Style.default) { (_) in
                
                alert.dismiss(animated: false, completion: nil)
                
        }
        alert.addAction(action)
        
        guard var keyPage = UIApplication.shared.keyWindow?.rootViewController else{
            return
        }
        if let modal = keyPage.presentedViewController{
            keyPage = modal
        }
        keyPage.present(alert, animated: false, completion: nil)
        
    }
    
}

