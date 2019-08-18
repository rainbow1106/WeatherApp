//
//  SearchPresenter.swift
//  JerryWeather
//
//  Created by 박병준 on 8/15/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation


protocol SearchPresentLogic{
    
    func presentSearchResult()
    
}

final class SearchPresenter: SearchPresentLogic{
    
    weak var viewController: SearchDisplayLogic?
    
    func presentSearchResult() {
        
        self.viewController?.displayList()
    }
}
