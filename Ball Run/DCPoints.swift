//
//  DCPoints.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 11/14/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class DCPoints: SKLabelNode
{
    var points = 0
    var x = 0
    
    init(num: Int)
    {
        super.init()
        
        points = num
        
        text = "\(num)"
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func incriment()
    {
        x = x + 1
        if x == 1
        {
            //Skip the first point
        }
        else
        {
            points = points + 1
            text = "\(points)"
            
        }
    }
    
    func saveHighScore(pts: Int)
    {
        self.points = pts
        
        text = "\(self.points)"
        
    }

    
}
