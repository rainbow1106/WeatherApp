//
//  NaviC.swift
//  JerryWeather
//
//  Created by 박병준 on 2019. 8. 7..
//  Copyright © 2019년 박병준. All rights reserved.
//

import UIKit

class NaviC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let mainVC = ListVC()
        self.setViewControllers([mainVC], animated: false)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
