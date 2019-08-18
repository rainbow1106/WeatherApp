//
//  ListVC.swift
//  JerryWeather
//
//  Created by 박병준 on 2019. 8. 7..
//  Copyright © 2019년 박병준. All rights reserved.
//

import UIKit

protocol ListDisplayLogic: class {
    func displayList()
}

final class ListVC: UIViewController, ListDisplayLogic {

    // ibs
    @IBOutlet weak var table: UITableView!
    @IBOutlet var footer: UIView!
    @IBOutlet weak var plusBTN: UIButton!
    

    var interactor: ListBusinessLogic?
    var router: (ListRoutingLogic & ListDataPassing)?
    
    
    convenience init() {
        self.init(nibName: "ListVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.makeRelation()
        self.organizeSubviews()
        self.settingSubviews()
        self.bindBtnEvents()
        
        
        
//        self.interactor?.loadLocalWeatherList()
        
        // Do any additional setup after loading the view.
    }


    private func makeRelation(){
        
        let vc = self
        let ir = ListInteractor()
        let pr = ListPresenter()
        let router = ListRouter()
        
        vc.interactor = ir
        vc.router = router
        ir.presenter = pr
        pr.viewController = vc
        router.viewController = vc
        router.dataStore = ir
        
    }
    
    private func organizeSubviews(){
        
        self.table.tableFooterView = self.footer
        
        //
        var frm = self.footer.frame
        frm.size = CGSize( width: self.table.frame.width, height: 50)
        frm.origin = .zero
        self.footer.frame = frm
        self.footer.autoresizingMask = [.flexibleWidth]
        
    }
    private func settingSubviews(){
        
        self.table.layoutMargins = .zero
        self.table.contentInset = .zero
        
        self.table.separatorStyle = .none
        
        self.table.showsVerticalScrollIndicator = false
        self.table.showsHorizontalScrollIndicator = false
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: ListCell.description())
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func bindBtnEvents(){
        
        self.plusBTN.addTarget(self, action: #selector(self.plusBtnTap), for: .touchUpInside)
        
    }
    
    @objc private func plusBtnTap(){
        
        self.router?.moveSearch()
    }
    
    func displayList(){
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.interactor?.loadLocalWeatherList()
    }
}



extension ListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.router?.moveDetail(viewIdx: indexPath.row)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uDataList = self.interactor?.getCellDataList() else{
            return
        }
        guard indexPath.row < uDataList.count else{
            return
        }
        let cellDataIdx = uDataList[indexPath.row].idx
        
        if editingStyle == .delete{
            self.interactor?.removeLocalItem(cellDataIdx: cellDataIdx)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let uDataList = self.interactor?.getCellDataList() else{
            return false
        }
        guard indexPath.row < uDataList.count else{
            return false
        }
        let cellData = uDataList[indexPath.row]
        
        guard cellData.isCurrentLocation == false else{
            return false
        }
        
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var cnt = 0
        if let uCnt = self.interactor?.getCellDataList().count{
            cnt = uCnt
        }
        
        return cnt
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let uCell = tableView.dequeueReusableCell(withIdentifier: ListCell.description()) as? ListCell else{
            return UITableViewCell()
        }
        
        guard let uCellDataList = self.interactor?.getCellDataList(),
            indexPath.row < uCellDataList.count else{
            return UITableViewCell()
        }
        uCell.mapCellData(cellData: uCellDataList[indexPath.row])
        return uCell
    }
}
