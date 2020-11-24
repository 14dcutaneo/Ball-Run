//
//  GameScene.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/1/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var beamMoving: DCBeamMoving!
    var beamMoving1: DCBeamMoving!
    var person: DCBall!
    var wallGenerator: DCWallGenerator!
    var uploadScore: GameViewController!
    
    var isStarted = false
    var isGameOver = false
    var isUpsideDown = false
    var noTaps = false
    var noColorChange = false
    
    var colorCounter = -1
    var wallColor = UIColor()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView)
    {
        //Configures tap and swipe controls
        addTouchControls()
        
        //Sets background colour
        backgroundColor = UIColor.white
       
        //Adds the main beam that the ball is rolling on
        addBeamMoving()
        
        //Puts main character (ball) on screen
        addPerson()
        
        //Adds walls to view
        addWallGenerator()
        
        //Start label and information on how to play the game printed on screen
        addLabels()
        
        //Adds points labels
        addPointsLabels()
        
        //Adds High Score
        addHighScore()
        
        //Adds physics
        physicsWorld.contactDelegate = self
        
        
    }
    
    //Configures the tap and swipe in both directions (up and down)
    func addTouchControls()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(GameScene.handleTap))
        view!.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeUp.direction = .up
        view!.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(swipe:)))
        swipeDown.direction = .down
        view!.addGestureRecognizer(swipeDown)
    }
    
    //Authorizes Game Center player to see if they are logged in
    func authPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, Error) in
            
            if view != nil
            {
                //self.present(view!, animated: true, completion: nil)
            }
            else
            {
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
            
        }
    }
    
    func saveHighScore(number: Int)
    {
        if GKLocalPlayer.localPlayer().isAuthenticated
        {
            let scoreReporter = GKScore(leaderboardIdentifier: "BRHS")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }

    
    //Adds the main beam that the ball is rolling on
    func addBeamMoving()
    {
        beamMoving = DCBeamMoving(size: CGSize(width: view!.frame.width, height: kDCBeamHeight))
        
        beamMoving.position = CGPoint(x:0 , y: view!.frame.size.height/2)
        
        addChild(beamMoving)
    }
    
    //Adds the ball
    func addPerson()
    {
        person = DCBall()
        
        person.position = CGPoint(x: 70, y: beamMoving.position.y + beamMoving.frame.size.height/2 + person.frame.size.height/2)
        
        addChild(person)
    }
    
    //Adds the walls that are moving to hit the ball
    func addWallGenerator()
    {
        wallGenerator = DCWallGenerator(color: UIColor.clear, size: view!.frame.size)
        
        wallGenerator.position = view!.center
        
        addChild(wallGenerator)
    }
    
    //Adds information on how to play the game
    func addLabels()
    {
        let tapToFlipLabel = SKLabelNode(text: "Tap to Flip the Ball")
        tapToFlipLabel.name = "tapToFlipLabel"
        tapToFlipLabel.position = CGPoint(x: view!.frame.width / 2, y: person.position.y + 125)
        tapToFlipLabel.fontColor = UIColor.black
        tapToFlipLabel.fontName = "SanFrancisco-Bold"
        tapToFlipLabel.fontSize = 20
        addChild(tapToFlipLabel)
        
        let swipeToJumpLabel1 = SKLabelNode(text: "Swipe Up or Down")
        swipeToJumpLabel1.name = "swipeToJumpLabel1"
        swipeToJumpLabel1.position = CGPoint(x: view!.frame.width / 2, y: person.position.y + 75)
        swipeToJumpLabel1.fontColor = UIColor.black
        swipeToJumpLabel1.fontName = "SanFrancisco-Bold"
        swipeToJumpLabel1.fontSize = 20
        addChild(swipeToJumpLabel1)
        
        let swipeToJumpLabel2 = SKLabelNode(text: "to Jump")
        swipeToJumpLabel2.name = "swipeToJumpLabel2"
        swipeToJumpLabel2.position = CGPoint(x: view!.frame.width / 2, y: person.position.y + 50)
        swipeToJumpLabel2.fontColor = UIColor.black
        swipeToJumpLabel2.fontName = "SanFrancisco-Bold"
        swipeToJumpLabel2.fontSize = 20
        addChild(swipeToJumpLabel2)
        
        let tapToStartLabel = SKLabelNode(text: "Tap to Start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position = CGPoint(x: view!.frame.width / 2, y: person.position.y - 150)
        tapToStartLabel.fontColor = SKColor(red: 242/255, green: 99/255, blue: 108/255, alpha: 1.0)
        tapToStartLabel.fontName = "SanFrancisco-Bold"
        addChild(tapToStartLabel)
        
    }
    
    //Adds the high score labels
    func addPointsLabels()
    {
        let highScoreLabel = DCPoints(num: 0)
        highScoreLabel.position = CGPoint(x: view!.frame.width - 30, y: 60)
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.fontName = "SanFrancisco-Bold"
        addChild(highScoreLabel)
        
        let highScoreLabelText = SKLabelNode(text: "High Score: ")
        highScoreLabelText.name = "highScoreLabelText"
        highScoreLabelText.position = CGPoint (x: view!.frame.width - 150, y: 60)
        highScoreLabelText.fontColor = UIColor.black
        highScoreLabelText.fontName = "SanFrancisco-Bold"
        addChild(highScoreLabelText)
    }
    
    //Saves the high score
    func addHighScore()
    {
        let saves = UserDefaults.standard
        
        let highScoreLabel = childNode(withName: "highScoreLabel") as! DCPoints
        
        highScoreLabel.saveHighScore(pts: saves.integer(forKey: "highscore"))
        

        
    }
    
    
    func start()
    {
        isStarted = true
        
        //Puts points on screen
        let pointsLabel = DCPoints(num: 0)
        pointsLabel.name = "pointsLabel"
        pointsLabel.position = CGPoint(x: view!.frame.width / 2, y: view!.frame.height - 85)
        pointsLabel.fontColor = UIColor.black
        pointsLabel.fontName = "SanFrancisco-Bold"
        pointsLabel.fontSize = 75
        addChild(pointsLabel)
        
        //REMOVES the information on how to play the game
        let tapToFlipLabel = childNode(withName: "tapToFlipLabel")
        tapToFlipLabel?.removeFromParent()
        
        let swipeToJumpLabel1 = childNode(withName: "swipeToJumpLabel1")
        swipeToJumpLabel1?.removeFromParent()
        
        let swipeToJumpLabel2 = childNode(withName: "swipeToJumpLabel2")
        swipeToJumpLabel2?.removeFromParent()
        
        let tapToStartLabel = childNode(withName: "tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        
        //HIDES high score labels and moves them underneath the score
        let highScoreLabel = childNode(withName: "highScoreLabel")
        highScoreLabel?.isHidden = true
        highScoreLabel?.position = CGPoint(x: view!.frame.width / 2 + 100, y: pointsLabel.position.y - 40)
        
        let highScoreLabelText = childNode(withName: "highScoreLabelText")
        highScoreLabelText?.isHidden = true
        highScoreLabelText?.position = CGPoint (x: view!.frame.width / 2 - 30, y: pointsLabel.position.y - 40)

        
        
        //The ground begins to move
        beamMoving.start()
        wallGenerator.startWallGenerationEvery(seconds: 1)
        
        //This is necessary because this makes the walls BEHIND the beam.
        //The original beam was just for the start screen
        beamMoving1 = DCBeamMoving(size: CGSize(width: view!.frame.width, height: kDCBeamHeight))
        
        beamMoving1.position = CGPoint(x:0 , y: view!.frame.size.height/2)
        
        addChild(beamMoving1)
        
        
    }
    
    //Handles the tap to flip function.
    func handleTap(tap: UITapGestureRecognizer)
    {
        
        if isGameOver && noTaps == false
        {
            restart()
        }
        else
            if !isStarted
            {
                start()
            }
            else
                if noTaps == false
                {
                    person.flip()
                    isUpsideDown = !isUpsideDown
            
                }
        
    }
   
    //Handles the swipe UP
    func handleSwipe(swipe: UISwipeGestureRecognizer)
    {
        
        //If the game is over, restart and start the game
        if isGameOver
        {
           restart()
        }
        else
            if !isStarted
            {
                start()
            }
            else
                //If it the ball is not upside down and they swipe up, make the ball jump, and if not, make it just flip
                if isUpsideDown == false && noTaps == false
                {
                    person.jump()
            
                }
                else
                    if noTaps == false
                    {
                        person.flip()
                        isUpsideDown = !isUpsideDown
                    }
    }
    
    //Handles swipe DOWN
    func handleSwipeDown(swipe: UISwipeGestureRecognizer)
    {
        
        //If the game is over, restart the game
        if isGameOver
        {
            restart()
        }
        else
            if !isStarted
            {
                start()
            }
            else
                //If the ball is upside down and they swipe up, make the ball jump, and if not, make it just flip
                if isUpsideDown == true && noTaps == false
                {
                    person.jump()
                
                }
                else
                    if noTaps == false
                    {
                        person.flip()
                        isUpsideDown = !isUpsideDown
                    }
        
    }
    
    //When things contact eachother
    func didBegin(_ contact: SKPhysicsContact)
    {
        gameOver()
    }
    
    //Stops the game
    func gameOver()
    {
        let pointsLabel = childNode(withName: "pointsLabel") as? DCPoints
        pointsLabel?.fontColor = UIColor.black
        
       // let endWall = wallGenerator.wallTrackers[0] as DCWall
        
        person.loadEndAppearance()
        
        backgroundColor = UIColor.darkGray
        
       // endWall.color = UIColor.black
        
        noColorChange = true
        
        noTaps = true
        
        person.stop()
        
        person.physicsBody?.affectedByGravity = true
        
        person.bounceOff()
        
        wallGenerator.stopWalls()
        
        beamMoving.stop()
        
        //Sets a delay so the user will have to wait a second to tap the screen agin
        //This also avoids accidental taps after the user has lost the gmae
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute:
        {
            //Creates a game over label
            let gameOverLabel = SKLabelNode(text: "Game Over!")
            
            gameOverLabel.name = "gameOverLabel"
            gameOverLabel.position = CGPoint(x: (self.view?.frame.width)! / 2, y: self.view!.frame.height / 4 + 25)
            gameOverLabel.fontColor = SKColor(red: 242/255, green: 99/255, blue: 108/255, alpha: 1.0)
            gameOverLabel.fontName = "SanFrancisco-Bold"
            self.addChild(gameOverLabel)
            
            let playAgain = SKLabelNode(text: "Tap to play again")
            playAgain.name = "playAgain"
            playAgain.position = CGPoint(x: (self.view?.frame.width)! / 2, y: self.view!.frame.height / 4 - 25)
            playAgain.fontColor = SKColor(red: 242/255, green: 99/255, blue: 108/255, alpha: 1.0)
            playAgain.fontName = "SanFrancisco-Bold"
            self.addChild(playAgain)
            
            
            //Saves current points value
            let pointsLabel = self.childNode(withName: "pointsLabel") as! DCPoints
            let highScoreLabel = self.childNode(withName: "highScoreLabel") as! DCPoints
            let highScoreLabelText = self.childNode(withName: "highScoreLabelText")
            
            
            //Unhides the high score label from the user
            highScoreLabel.isHidden = false
            highScoreLabelText?.isHidden = false
            
            
            //If we have a new high score, save it
            if (highScoreLabel.points) < (pointsLabel.points)
            {
                highScoreLabel.saveHighScore(pts: (pointsLabel.points))
                
                let pts = pointsLabel.points
                
                self.saveHighScore(number: pts)
        
                
                //Saves the high score
                let saves = UserDefaults.standard
                saves.set(highScoreLabel.points, forKey: "highscore")
                
            }
            
            
            self.isGameOver = true
            self.noTaps = false
            
         
            
        })
        
       
    }
    
    
    //Restarts the game
    func restart()
    {
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .aspectFill
        
        view!.presentScene(newScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        
        // Called before each frame is rendered
        
       // let a = -frame.size.width / 2 + 69
        
        let a = frame.size.width / 2
        
        
        if wallGenerator.wallTrackers.count > 0
        {
        
        let wall = wallGenerator.wallTrackers[0] as DCWall
            
            
        let wallLocation = wall.position.x
            
        
        if (wallLocation <= a)
        {
            wallGenerator.wallTrackers.remove(at: 0)
            
            let pointsLabel = childNode(withName: "pointsLabel") as? DCPoints
            
            pointsLabel?.incriment()
            
            colorCounter = colorCounter + 1
                        
        }
            
            //Every 10 points, change the background color and the clor of the CURRENT BEAM
            if colorCounter == 110
            {
                colorCounter = 0
            }
            else
                if colorCounter >= 100 && noColorChange == false
                {
                    //Color is gold
                    self.backgroundColor = UIColor(hue: 0.0889, saturation: 0.15, brightness: 1, alpha: 1.0)
                    wall.color =  UIColor(hue: 0.0972, saturation: 0.58, brightness: 1, alpha: 1.0)
                }
                else
                    if colorCounter >= 90 && noColorChange == false
                    {
                        //Color is blue
                        self.backgroundColor = UIColor(hue: 0.6167, saturation: 0.15, brightness: 1, alpha: 1.0)
                        wall.color = UIColor(hue: 0.6167, saturation: 0.75, brightness: 1, alpha: 1.0)
                    }
                    else
                        if colorCounter >= 80 && noColorChange == false
                        {
                            //Color is green
                            self.backgroundColor = UIColor(hue: 0.3583, saturation: 0.15, brightness: 1, alpha: 1.0)
                            wall.color = UIColor(hue: 0.3583, saturation: 0.75, brightness: 1, alpha: 1.0)
                        }
                        else
                            if colorCounter >= 70 && noColorChange == false
                            {
                                let pointsLabel = childNode(withName: "pointsLabel") as? DCPoints
                                //Color is pink
                                self.backgroundColor = UIColor(hue: 0.825, saturation: 0.15, brightness: 1, alpha: 1.0)
                                wall.color = UIColor(hue: 0.825, saturation: 0.75, brightness: 1, alpha: 1.0)
                                pointsLabel?.fontColor = UIColor.black
                            }
                            else
                                if colorCounter >= 60 && noColorChange == false
                                {
                                    let pointsLabel = childNode(withName: "pointsLabel") as? DCPoints
                                    //Colors are inverses of originals
                                    self.backgroundColor = UIColor.black
                                    wall.color = UIColor.white
                                    pointsLabel?.fontColor = UIColor.white
                                }
                                else
                                    if colorCounter >= 50 && noColorChange == false
                                    {
                                        //Color is brown
                                        self.backgroundColor = UIColor(hue: 0.0667, saturation: 0.15, brightness: 0.54, alpha: 1.0)
                                        wall.color = UIColor(hue: 0.0667, saturation: 0.75, brightness: 0.54, alpha: 1.0)
                                    }
                                    else
                                        if colorCounter >= 40 && noColorChange == false
                                        {
                                            //Color is cyan
                                            self.backgroundColor = UIColor(hue: 0.5, saturation: 0.10, brightness: 1, alpha: 1.0)
                                            wall.color = UIColor(hue: 0.5, saturation: 0.85, brightness: 1, alpha: 1.0)
                                        
                                        }
                                        else
                                            if colorCounter >= 30 && noColorChange == false
                                            {
                                                //Color is orange
                                                self.backgroundColor = UIColor(hue: 0.0778, saturation: 0.25, brightness: 1, alpha: 1.0)
                                                wall.color = UIColor(hue: 0.0778, saturation: 1, brightness: 1, alpha: 1.0)
                                            }
                                            else
                                                if colorCounter >= 20 && noColorChange == false
                                                {
                                                    //Color is light red
                                                    self.backgroundColor = UIColor(hue: 0.0083, saturation: 0.15, brightness: 1, alpha: 1.0)
                                                    wall.color = UIColor(hue: 0.0083, saturation: 0.75, brightness: 1, alpha: 1.0)
                                                }
                                                else
                                                    if colorCounter >= 10 && noColorChange == false
                                                    {
                                                        //Color is pine green
                                                        self.backgroundColor = UIColor(hue: 0.4861, saturation: 0.15, brightness: 0.47, alpha: 1.0)
                                                        wall.color = UIColor(hue: 0.4861, saturation: 0.5, brightness: 0.75, alpha: 1.0)
                                                    }
                                                    else
                                                        if colorCounter >= 0 && noColorChange == false
                                                        {
                                                            self.backgroundColor = UIColor.white
                                                        }
            
        }
        
    }
}
