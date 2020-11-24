//
//  DCWallFiller.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/15/16.
//  Copyright © 2016 DBit. All rights reserved.
//

//This is more of a fail safe in case the second beam doesnt load.

import Foundation
import SpriteKit

class DCWallFiller: SKSpriteNode
{
    let wallFillerWidth: CGFloat = 30.0
    let wallFillerHeight: CGFloat = kDCBeamHeight
    let wallFillerColor = UIColor.lightGray
    
    init()
    {
        //Makes the fill color move with the beam, since the black wall rests on top of the beam
        super.init(texture: nil, color: wallFillerColor, size: CGSize(width: wallFillerWidth, height: wallFillerHeight))
        startMovingFiller()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startMovingFiller()
    {
        //Makes filler start to move forever
        let moveLeft = SKAction.moveBy(x: -kDefaultXToMovePerSecond, y: 0, duration: 1)
        run(SKAction.repeatForever(moveLeft))
    }
    
    func stopMoving()
    {
        removeAllActions()
    }

}
