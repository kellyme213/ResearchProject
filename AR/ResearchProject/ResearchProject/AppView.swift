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
    var projectName: String!

    var scale: Float = 1.0
    var recording: Bool = false
    var fileWriter: FileWriter!
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        //print("hello")
        for anchor in anchors
        {
            guard let p = anchor as? ARPlaneAnchor else {return}
            //print(p.extent)
        }

    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if (recording)
        {
            fileWriter.addDataPoint(timestamp: Float(frame.timestamp),
                                    position: frame.camera.transform.columns.3.xyz / scale,
                                    eulerAngles: frame.camera.eulerAngles)
            
        }
    }
    
    func beginRecording()
    {
        fileWriter = FileWriter(projectName: projectName, sceneName: sceneName)
        recording = true
        guard let plane = scene.findEntity(named: "planeEntity") else { return }
        guard let entity = plane.children.first else { return }
        if (entity.availableAnimations.count > 0)
        {
            entity.playAnimation(entity.availableAnimations[0],
                                 transitionDuration: 0.0,
                                 startsPaused: false)
        }
    }
    
    func endRecording()
    {
        recording = false
        fileWriter.writeToFile()
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
            //guard let p = anchor as? ARPlaneAnchor else {return}
            //print(p.extent)
            if (!added)
            {
                added = true
                let planeAnchor = anchor as? ARPlaneAnchor
                if (planeAnchor != nil)
                {
                    
                    let plane = AnchorEntity.init(anchor: planeAnchor!)
                    plane.transform.matrix = planeAnchor!.transform
                    
                    let e = try! Entity.load(contentsOf:
                        getLibraryFilePath().appendingPathComponent(SCENE_FOLDER_NAME + sceneName + ".usdz"))
                    
                    plane.transform.scale = SIMD3<Float>(repeating: scale)
                    plane.addChild(e)
                    plane.name = "planeEntity"
                    scene.addAnchor(plane)
                    
                    if (e.availableAnimations.count > 0)
                    {
                        //e.playAnimation(e.availableAnimations[0].repeat(), transitionDuration: 0.0, startsPaused: false)
                    }

                    session.setWorldOrigin(relativeTransform: planeAnchor!.transform)
                }
            }
        }
    }
}
