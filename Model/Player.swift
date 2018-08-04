//
//  Player.swift
//  CloudKitDemo
//
//  Created by Renato Lopes on 01/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation
import UIKit

class Player {
    let name: String?
    let type: String?
    let photo: URL
    
    init(name: String, type: String, photo: URL) {
        self.name = name
        self.type = type
        self.photo = photo
    }
    
    
}
