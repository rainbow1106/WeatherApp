//
//  DetailInnerCell.swift
//  JerryWeather
//
//  Created by 박병준 on 8/19/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

final class DetailInnerCell: UITableViewCell {

    var cellData: DetailWeatherData?
    
    @IBOutlet weak var summaryLB: UILabel!
    
    @IBOutlet var lbList: [UILabel]!
    
    @IBOutlet var valueLBList: [UILabel]!
    
    @IBOutlet weak var sunRiseLB: UILabel!
    @IBOutlet weak var sunDownLB: UILabel!
    @IBOutlet weak var maxLB: UILabel!
    @IBOutlet weak var minLB: UILabel!
    @IBOutlet weak var apTempLB: UILabel!
    @IBOutlet weak var humidLB: UILabel!
    @IBOutlet weak var windLB: UILabel!
    @IBOutlet weak var visibleLB: UILabel!
    @IBOutlet weak var pressLB: UILabel!
    @IBOutlet weak var ubLB: UILabel!
    
    @IBOutlet var lineList: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
        // Initialization code
    }

    private func settingSubviews(){
        
        self.selectionStyle = .none
        
        self.summaryLB.text = nil
        self.summaryLB.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        self.summaryLB.textAlignment = .left
        self.summaryLB.numberOfLines = 0
        
        self.lbList.forEach {
            $0.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        self.valueLBList.forEach {
            $0.text = nil
            $0.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        self.lineList.forEach {
            $0.backgroundColor = UIColor.gray
        }
    }
    
    private func resetData(){
        
        self.valueLBList.forEach {
            $0.text = nil
        }
        
    }
    
    public func mapCellData(cellData: DetailWeatherData){
        
        self.resetData()
        
        self.summaryLB.text = cellData.detailDesc
        self.sunRiseLB.text = cellData.sunRise
        self.sunDownLB.text = cellData.sunDown
        self.maxLB.text = cellData.maxTemperature
        self.minLB.text = cellData.minTemperature
        self.apTempLB.text = cellData.apTemperature
        self.humidLB.text = cellData.humid
        self.windLB.text = cellData.wind
        self.visibleLB.text = cellData.visibleDistance
        self.pressLB.text = cellData.pressure
        self.ubLB.text = cellData.uv
        
    }
}
