//
//  ViewController.swift
//  Smenar
//
//  Created by Martin Berger on 11/04/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import UIKit

extension UIViewController {
    //
    func push(_ vc: UIViewController) {
        //
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UINavigationController {
    func backButton() {
        self.navigationBar.backItem?.backBarButtonItem?.title = "Zpět"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


