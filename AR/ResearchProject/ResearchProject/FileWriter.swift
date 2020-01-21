//
//  FileWriter.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/19/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import Foundation

struct FileWriterDataPoint
{
    var timestamp: Float
    var position: SIMD3<Float>
    var eulerAngles: SIMD3<Float>

    func toString() -> String
    {
        return
            String(timestamp) + " " +
            String(position[0]) + " " +
            String(position[1]) + " " +
            String(position[2]) + " " +
            String(eulerAngles[0]) + " " +
            String(eulerAngles[1]) + " " +
            String(eulerAngles[2]) + " " + "\n"
    }
}

class FileWriter
{
    var projectName: String
    var take: Int
    var sceneName: String
    
    var fileName: String!
    var timestampStart: Float!
    var begunWriting: Bool = false
    var data: [FileWriterDataPoint] = []
    
    init(projectName: String, sceneName: String)
    {
        self.projectName = projectName
        self.sceneName = sceneName
        self.take = generateTakeNumberForScene(sceneName: self.projectName,
                                               projectName: self.sceneName)
        initializeFile()
    }
    
    func initializeFile()
    {
        self.fileName = generateOutputFileName(sceneName: sceneName,
                                               projectName: projectName,
                                               take: take)
    }
    
    func pause()
    {
        begunWriting = false
    }
    
    func addDataPoint(timestamp: Float, position: SIMD3<Float>, eulerAngles: SIMD3<Float>)
    {
        if (!begunWriting)
        {
            begunWriting = true
            timestampStart = timestamp
        }
        let dataPoint = FileWriterDataPoint(timestamp: timestamp - timestampStart,
                                            position: position,
                                            eulerAngles: eulerAngles)
        data.append(dataPoint)
    }
    
    func writeToFile()
    {
        var fileOutput = ""
        for dataPoint in data
        {
            fileOutput += dataPoint.toString()
        }
        
        let fileURL = getLibraryFilePath().appendingPathComponent(OUTPUT_FOLDER_NAME + fileName)
        
        try! fileOutput.write(to: fileURL, atomically: false, encoding: .ascii)
    }
}
