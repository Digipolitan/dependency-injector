//
//  ViewController.swift
//  DGDependencyInjectorSample-watchOS
//
//  Created by Benoit BRIATTE on 23/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit
import DGDependencyInjector

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let t = TemplateClass()
        print("iOS \(t)")
    }
}
