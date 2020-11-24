//
//  DCWall.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/4/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import Foundation
import SpriteKit

class DCWall: SKSpriteNode
{
    let wallWidth: CGFloat = 30.0
    
    var wallColor = UIColor.black
    
 
    
   init()
    {
        
        let randBarSize = arc4random_uniform(2)
        
        if randBarSize == 0
        {
            
            let wallHeight: CGFloat = 75.0
            
            let size = CGSize(width: wallWidth, height: 75.0)
            
            //Makes walls and their width's and heights
            super.init(texture: nil, color: wallColor, size: CGSize(width: wallWidth, height: wallHeight))
            loadPhysicsBody(size: size)
            startMoving()
            
        }
        
        else
        {
            let wallHeight: CGFloat = 175.0
            
            let size = CGSize(width: wallWidth, height: 175)
            
            
            //Makes walls and their width's and heights
            super.init(texture: nil, color: wallColor, size: CGSize(width: wallWidth, height: wallHeight))
            loadPhysicsBody(size: size)
            startMoving()
            
        }
        
        
    }
    
    func loadPhysicsBody(size:CGSize)
    {
        //Regesters whether or not contact has been made witht the wall
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = wallCategory
        physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving()
    {
        //Makes walls start to move forever
        let moveLeft = SKAction.moveBy(x: -kDefaultXToMovePerSecond, y: 0, duration: 1)
        run(SKAction.repeatForever(moveLeft))
    }
    
    func stopMoving()
    {
        removeAllActions()
        physicsBody?.affectedByGravity = true
        wallColor = UIColor.black
    }
    
    
}
