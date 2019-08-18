//
//  SearchResultCell.swift
//  JerryWeather
//
//  Created by 박병준 on 8/16/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit

final class SearchResultCell: UITableViewCell {

    @IBOutlet weak var resultLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.settingSubviews()
    }
    private func settingSubviews(){
        
        self.selectionStyle = .none
        
        self.resultLB.text = nil
        self.resultLB.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        self.resultLB.textAlignment = .left
        self.resultLB.numberOfLines = 1
        
    }
    private func resetData(){
        
        self.resultLB.text = nil
    }
    
    public func mapCellData(totalText: String?, keyword: String?){
        
        self.resetData()
        
        guard let totalText = totalText,
            let keyword = keyword else{
                return
        }
        let resultText = NSMutableAttributedString()
        
        let attr1: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        let attr2: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        resultText.append(NSAttributedString.init(string: totalText, attributes: attr1))
        if let range = totalText.range(of: keyword){
            let nRange = NSRange(range, in: totalText)
            resultText.addAttributes(attr2, range: nRange)
        }
        
        self.resultLB.attributedText = resultText
        
    }
    
}
