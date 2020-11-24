//
//  DCWallGenerator.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/4/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import Foundation
import SpriteKit

class DCWallGenerator: SKSpriteNode
{
    var generationTimer: Timer?
    var walls = [DCWall]()
    var wallFillers = [DCWallFiller]()
    var wallTrackers = [DCWall]()
    
    func startWallGenerationEvery(seconds: TimeInterval)
    {
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(DCWallGenerator.generateWall), userInfo: nil, repeats: true)
    }
    
    func stopGenerating()
    {
        generationTimer?.invalidate()
    }
    
    func generateWall()
    {
        var scale: CGFloat
        
        //Random number generator to decide which side to put the beams on
        let randSide = arc4random_uniform(2)
        
        if randSide == 0
        {
            scale = -1.0
        }
        else
        {
            scale = 1.0
        }
        
        let wall = DCWall()
        let wallFiller = DCWallFiller()
        
        wall.position.x = size.width / 2 + wall.size.width / 2
        wallFiller.position.x = size.width / 2 + wall.size.width / 2
        
        
        let randPosY = arc4random_uniform(2)
        
        //Decides if the beam is going to be placed on top or on the middle of the beam
        if randPosY == 0
        {
            wall.position.y = scale * (kDCBeamHeight / 2 + wall.size.height / 2)
            
            walls.append(wall)
            addChild(wall)
            
            wallTrackers.append(wall)
        }
        else
        {
            //The wall filler is added to keep the grey beam grey, or else the black wall overlaps it
            wall.position.y = scale * (kDCBeamHeight / 175 + wall.size.height / 175)
            wallFiller.position.y = scale * (kDCBeamHeight / 175)
            
            walls.append(wall)
            addChild(wall)
            
            wallFillers.append(wallFiller)
            addChild(wallFiller)
            
            wallTrackers.append(wall)
        }
        
        
    }
    
    func stopWalls()
    {
        
        //Stops generation of walls
        stopGenerating()
        
        //Stops every wall
        for wall in walls
        {
            wall.stopMoving()
            wall.color = UIColor.black
        }
        
        for wallFillers in wallFillers
        {
            wallFillers.stopMoving()
        }
        
    }
}
