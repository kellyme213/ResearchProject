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
    var planePosition = SIMD3<Float>()
    var angles = SIMD3<Float>()
    
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
            guard let plane = scene.findEntity(named: "planeEntity") else { return }

            let newPosition = (plane.transform.matrix.inverse * frame.camera.transform.columns.3).xyz
            //let newPosition = (frame.camera.transform.columns.3.xyz - planePosition) / scale
            //let eAngles = frame.camera.eulerAngles
            //let newT = Transform.init(pitch: eAngles.x, yaw: eAngles.y, roll: eAngles.z)
            //let newT2 = plane.transform.matrix.inverse * newT.matrix
            //let newT3 = Transform.init(matrix: newT2)
            fileWriter.addDataPoint(timestamp: Float(frame.timestamp),
                                    position: newPosition,
                                    eulerAngles: frame.camera.eulerAngles)
            //print(planePosition)
            
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

                    planePosition = planeAnchor!.transform.columns.3.xyz
                    angles = session.currentFrame!.camera.eulerAngles
                    session.setWorldOrigin(relativeTransform: planeAnchor!.transform)
                }
            }
        }
    }
}
