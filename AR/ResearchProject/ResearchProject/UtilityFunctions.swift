//
//  UtilityFunctions.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/19/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import Foundation

let SCENE_FOLDER_NAME = "scenes/"
let OUTPUT_FOLDER_NAME = "output/"

func getLibraryFilePath() -> URL
{
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0]
}

func getFilesWithFileType(fileType: String) -> [URL]
{
    let libraryPath = getLibraryFilePath().appendingPathComponent(SCENE_FOLDER_NAME)
    
    let urls = try! FileManager.default.contentsOfDirectory(at: libraryPath,
                                                            includingPropertiesForKeys: .none,
                                                            options: .includesDirectoriesPostOrder)
    var filteredURLS: [URL] = []
    for url in urls
    {
        if (url.pathExtension == fileType)
        {
            filteredURLS.append(url)
        }
    }
    
    return filteredURLS
}

func generateOutputFileName(sceneName: String, projectName: String, take: Int) -> String
{
    var fileName = sceneName + "-" + projectName + "-"
    
    var takeString = ""
    if (take <= 9)
    {
        takeString = "0" + String(take)
    }
    else
    {
        takeString = String(take)
    }
    
    fileName += takeString + ".camout"
    return fileName
}

func generateTakeNumberForScene(sceneName: String, projectName: String) -> Int
{
    let urls = getFilesWithFileType(fileType: "camout")
    
    for x in 1..<100
    {
        let fileName = generateOutputFileName(sceneName: sceneName, projectName: projectName, take: x)
        
        var found = false
        for url in urls
        {
            if (url.lastPathComponent == fileName)
            {
                found = true
                break
            }
        }
        
        if (!found)
        {
            return x
        }
    }
    
    assert(false, "over 100 takes for " + sceneName +
                    "-" + projectName + ". Please delete takes or use a new project name.")
    return -1
}




/*
 let roll  = frame.camera.eulerAngles[0]
 let pitch = frame.camera.eulerAngles[1]
 let yaw   = frame.camera.eulerAngles[2]
 
 let cy: Float = cos(yaw * 0.5)
 let sy: Float = sin(yaw * 0.5)
 let cp: Float = cos(pitch * 0.5)
 let sp: Float = sin(pitch * 0.5)
 let cr: Float = cos(roll * 0.5)
 let sr: Float = sin(roll * 0.5)
 
 var q = simd_quatf.init()
 q.vector[3] = cy * cp * cr + sy * sp * sr
 q.vector[0] = cy * cp * sr - sy * sp * cr
 q.vector[1] = sy * cp * sr + cy * sp * cr
 q.vector[2] = sy * cp * cr - cy * sp * sr
 
 let rotateMatrix = simd_float4x4.init(q)
 let newMat = frame.camera.transform * rotateMatrix.inverse
 print("t")
 print(newMat.columns.3)
 print(frame.camera.transform.columns.3)
 */
