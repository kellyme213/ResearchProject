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
        
        getFilesWithFileType(fileType: "usdz")

        appView.session.delegate = appView

        let a = ARWorldTrackingConfiguration.init()
        a.planeDetection = .horizontal
        
        appView.session.run(a, options: .resetTracking)
        
        
        let button = UIButton()
        button.setTitle("HELLO", for: .normal)
        button.center = CGPoint(x: 100, y: 100)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.addTarget(self, action: #selector(labelTapped(sender:)), for: .touchUpInside)
        appView.addSubview(button)
    }
    
    @objc func labelTapped(sender: UIButton)
    {
        print("hi")
        //appView.scene.anchors[0].scale = SIMD3<Float>(5.0, 5.0, 5.0)
        //let next: NewViewController = NewViewController(str: "hooray", frame: self.appView.frame)
        //self.navigationController?.pushViewController(next, animated: false)
        appView.session.pause()
        self.performSegue(withIdentifier: "transition", sender: nil)
        //self.present(next, animated: false, completion: {self.removeFromParent()})
        //print("boo")
        //self.removeFromParent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "transition")
        {
            let view = segue.destination as! NewViewController
            view.myString = "hooray"
        }
    }
}
