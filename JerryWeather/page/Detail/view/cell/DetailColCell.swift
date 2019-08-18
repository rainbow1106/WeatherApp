//
//  DetailColCell.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

final class DetailColCell: UICollectionViewCell {

    var cellData: DetailWeatherData?
    
    // ibs
    @IBOutlet weak var locationNameLB: UILabel!
    @IBOutlet weak var descLB: UILabel!
    
    @IBOutlet weak var tableV: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.settingSubviews()
        
    }

    private func settingSubviews(){
        
        self.locationNameLB.text = nil
        self.locationNameLB.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        self.locationNameLB.textAlignment = .center
        self.locationNameLB.numberOfLines = 1
        
        self.descLB.text = nil
        self.descLB.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        self.descLB.textAlignment = .center
        self.descLB.numberOfLines = 1
        
        self.settingTableV()
    }
    
    private func settingTableV(){
        
        self.tableV.showsVerticalScrollIndicator = false
        self.tableV.showsHorizontalScrollIndicator = false
        
        self.tableV.layoutMargins = .zero
        self.tableV.contentInset = .zero
        
        self.tableV.allowsSelection = false
        self.tableV.allowsMultipleSelection = false
        
        self.tableV.delegate = self
        self.tableV.dataSource = self
        
        self.tableV.separatorStyle = .none
        
        self.tableV.register(UINib(nibName: "DetailTemperatureCell", bundle: nil),
                             forCellReuseIdentifier: DetailTemperatureCell.description())
        
        self.tableV.register(UINib(nibName: "DetailScrSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: DetailScrSectionHeader.description())
        
        self.tableV.register(UINib(nibName: "DetailInnerCell", bundle: nil),
                             forCellReuseIdentifier: DetailInnerCell.description())
        self.tableV.register(UINib(nibName: "DayCell", bundle: nil),
                             forCellReuseIdentifier: DayCell.description())
        
    }
    
    private func resetData(){
        
        self.locationNameLB.text = nil
        self.descLB.text = nil
        
        self.cellData = nil
    }
    
    public func mapCellData(cellData: DetailWeatherData){
        
        self.resetData()
        
        self.cellData = cellData
        self.locationNameLB.text = cellData.locationName
        self.descLB.text = cellData.summary
        
        self.tableV.reloadData()
    }
}



extension DetailColCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 60
        }else {
            
            if let uDataList = self.cellData?.dailyDataList{
                
                if indexPath.row < uDataList.count{
                    return 50
                }
                
            }
            
            return UITableView.automaticDimension
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1{
            return 90
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        guard let uView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailScrSectionHeader.description()) as? DetailScrSectionHeader else{
            return nil
        }
        
        guard let uViewData = self.cellData else{
            return nil
        }
        uView.mapViewData(viewData: uViewData)
        return uView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            
            var cnt = 1
            if let uCnt = self.cellData?.dailyDataList.count{
                cnt += uCnt
            }
            return cnt
            
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let uCellData = self.cellData else{
            return UITableViewCell()
        }
        
        if indexPath.section == 0{
            // temperature cell
            
            guard let uCell = tableView.dequeueReusableCell(withIdentifier: DetailTemperatureCell.description()) as? DetailTemperatureCell else{
                return UITableViewCell()
            }
            
            
            uCell.mapCellData(cellData: uCellData)
            return uCell
            
        }else{
            // contentCell
            if indexPath.row < uCellData.dailyDataList.count{
             
                guard let uCell = tableView.dequeueReusableCell(withIdentifier: DayCell.description()) as? DayCell else{
                    return UITableViewCell()
                }
                let uDataList = uCellData.dailyDataList
                
                guard indexPath.row < uDataList.count else{
                    return UITableViewCell()
                }
                uCell.mapCellData(cellData: uDataList[indexPath.row])
                return uCell
                
            }else{
                guard let uCell = tableView.dequeueReusableCell(withIdentifier: DetailInnerCell.description()) as? DetailInnerCell else{
                    return UITableViewCell()
                }
                
                
                uCell.mapCellData(cellData: uCellData)
                return uCell
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
}
