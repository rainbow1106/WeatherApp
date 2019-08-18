//
//  SearchVC.swift
//  JerryWeather
//
//  Created by 박병준 on 8/15/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import UIKit
import MapKit

protocol SearchDisplayLogic: class {
    
    func displayList()
    
}

final class SearchVC: UIViewController, SearchDisplayLogic {

    var interactor: SearchBusinessLogic?
    var router: (SearchRoutingLogic & SearchDataPassing)?
    
    // ibs
    
    @IBOutlet weak var searchResultTableV: UITableView!
    
    
    //header
    @IBOutlet var headerV: UIView!
    @IBOutlet weak var headerTitleLB: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelBTN: UIButton!
    
    private var resultSearchC = UISearchController()
    
    convenience init(){
        self.init(nibName: "SearchVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.makeRelation()
        self.organizeSubviews()
        self.settingSubviews()
        self.bindBtnEvents()
        
    }

    private func makeRelation(){
        
        let vc = self
        let ir = SearchInteractor()
        let pr = SearchPresenter()
        let router = SearchRouter()
        
        vc.interactor = ir
        vc.router = router
        ir.presenter = pr
        pr.viewController = vc
        router.viewController = vc
        router.dataStore = ir
        
    }
    private func settingSubviews(){
        
        self.searchResultTableV.layoutMargins = .zero
        self.searchResultTableV.contentInset = .zero
        
        self.searchResultTableV.showsVerticalScrollIndicator = false
        self.searchResultTableV.showsHorizontalScrollIndicator = false
        
        self.searchResultTableV.separatorStyle = .none
        
        self.searchResultTableV.delegate = self
        self.searchResultTableV.dataSource = self
        
        
        self.searchResultTableV.register(UINib.init(nibName: "SearchResultCell", bundle: nil),
                                         forCellReuseIdentifier: SearchResultCell.description())
        
        
        //
        
        self.searchBar.delegate = self
        definesPresentationContext = true
        
        
        
    }
    
    private func settingHeader(){
        
        self.headerTitleLB.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.headerTitleLB.textAlignment = .center
        self.headerTitleLB.numberOfLines = 1
        
        //
        self.cancelBTN.setTitle("취소", for: .normal)
        self.cancelBTN.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        //
        self.searchBar.backgroundImage = nil
        self.searchBar.barTintColor = .white
        
        
    }
    
    private func bindBtnEvents(){
        
        self.cancelBTN.addTarget(self, action: #selector(self.cancelBtnTap), for: .touchUpInside)
    }
    
    
    private func organizeSubviews(){
        
        self.searchResultTableV.tableHeaderView = self.headerV
        
        var frm = self.headerV.frame
        frm.size = CGSize(width: self.searchResultTableV.frame.width,
                          height: 70)
        frm.origin = .zero
        self.headerV.frame = frm
        self.headerV.autoresizingMask = [.flexibleWidth]
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc private func cancelBtnTap(){
        self.router?.moveEnd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.searchBar.resignFirstResponder()
    }
    
    func displayList() {
        self.searchResultTableV.reloadData()
    }
}




extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if let uCnt = self.interactor?.getDataList().count{
            count = uCnt
        }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let uCell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.description()) as? SearchResultCell else{
            return UITableViewCell()
        }
        
        guard let uDataList = self.interactor?.getDataList(),
            indexPath.row < uDataList.count else{
            return UITableViewCell()
        }
        let uCellData = uDataList[indexPath.row]
        
        uCell.mapCellData(totalText: uCellData.name, keyword: self.searchBar.text)
        return uCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let uDataList = self.interactor?.getDataList() else{
            return
        }
        guard indexPath.row < uDataList.count else{
            return
        }
        
        self.interactor?.saveLocation(cellData: uDataList[indexPath.row],
                                      success: {

                                        self.router?.moveEnd()
        })
        
    }
}

extension SearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.interactor?.searchLocation(searchBar.text)
        
    }
}
