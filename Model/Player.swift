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
    let nick: String?
    let typePlayer: String?
    let photo: URL
    
    init(nick: String, type: String, photo: URL) {
        self.nick = nick
        self.typePlayer = type
        self.photo = photo
    }
    
    
}
