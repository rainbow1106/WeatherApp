//
//  ListCell.swift
//  JerryWeather
//
//  Created by 박병준 on 8/11/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

final class ListCell: UITableViewCell {

    // ibs
    @IBOutlet weak var locaionLB: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var tempratureLB: UILabel!
    @IBOutlet weak var descLB: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
        // Initialization code
    }

    private func settingSubviews(){
        
        self.selectionStyle = .none
        
        self.locaionLB.text = nil
        self.locaionLB.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        self.locaionLB.textAlignment = .left
        self.locaionLB.numberOfLines = 1
        
        self.locationIcon.isHidden = true
        
        self.tempratureLB.text = nil
        self.tempratureLB.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        self.tempratureLB.textAlignment = .right
        self.tempratureLB.numberOfLines = 1
        
        self.descLB.text = nil
        self.descLB.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        self.descLB.textAlignment = .right
        self.descLB.numberOfLines = 1
        
    }
    
    private func resetData(){
        
        self.locaionLB.text = nil
        self.locationIcon.isHidden = true
        self.descLB.text = nil
        self.tempratureLB.text = nil
        
    }
    
    public func mapCellData(cellData: DPWeatherData){
        
        self.resetData()
        
        self.locaionLB.text = cellData.locationName
        self.locationIcon.isHidden = !cellData.isCurrentLocation
        self.tempratureLB.text = cellData.temperature
        self.descLB.text = cellData.weatherDesc
        
    }
}
