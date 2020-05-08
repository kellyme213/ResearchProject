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
    var anchorId: UUID!
    
    func addStuffToScene(anchor: ARPlaneAnchor)
    {
        if (!added)
        {
            let planeAnchor = anchor
            added = true
            let plane = AnchorEntity.init(anchor: planeAnchor)
            anchorId = planeAnchor.identifier
            self.session.add(anchor: planeAnchor)
            
            let e = try! Entity.load(contentsOf:
                getLibraryFilePath().appendingPathComponent(SCENE_FOLDER_NAME + sceneName + ".usdz"))
            
            print(e.availableAnimations.count)
            plane.transform.scale = SIMD3<Float>(repeating: scale)
            plane.addChild(e)
            plane.name = "planeEntity"
            scene.addAnchor(plane)
            

            planePosition = planeAnchor.transform.columns.3.xyz
            angles = session.currentFrame!.camera.eulerAngles
            scale = plane.children[0].scale.x
            
            //let b = MeshResource.generatePlane(width: planeAnchor.extent.x, depth: planeAnchor.extent.z)
            //plane.addChild(ModelEntity.init(mesh: b))
            
            session.setWorldOrigin(relativeTransform: planeAnchor.transform)
            self.session.run(ARWorldTrackingConfiguration())
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        if (!recording && !added)
        {
            //taken from apples swiftstriketabletop project
            let screenCenter = CGPoint(x: self.frame.midX, y: self.frame.midY)

            let results = self.hitTest(screenCenter, types: [.existingPlaneUsingExtent])
            guard let result = results.first(where: { result -> Bool in

                // Ignore results that are too close or too far away to the camera when initially placing
                guard result.distance > 0.5 && result.distance < 2.0 else {
                    return false
                }

                // Make sure the anchor is a horizontal plane with a reasonable extent
                guard let planeAnchor = result.anchor as? ARPlaneAnchor,
                    planeAnchor.alignment == .horizontal else {
                        return false
                }

                // Make sure the horizontal plane has a reasonable extent
                let extent = simd_length(planeAnchor.extent)
                guard extent > 0.5 && extent < 2 else {
                    return false
                }

                return true
            }),
            let planeAnchor = result.anchor as? ARPlaneAnchor else {
                return
            }
            
            addStuffToScene(anchor: planeAnchor)
        }
        
        
        
        
        
        guard let plane = scene.findEntity(named: "planeEntity") else { return }
                    
        for a in frame.anchors
        {
            if (a.identifier == anchorId)
            {
                
                
                let p = a.transform * plane.children[0].transform.matrix
                let m = float4x4.init(diagonal: SIMD4<Float>(1.0 / scale,
                                                             1.0 / scale,
                                                             1.0 / scale,
                                                             1.0))
                let i = (p * m).inverse
                let transformationMatrix = i * frame.camera.transform
                
                if (recording)
                {
                    fileWriter.addDataPoint(timestamp: (Date().timeIntervalSinceReferenceDate),
                                            matrix: transformationMatrix)
                }
                
    //            let newPosition = (plane.transform.matrix.inverse * frame.camera.transform.columns.3).xyz
    //
    //            fileWriter.addDataPoint(timestamp: (Date().timeIntervalSinceReferenceDate),
    //                                    position: newPosition,
    //                                    eulerAngles: frame.camera.eulerAngles)
                
                
            }
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
        guard let plane = scene.findEntity(named: "planeEntity") else { return }
        plane.children[0].setScale(SIMD3<Float>(repeating: s * scale), relativeTo: plane)
    }
    
    func adjustPosition(p: SIMD3<Float>)
    {
        guard let plane = scene.findEntity(named: "planeEntity") else { return }
        plane.children[0].setPosition(p, relativeTo: plane)
    }
    
    var added = false
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    }
}



extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        
//        let coachingOverlay = ARCoachingOverlayView()
//        coachingOverlay.delegate = self
//        coachingOverlay.session = self.session
//        coachingOverlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//
//        coachingOverlay.goal = .horizontalPlane
//        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        //Ready to add entities next?
    }
}
