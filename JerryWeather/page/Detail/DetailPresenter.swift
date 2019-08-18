//
//  DetailPresenter.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation


protocol DetailPresentLogic{
    
    func presentResult()
    
}

final class DetailPresenter: DetailPresentLogic{
    
    weak var viewController: DetailDisplayLogic?
    
    func presentResult() {
        self.viewController?.displayList()
    }
}
