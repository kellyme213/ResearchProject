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
        if (added)
        {
            print(frame.camera.transform.columns.3)
        }
        
        
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
                    
                    let plane = AnchorEntity.init(anchor: planeAnchor!)
                    plane.transform.matrix = planeAnchor!.transform
                    
                    let e = try! Entity.load(contentsOf:
                        getLibraryFilePath().appendingPathComponent(SCENE_FOLDER_NAME + "test.usdz"))
                    //e.transform.matrix = planeAnchor!.transform
                    //print(e.transform)
                    plane.transform.scale = SIMD3<Float>(repeating: 10)
                    //e.transform.translation = -planeAnchor!.transform.columns.3.xyz
                    plane.addChild(e)
                    scene.addAnchor(plane)
                    //print(e.position)
                    
                    e.playAnimation(e.availableAnimations[0].repeat(), transitionDuration: 0.0, startsPaused: false)
                    session.setWorldOrigin(relativeTransform: planeAnchor!.transform)

                }
                       
                //let str = "hello"
                //try! str.write(to: urls[0].appendingPathComponent("test.txt"), atomically: true, encoding: .ascii)
                
            }
        }
    }
}
