//
//  FileWriter.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/19/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import Foundation
import simd

struct FileWriterDataPoint
{
    var timestamp: Float!
    var position: SIMD3<Float>!
    var eulerAngles: SIMD3<Float>!
    var matrix: simd_float4x4!
    var type: Int = 0

    func toString() -> String
    {
        if (type == 0)
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
        else
        {
            return
                String(timestamp) + " " +
                String(matrix.columns.3.x) + " " +
                String(matrix.columns.3.y) + " " +
                String(matrix.columns.3.z) + " " +
                String(matrix.columns.0.x) + " " +
                String(matrix.columns.0.y) + " " +
                String(matrix.columns.0.z) + " " +
                String(matrix.columns.1.x) + " " +
                String(matrix.columns.1.y) + " " +
                String(matrix.columns.1.z) + " " +
                String(matrix.columns.2.x) + " " +
                String(matrix.columns.2.y) + " " +
                String(matrix.columns.2.z) + " " + "\n"
        }
    }
}

class FileWriter
{
    var projectName: String
    var take: Int
    var sceneName: String
    
    var fileName: String!
    var timestampStart: Double!
    var begunWriting: Bool = false
    var data: [FileWriterDataPoint] = []
    
    init(projectName: String, sceneName: String)
    {
        self.projectName = projectName
        self.sceneName = sceneName
        self.take = generateTakeNumberForScene(sceneName: self.sceneName,
                                               projectName: self.projectName)
        initializeFile()
    }
    
    func initializeFile()
    {
        self.fileName = generateOutputFileName(sceneName: sceneName,
                                               projectName: projectName,
                                               take: take)
        print(self.fileName!)
    }
    
    func pause()
    {
        begunWriting = false
    }
    
    func addDataPoint(timestamp: Double, position: SIMD3<Float>, eulerAngles: SIMD3<Float>)
    {
        if (!begunWriting)
        {
            begunWriting = true
            timestampStart = timestamp
        }
        var dataPoint = FileWriterDataPoint()
        dataPoint.timestamp = Float(timestamp - timestampStart)
        dataPoint.position = position
        dataPoint.eulerAngles = eulerAngles
        data.append(dataPoint)
    }
    
    func addDataPoint(timestamp: Double, matrix: simd_float4x4)
    {
        if (!begunWriting)
        {
            begunWriting = true
            timestampStart = timestamp
        }
        var dataPoint = FileWriterDataPoint()
        dataPoint.timestamp = Float(timestamp - timestampStart)
        dataPoint.matrix = matrix
        dataPoint.type = 1
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
