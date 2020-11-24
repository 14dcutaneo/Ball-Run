//
//  DCBeamMoving.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/1/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import Foundation
import SpriteKit

class DCBeamMoving: SKSpriteNode
{
    let numSegments = 20
    var colorNumber = 0
    
    //Loops the same color over and over again
    
    var colorOne = UIColor.lightGray
    var colorTwo = UIColor.lightGray
    
    init(size: CGSize)
    {
        //Initial color (changed for my testing purposes)
        super.init(texture: nil, color: UIColor.lightGray, size: CGSize(width: size.width*2, height: size.height))
        
        anchorPoint = CGPoint(x: 0, y: 0.5)
        
        
        //Loop to reproduce the beam
        //NOTE: CHOOSE LATER ON WHETHER OR NOT TO HAVE IT ONE OR TWO COLORS
        //END NOTE
        var i = 0
        while i < numSegments
        {
            //Changes beam color. (May be removed later or made the same color)
            var beamColor: UIColor!
            
            if i % 2 == 0
            {
                beamColor = colorOne
            }
            else
            {
                beamColor = colorTwo
            }
            
            i = i + 1
            
            //Makes segements however thick depending on how manyy here are
            let segment = SKSpriteNode(color: beamColor, size: CGSize (width: self.size.width / CGFloat (numSegments), height: self.size.height ))
            
            segment.anchorPoint = CGPoint(x: 0, y: 0.5)
            segment.position = CGPoint(x: CGFloat(i)*segment.size.width, y: 0)
            addChild(segment)
        
        }
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Makes the beams all move left to follow the ball
    func start()
    {
        let adjustedDuration = TimeInterval(frame.size.width / kDefaultXToMovePerSecond)
        
        let moveLeft = SKAction.moveBy(x:-frame.size.width / 5, y: 0, duration: adjustedDuration / 5)
        run(moveLeft, completion: {})
        
        //Makes the beam infinite by moving it back to original position
        let beamReset = SKAction .moveTo(x: 0, duration: 0)
        
        let moveSequence = SKAction.sequence([moveLeft, beamReset])
        
        run(SKAction.repeatForever(moveSequence))
        
        
    }
    
    func stop()
    {
        removeAllActions()
    }
    
}
