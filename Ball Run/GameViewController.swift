//
//  GameViewController.swift
//  Ball Run
//
//  Created by Daniel Cutaneo on 10/1/16.
//  Copyright © 2016 DBit. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate
{
    //Sets up advertisements
    @IBOutlet weak var bannerView: GADBannerView!
    
    var scene: GameScene!
    var beamMoving: DCBeamMoving!
    var person: DCBall!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Authorizes GC player
        authPlayer()
        
        //Configures User's View to Fill Screen
        let skView = self.view as! SKView
        
        skView.isMultipleTouchEnabled = true
        
        scene = GameScene(size: skView.bounds.size)
      
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
    

        //Gets banner ID for AdMob
        self.bannerView.adUnitID = "ca-app-pub-2344498955657062/9857541836"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
    }
    
    @IBAction func newCallGC(_ sender: Any) {
        showLeaderboard()
    }

    
    func authPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, Error) in
            
            if view != nil
            {
                self.present(view!, animated: true, completion: nil)
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
    
    func showLeaderboard()
    {
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool
    {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
    
}
