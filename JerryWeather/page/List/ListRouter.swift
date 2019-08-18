//
//  ListRouter.swift
//  JerryWeather
//
//  Created by 박병준 on 2019. 8. 7..
//  Copyright © 2019년 박병준. All rights reserved.
//

import Foundation
import MapKit

protocol ListDataPassing
{
    var dataStore: ListDataStore? { get }
}
protocol ListRoutingLogic {
    
    func moveSearch()
    func moveDetail(viewIdx: Int)
    
}


final class ListRouter: ListDataPassing, ListRoutingLogic{
    
    weak var viewController: ListVC?
    var dataStore: ListDataStore?
    
    func moveSearch() {
        
        let searchVC = SearchVC()
        self.viewController?.present(searchVC, animated: true, completion: nil)
        
    }
    
    func moveDetail(viewIdx: Int) {
        
        guard let uList = self.dataStore?.getLocationList() else{
            return
        }
        
        let vc = DetailVC()
        vc.setSeedData(locationList: uList, viewIdx: viewIdx)
        
        self.viewController?.present(vc, animated: false, completion: nil)
        
    }
}
