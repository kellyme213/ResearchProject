//
//  UtilityFunctions.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/19/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import Foundation

func getLibraryFilePath() -> URL
{
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0]
}
