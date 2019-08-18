//
//  DetailTemperatureCell.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

class DetailTemperatureCell: UITableViewCell {

    @IBOutlet weak var temperatureLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
        // Initialization code
    }


    private func settingSubviews(){
        self.selectionStyle = .none
        
        self.temperatureLB.text = nil
        self.temperatureLB.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        self.temperatureLB.textAlignment = .center
        self.temperatureLB.numberOfLines = 1
        
    }
    
    private func resetData(){
        
        self.temperatureLB.text = nil
    }
    
    public func mapCellData(cellData: DetailWeatherData){
        
        self.resetData()
        
        self.temperatureLB.text = cellData.temperature
    }
}
