//
//  MenuScene.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/3/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit
import GameKit
import Social

class MenuScene: SKScene, GKGameCenterControllerDelegate {
    
    // VARIABLES
   // var activityInd = UIActivityIndicatorView()
    var playBtn = SKSpriteNode()
    var scoreBtn = SKSpriteNode()
    var title = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var tutorialButton = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        let textToShare = "I just did \(scoreLabel) on the game! Try to beat me, it's free!"
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        
        let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
        
        currentViewController.present(activityVC, animated: true, completion: nil)
        
      /*  activityInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityInd.center = CGPoint(x:self.frame.midX, y:self.frame.midY)
        activityInd.startAnimating()
        scene!.view?.addSubview(self.activityInd)
        DispatchQueue.main.async() { () -> Void in
            self.activityInd.stopAnimating()}*/
        
        initialize()
        self.authenticateLocalPlayer()
    }
    
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController, error ) -> Void in
            if (viewController != nil ) {
                let vc:UIViewController = self.view!.window!.rootViewController!
                vc.present(viewController!, animated: true, completion: nil)
            } else {
                print("Authentication is \(GKLocalPlayer.localPlayer().isAuthenticated)")
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackgroundsAndGrounds()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // presents the game when the play button is touched
        
        let url = ""
        //let activityController = UIActivityViewController()
        
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location) == playBtn {
                let scene = GameScene(fileNamed: "GameScene")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorway(withDuration: TimeInterval(1.5)))
            }
            
            if atPoint(location) == scoreBtn {
                // shows the highscore
                showScore()
                
            }
            
            if tutorialButton.contains(location) {
                
                let transition = SKTransition.doorway(withDuration: 0.7)
                let Tutorial = TutorialScene(size:self.size)
                Tutorial.setScale(CGFloat(scaleMode.rawValue))
                Tutorial.scaleMode = self.scaleMode
                self.view?.presentScene(Tutorial,transition:transition)
            }

        }
    }
    
    func initialize() {
        createBg()
        createGrounds()
        getButtons()
        getLabel()
    }
    
    func createBg() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG")
            bg.name = "BG"
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //  allows all backgrounds to come after the other on the horizontal scale
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            bg.zPosition = 0
            
            self.addChild(bg)
            
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //  allows all backgrounds to come after the other on the horizontal scale
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            ground.zPosition = 3
            
            
            self.addChild(ground)
            
        }
    }
    
    func moveBackgroundsAndGrounds() {
        enumerateChildNodes(withName: "BG", using: ({
            (node, error) in
            
            // can add this instead of doing "node" below
            // let bgNode = node as! SKSpriteNode
            
            // any code we put here will be executed for the specific child "BG"
            node.position.x -= 4
            
            // pushes background off screen then adds it to the end again
            if node.position.x < -(self.frame.width) {
                node.position.x += self.frame.width * 3
            }
            
            
        }))
        
        enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            
            
            // any code we put here will be executed for the specific child "BG"
            node.position.x -= 2
            
            // pushes background off screen then adds it to the end again
            if node.position.x < -(self.frame.width) {
                node.position.x += self.frame.width * 3
            }
            
            
        }))
        
    }
    
    func getButtons() {
        playBtn = self.childNode(withName: "Play") as! SKSpriteNode
        scoreBtn = self.childNode(withName: "Score") as! SKSpriteNode
    }
    
    func getLabel() {
        title = self.childNode(withName: "Title") as! SKLabelNode
        
        title.fontName = "RosewoodStd-Regular"
        title.fontSize = 120
        title.text = ""
        title.zPosition = 5
        
        let moveUp = SKAction.moveTo(y: title.position.y + 50, duration: TimeInterval(1.3))
        let moveDown = SKAction.moveTo(y: title.position.y - 50, duration: TimeInterval(1.3))
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        title.run(SKAction.repeatForever(sequence))
    }
    
    func shareToFacebook() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            //    self.present(fbShare, animated:true, completion:nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "log into facebook", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            //    self.presentViewController(alert, animated:true, completion:nil)
        }
    }
    
    func shareToTwitter() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            var tweet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            //  self.present(tweet, animated:true, completion:nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "log into facebook", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // self.present(tweet, animated:true, completion:nil)
            
        }
    }

    
    func showScore() {
        scoreLabel.removeFromParent()
        scoreLabel = SKLabelNode(fontNamed: "RosewoodStd-Regular")
        scoreLabel.fontSize = 180
        // gets the score
        scoreLabel.text = "\(UserDefaults.standard.integer(forKey: "Highscore"))"
        scoreLabel.position = CGPoint(x: 0, y: -200)
        scoreLabel.zPosition = 9
        self.addChild(scoreLabel)
    }
    
    
    func saveHighscore(number : Int){
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "MonkeyBall")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
            
        }
        
        
    }
    
    
    //MARK: Game Center stuff
    
    
    func showLeaderBoard(){
        let viewController = self.view!.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    
    
    func showGameCenter() {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.present(gameCenterViewController, animated: true, completion: nil)
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
}
