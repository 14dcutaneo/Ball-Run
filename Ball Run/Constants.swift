//
//  Constants.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/3/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import Foundation
import UIKit

//Configuration variables
let kDCBeamHeight: CGFloat = 25.0

let kDefaultXToMovePerSecond: CGFloat = 320.0

//Collision variables
let ballCategory: UInt32 = 0x1 << 0
let wallCategory: UInt32 = 0x1 << 1
