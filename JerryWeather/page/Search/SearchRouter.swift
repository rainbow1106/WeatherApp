//
//  SearchRouter.swift
//  JerryWeather
//
//  Created by 박병준 on 8/15/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation

protocol SearchDataPassing
{
    var dataStore: SearchDataStore? { get }
}
protocol SearchRoutingLogic {
    
    func moveEnd()
}


final class SearchRouter: SearchDataPassing, SearchRoutingLogic{
    
    weak var viewController: SearchVC?
    var dataStore: SearchDataStore?
    
    func moveEnd(){
        viewController?.dismiss(animated: true, completion: nil)
    }
}
