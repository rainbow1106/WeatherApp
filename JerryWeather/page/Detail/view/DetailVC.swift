//
//  DetailVC.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit
import MapKit

protocol DetailDisplayLogic: class {
    
    func displayList()
    
}

final class DetailVC: UIViewController,  DetailDisplayLogic{

    var interactor: DetailBusinessLogic?
    var router: (DetailRoutingLogic & DetailDataPassing)?
    
    private var isFirstDisplay = true
    @IBOutlet weak var colV: UICollectionView!
    @IBOutlet weak var listBTN: UIButton!
    @IBOutlet weak var pageCntr: UIPageControl!
    
    
    //
    private var seedDataList = [CLLocation]()
    private var viewIdx = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeRelation()
        self.settingSubviews()
        self.bindBtnEvents()
        // Do any additional setup after loading the view.
    }

    convenience init(){
        self.init(nibName: "DetailVC", bundle: nil)
    }
    
    
    private func settingSubviews(){
     
        //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.colV.collectionViewLayout = layout
        
        self.colV.showsVerticalScrollIndicator = false
        self.colV.showsHorizontalScrollIndicator = false
        
        self.colV.layoutMargins = .zero
        self.colV.contentInset = .zero
        
        self.colV.allowsMultipleSelection = false
        self.colV.allowsSelection = true
        
        self.colV.delegate = self
        self.colV.dataSource = self
        
        self.colV.isPagingEnabled = true
        
        self.colV.register(UINib(nibName: "DetailColCell", bundle: nil),
                           forCellWithReuseIdentifier: DetailColCell.description())
        
        
        //
        self.listBTN.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        
        //
        self.pageCntr.currentPage = 0
        self.pageCntr.numberOfPages = 0
        self.pageCntr.pageIndicatorTintColor = .lightGray
        self.pageCntr.currentPageIndicatorTintColor = .black
        
    
    }
    
    private func bindBtnEvents(){
        self.listBTN.addTarget(self, action: #selector(self.listBtnTap), for: .touchUpInside)
    }
    @objc private func listBtnTap(){
        self.router?.moveEnd()
    }
    private func makeRelation(){
        
        let vc = self
        let ir = DetailInteractor()
        let pr = DetailPresenter()
        let router = DetailRouter()
        
        vc.interactor = ir
        vc.router = router
        ir.presenter = pr
        pr.viewController = vc
        router.viewController = vc
        router.dataStore = ir
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func displayList() {
        DispatchQueue.main.async {
            self.colV.reloadData()
            
            if self.isFirstDisplay{
                
                let idx = IndexPath(row: self.viewIdx, section: 0)
                self.colV.scrollToItem(at: idx,
                                       at: UICollectionView.ScrollPosition.centeredHorizontally,
                                       animated: false)
                self.isFirstDisplay = false
                
                var cnt = 0
                if let uCnt = self.interactor?.getDataList().count{
                    cnt = uCnt
                }
                self.pageCntr.numberOfPages = cnt
                self.pageCntr.currentPage = self.viewIdx
                
            }
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.interactor?.loadWeatherDataList(seedData: self.seedDataList)
        
    }
    
    public func setSeedData(locationList: [CLLocation], viewIdx: Int){
        
        self.seedDataList = locationList
        self.viewIdx = viewIdx
        
    }
}


extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let cellWidth = self.colV.frame.width
        
        let offset = scrollView.contentOffset
        let idx = offset.x / cellWidth
        
        self.pageCntr.currentPage = Int(idx)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var cnt = 0
        if let uCnt = self.interactor?.getDataList().count{
            cnt = uCnt
        }
        return cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let uCell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailColCell.description(), for: indexPath) as? DetailColCell else{
            return UICollectionViewCell()
        }
        
        guard let uDataList = self.interactor?.getDataList() else{
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
        
        return collectionView.frame.size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
