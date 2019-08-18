//
//  ListPresenter.swift
//  JerryWeather
//
//  Created by 박병준 on 2019. 8. 7..
//  Copyright © 2019년 박병준. All rights reserved.
//

import Foundation

protocol ListPresentLogic
{
//    func presentFetchedOrders(response: ListOrders.FetchOrders.Response)
    
    func presentWeather()
}

final class ListPresenter: ListPresentLogic
{
    weak var viewController: ListDisplayLogic?
    
    func presentWeather() {
    
        self.viewController?.displayList()
    }
}
