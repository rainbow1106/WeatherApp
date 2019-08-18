//
//  HourCell.swift
//  JerryWeather
//
//  Created by 박병준 on 8/19/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

final class HourCell: UICollectionViewCell {

    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var weatherLB: UILabel!
    @IBOutlet weak var temperatureLB: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
        // Initialization code
    }

    private func settingSubviews(){
        
        self.timeLB.text = nil
        self.timeLB.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        self.timeLB.textAlignment = .center
        self.timeLB.numberOfLines = 1
        
        self.weatherLB.text = nil
        self.weatherLB.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        self.weatherLB.textAlignment = .center
        self.weatherLB.numberOfLines = 1
        
        self.temperatureLB.text = nil
        self.temperatureLB.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        self.temperatureLB.textAlignment = .center
        self.temperatureLB.numberOfLines = 1
    }
    
    private func resetData(){
        
        self.timeLB.text = nil
        self.weatherLB.text = nil
        self.temperatureLB.text = nil
        
    }
    
    public func mapCellData(cellData: DetailHourData){
        
        self.resetData()
        
        self.timeLB.text = cellData.time
        self.weatherLB.text = cellData.hourSummary
        self.temperatureLB.text = cellData.temperature
        
    }
}
