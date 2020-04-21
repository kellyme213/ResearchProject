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

func getFilesWithFileType(folder: String, fileType: String) -> [URL]
{
    let libraryPath = getLibraryFilePath().appendingPathComponent(folder)
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
    let urls = getFilesWithFileType(folder: OUTPUT_FOLDER_NAME, fileType: "camout")
    
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

extension SIMD4
{
    var xyz: SIMD3<Float>
    {
        return SIMD3<Float>(self.x as! Float, self.y as! Float, self.z as! Float)
    }
}

