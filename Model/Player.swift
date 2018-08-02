//
//  Player.swift
//  CloudKitDemo
//
//  Created by Renato Lopes on 01/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation


class Player {
    let nick: String?
    let typePlayer: String?
    
    init(nick: String, type: String) {
        self.nick = nick
        self.typePlayer = type
    }
}
