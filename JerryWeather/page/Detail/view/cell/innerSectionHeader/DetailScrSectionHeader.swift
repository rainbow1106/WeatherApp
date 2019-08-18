//
//  DetailScrSectionHeader.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

final class DetailScrSectionHeader: UITableViewHeaderFooterView {

    //
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var maxLB: UILabel!
    @IBOutlet weak var minLB: UILabel!
    @IBOutlet weak var colV: UICollectionView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var viewData: DetailWeatherData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
    }
    
    private func settingSubviews(){
     
        self.timeLB.text = nil
        self.timeLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        self.timeLB.textAlignment = .left
        self.timeLB.numberOfLines = 1
        
        self.maxLB.text = nil
        self.maxLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        self.maxLB.textColor = .black
        self.maxLB.textAlignment = .right
        self.maxLB.numberOfLines = 1
        
        self.minLB.text = nil
        self.minLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        self.minLB.textColor = .gray
        self.minLB.textAlignment = .right
        self.minLB.numberOfLines = 1
        
        self.settingColV()
    }
    
    private func settingColV(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.colV.collectionViewLayout = layout
        
        self.colV.showsVerticalScrollIndicator = false
        self.colV.showsHorizontalScrollIndicator = false
        
        self.colV.layoutMargins = .zero
        self.colV.contentInset = .zero
        
        self.colV.allowsSelection = false
        self.colV.allowsMultipleSelection = false
        
        self.colV.delegate = self
        self.colV.dataSource = self
        
        self.colV.register(UINib(nibName: "HourCell", bundle: nil),
                           forCellWithReuseIdentifier: HourCell.description())
        
    }
    
    private func resetData(){
        
        self.viewData = nil
        self.timeLB.text = nil
        self.maxLB.text = nil
        self.minLB.text = nil
        
    }
    public func mapViewData(viewData: DetailWeatherData){
        
        self.resetData()
        
        self.viewData = viewData
        
        self.timeLB.text = viewData.timeText
        self.maxLB.text = viewData.maxTemperature
        self.minLB.text = viewData.minTemperature
        
        self.colV.reloadData()
    }
}


extension DetailScrSectionHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var cnt = 0
        if let uCnt = self.viewData?.hourDataList.count{
            cnt = uCnt
        }
        return cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let uCell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCell.description(), for: indexPath) as? HourCell else{
            return UICollectionViewCell()
        }
        
        guard let uDataList = self.viewData?.hourDataList else{
            return UICollectionViewCell()
        }
        
        guard indexPath.row < uDataList.count else{
            return UICollectionViewCell()
        }
        
        uCell.mapCellData(cellData: uDataList[indexPath.row])
        return uCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width / 5
        let cellHeight = collectionView.frame.height
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
