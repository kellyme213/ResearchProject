//
//  AppView.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/18/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import Foundation
import ARKit
import RealityKit

class AppView: ARView, ARSessionDelegate
{

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        //print(frame.timestamp)
        //print(frame.camera.transform.columns.3)

        
        
    }
    

    var added = false
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors
        {
            //print(anchor)
            if (!added)
            {
                added = true
                let planeAnchor = anchor as? ARPlaneAnchor
                if (planeAnchor != nil)
                {
                    session.setWorldOrigin(relativeTransform: planeAnchor!.transform)
                    
                    let plane = AnchorEntity.init(anchor: planeAnchor!)
                    
                    let e = try! Entity.load(contentsOf:
                        getLibraryFilePath().appendingPathComponent(SCENE_FOLDER_NAME + "test.usdz"))
                    plane.addChild(e)
                    scene.addAnchor(plane)
                    
                    e.playAnimation(e.availableAnimations[0].repeat(), transitionDuration: 0.0, startsPaused: false)
                }
                       
                //let str = "hello"
                //try! str.write(to: urls[0].appendingPathComponent("test.txt"), atomically: true, encoding: .ascii)
                
            }
        }
    }
}
