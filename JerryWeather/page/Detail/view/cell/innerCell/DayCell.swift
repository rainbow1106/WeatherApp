//
//  DayCell.swift
//  JerryWeather
//
//  Created by 박병준 on 8/19/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

final class DayCell: UITableViewCell {

    // ibs
    @IBOutlet weak var dayLB: UILabel!
    @IBOutlet weak var weatherLB: UILabel!
    @IBOutlet weak var maxLB: UILabel!
    @IBOutlet weak var minLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
        // Initialization code
    }

    private func settingSubviews(){
        
        self.selectionStyle = .none
        
        self.dayLB.text = nil
        self.dayLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        self.dayLB.textAlignment = .left
        self.dayLB.numberOfLines = 1
        
        self.weatherLB.text = nil
        self.weatherLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        self.weatherLB.textAlignment = .right
        self.weatherLB.numberOfLines = 1
        
        self.maxLB.text = nil
        self.maxLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        self.maxLB.textAlignment = .right
        self.maxLB.numberOfLines = 1
        
        self.minLB.text = nil
        self.minLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        self.minLB.textAlignment = .right
        self.minLB.numberOfLines = 1
        
    }
    
    private func resetData(){
        
        self.dayLB.text = nil
        self.weatherLB.text = nil
        self.maxLB.text = nil
        self.minLB.text = nil
        
    }
    
    public func mapCellData(cellData: DetailDailyData){
        
        self.resetData()
        
        self.dayLB.text = cellData.dayText
        self.weatherLB.text = cellData.dailySummary
        self.maxLB.text = cellData.maxTemperature
        self.minLB.text = cellData.minTemperature
    }
}
