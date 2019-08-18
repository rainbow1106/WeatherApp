//
//  DetailRouter.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation


protocol DetailDataPassing{
    
    var dataStore: DetailDataStore? { get }
    
}
protocol DetailRoutingLogic {
    
    func moveEnd()
}


final class DetailRouter: DetailDataPassing, DetailRoutingLogic{
    
    weak var viewController: DetailVC?
    var dataStore: DetailDataStore?
    
    func moveEnd(){
        viewController?.dismiss(animated: true, completion: nil)
    }
}
