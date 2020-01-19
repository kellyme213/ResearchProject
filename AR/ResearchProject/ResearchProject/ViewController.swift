//
//  ViewController.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/17/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var appView: AppView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appView.session.delegate = appView

        let a = ARWorldTrackingConfiguration.init()
        a.planeDetection = .horizontal
        
        appView.session.run(a, options: .resetTracking)
    }
}
