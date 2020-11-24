//
//  DCBall.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/2/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import Foundation
import SpriteKit

class DCBall: SKSpriteNode
{
    var isUpsideDown = false
    var valueSizePlusBeamHeight: CGFloat = 0.0
    
    init()
    {
        //Dimentions of sprite as a box
        let size = CGSize(width: 32, height: 32)
        super.init(texture: nil, color: UIColor.clear, size: size)
        loadAppearance()
        loadPhysicsBody(size: size)
        
    }
    
    func loadAppearance()
    {
        //Creates circle size and preferences
        let Circle = SKShapeNode(circleOfRadius: 16)
        Circle.position = CGPoint(x: 0, y: 2.5)
        Circle.glowWidth = 0
        Circle.lineWidth = 6.0
        
        let randColorPicker = arc4random_uniform(3)

        if randColorPicker == 0
        {
            //Color of the ball is red
            Circle.strokeColor = SKColor(red: 242/255, green: 99/255, blue: 108/255, alpha: 1.0)
            Circle.fillColor = SKColor(red: 209/255, green: 43/255, blue: 54/255, alpha: 1.0)
        }
        else
            if randColorPicker == 1
            {
                //Color of the ball is blue
                Circle.strokeColor = SKColor(red: 96/255, green: 225/255, blue: 242/255, alpha: 1.0)
                Circle.fillColor = SKColor(red: 0/255, green: 122/255, blue: 237/255, alpha: 1.0)
            }
            else
                {
                    //Color of the ball is green
                    Circle.strokeColor = SKColor(red: 46/255, green: 232/255, blue: 0/255, alpha: 1.0)
                    Circle.fillColor = SKColor(red: 0/255, green: 178/255, blue: 38/255, alpha: 1.0)
                }
        
        
        self.addChild(Circle)
        
        valueSizePlusBeamHeight = (size.height + kDCBeamHeight)
        
    }
    
    func loadEndAppearance()
    {
        //Creates circle size and preferences
        let Circle = SKShapeNode(circleOfRadius: 16)
        Circle.position = CGPoint(x: 0, y: 2.5)
        Circle.strokeColor = UIColor.black
        Circle.glowWidth = 0
        Circle.fillColor = UIColor.black
        Circle.lineWidth = 6.0
        self.addChild(Circle)
        
        valueSizePlusBeamHeight = (size.height + kDCBeamHeight)
    }
    
    func loadPhysicsBody(size: CGSize)
    {
        //Regesters whether or not contact has been made witht the wall
        physicsBody = SKPhysicsBody(circleOfRadius: 16)
        physicsBody?.categoryBitMask = ballCategory
        physicsBody?.contactTestBitMask = wallCategory
        physicsBody?.affectedByGravity = false
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    
    //Flips the ball and reverses gravity
    func flip()
    {
        //Makes it true / false if it is upside down or not
        isUpsideDown = !isUpsideDown
        
        var scale: CGFloat!
        
        if isUpsideDown
        {
            scale = -1
        }
        
        else
        {
            scale = 1
        }
        
        //Translates the ball up or down according to if the ball is already translated upside down
        let translate = SKAction.moveBy(x: 0, y: scale*(valueSizePlusBeamHeight), duration: 0.1)
        let flip = SKAction.scaleY(to: scale, duration: 0.1)
        
        run(translate)
        run(flip)
    
        
    }
    
    //Makes the ball jump up with a gravity - like effect
    func jump()
    {
        //Creates variables for each jumping height
        var heightJumped1: CGFloat!
        var heightJumped2: CGFloat!
        var heightJumped3: CGFloat!
        var heightstay: CGFloat!
       
        
        
        if isUpsideDown
        {
            //If the ball is upside down, jump in the negative direction
            heightJumped1 = -50
            heightJumped2 = -32.5
            heightJumped3 = -12.5
            heightstay = -5
            
        }
            
        else
        {
            //If the ball is not upside down, jump in the positive direction
            heightJumped1 = 50
            heightJumped2 = 32.5
            heightJumped3 = 12.5
            heightstay = 5
        }
        
        if action(forKey: "jump") == nil
        {
            //Creates action for each variable to get a "gravity" effect while jumping and falling
            let jump = SKAction.moveBy(x: 0, y: heightJumped1, duration: 0.13)
            let jump2 = SKAction.moveBy(x: 0, y: heightJumped2, duration: 0.1)
            let jump3 = SKAction.moveBy(x: 0, y: heightJumped3, duration: 0.08)
            let stay = SKAction.moveBy(x: 0, y: heightstay, duration: 0.05)
            let stay2 = SKAction.moveBy(x: 0, y: -heightstay, duration: 0.05)
            let fall = SKAction.moveBy(x: 0, y: -heightJumped1, duration: 0.13)
            let fall2 = SKAction.moveBy(x: 0, y: -heightJumped2, duration: 0.1)
            let fall3 = SKAction.moveBy(x: 0, y: -heightJumped3, duration: 0.08)
            
            //Runs all of the jumps in order
            run(SKAction.sequence([jump, jump2, jump3, stay, stay2, fall3, fall2, fall]), withKey:"jump")
            
            
            
        }
        
        
    }
    
    func bounceOff()
    {
        //Makes the ball bounce off of the wall when contact is made
        physicsBody?.affectedByGravity = true
        physicsBody?.applyImpulse(CGVector(dx: -3, dy: 15))
        
    }
    
    func stop()
    {
        removeAllActions()
       
    }
    
}
    
