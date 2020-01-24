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
    var sceneName: String!
    var scale: Float = 1.0
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if (added)
        {
            //print(frame.camera.transform.columns.3)
        }
    }
    
    func adjustScale(s: Float)
    {
        scale = s
        guard let plane = scene.findEntity(named: "planeEntity") else { return }
        plane.transform.scale = SIMD3<Float>(repeating: scale)
    }
    
    var added = false
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors
        {
            if (!added)
            {
                added = true
                let planeAnchor = anchor as? ARPlaneAnchor
                if (planeAnchor != nil)
                {
                    
                    let plane = AnchorEntity.init(anchor: planeAnchor!)
                    plane.transform.matrix = planeAnchor!.transform
                    
                    let e = try! Entity.load(contentsOf:
                        getLibraryFilePath().appendingPathComponent(SCENE_FOLDER_NAME + sceneName))
                    plane.transform.scale = SIMD3<Float>(repeating: scale)
                    plane.addChild(e)
                    plane.name = "planeEntity"
                    scene.addAnchor(plane)
                    
                    if (e.availableAnimations.count > 0)
                    {
                        e.playAnimation(e.availableAnimations[0].repeat(), transitionDuration: 0.0, startsPaused: false)
                    }

                    session.setWorldOrigin(relativeTransform: planeAnchor!.transform)

                }
            }
        }
    }
}
