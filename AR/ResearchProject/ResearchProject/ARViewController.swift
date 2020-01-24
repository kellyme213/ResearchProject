//
//  ARViewController.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/17/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet var appView: AppView!
    var projectName: String!
    var sceneName: String!
    var take: Int!
    let scaleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(generateOutputFileName(sceneName: sceneName, projectName: projectName, take: take))
        
        appView.sceneName = sceneName
        
        appView.session.delegate = appView

        let a = ARWorldTrackingConfiguration.init()
        a.planeDetection = .horizontal
        
        appView.session.run(a, options: .resetTracking)
        
        
        let startButton = UIButton()
        startButton.frame = CGRect(x: 0, y: 50, width: 100, height: 20)
        startButton.setTitleColor(.systemRed, for: .normal)
        startButton.setTitle("start", for: .normal)
        appView.addSubview(startButton)
        
        let pauseButton = UIButton()
        pauseButton.frame = CGRect(x: 100, y: 50, width: 100, height: 20)
        pauseButton.setTitleColor(.systemRed, for: .normal)
        pauseButton.setTitle("pause", for: .normal)
        appView.addSubview(pauseButton)
        
        let fileLabel = UILabel()
        fileLabel.text = generateOutputFileName(sceneName: sceneName,
                                                projectName: projectName,
                                                take: take)
        fileLabel.frame = CGRect(x: 20, y: 330, width: 450, height: 20)
        fileLabel.textAlignment = .left
        fileLabel.textColor = .systemRed
        appView.addSubview(fileLabel)
        
        let scaleSlider = UISlider()
        scaleSlider.minimumValue = 1.0
        scaleSlider.maximumValue = 10.0
        scaleSlider.setValue(1.0, animated: false)
        scaleSlider.frame = CGRect(x: 200, y: 50, width: 200, height: 20)
        scaleSlider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
        appView.addSubview(scaleSlider)
        
        scaleLabel.text = "1.0"
        scaleLabel.frame = CGRect(x: 420, y: 50, width: 100, height: 20)
        scaleLabel.textAlignment = .left
        scaleLabel.textColor = .systemRed
        appView.addSubview(scaleLabel)
//        let button = UIButton()
//        button.setTitle("HELLO", for: .normal)
//        //button.center = CGPoint(x: 100, y: 100)
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        button.addTarget(self, action: #selector(labelTapped(sender:)), for: .touchUpInside)
//        appView.addSubview(button)
    }
    
    @objc func sliderChanged(sender: UISlider)
    {
        scaleLabel.text = String(sender.value)
        appView.adjustScale(s: sender.value)
    }
    
    @objc func labelTapped(sender: UIButton)
    {
        //appView.session.pause()
        //self.performSegue(withIdentifier: "toSelectView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSelectView")
        {
            //let view = segue.destination as! NewViewController
        }
    }
}
