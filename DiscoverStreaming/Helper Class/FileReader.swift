//
//  FileReader.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 23/09/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class FileReader: NSObject {

    class func readFiles() -> [String] {
        return  Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil) 
    }
    
    
}
