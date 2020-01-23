//
//  NewViewController.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/20/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import Foundation
import UIKit

class NewViewController: UIViewController
{
    @IBOutlet var selectView: SelectView!
    //var newView: UIView
    var myString: String!
    /*
    init(str: String, frame: CGRect)
    {
        self.string = str
        self.newView = UIView(frame: frame)
        newView.backgroundColor = .black
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(newView)
        //self.loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        print(myString!)
        
        
        let button = UIButton()
        button.setTitle(myString, for: .normal)
        button.center = CGPoint(x: 100, y: 100)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        view.addSubview(button)
        
        selectView.addStuffToView()
    }
}
