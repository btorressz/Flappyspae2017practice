//
//  GameScene.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/3/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate,GKGameCenterControllerDelegate {

    var ship = Ship()
    var coin = Coin()
    var backgroundMusicPlayer = AVAudioPlayer()
    
    
    var obstacleHolder = SKNode()
    var scoreLabel = SKLabelNode()
    var score:Int = 0
    
    var gameStarted = false
    var isAlive = false
    var isGamePause = false
    let pauseButton = SKSpriteNode()
    var pauseScreen = SKShapeNode()
    
    var press = SKSpriteNode()
    
       override func didMove(to view: SKView) {
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        

        initialize()
        
        
        }
    
    // GAME CENTER FUNCTIONS
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func saveHighScore(_ identifier:String, score:Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: identifier)
            scoreReporter.value = Int64(score)
            let scoreArray:[GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: {
                error -> Void in
                if error != nil {
                    print("error")
                } else {
                    print("posted score of \(score)")
                }
            })
        }
    }
    
    
    func playBackgroundMusic(_ filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        if(url == nil)
        {
            print("Could not find file: \(filename)")
            return
        }//if
        
        
        do {
            try backgroundMusicPlayer = AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Could not create audio player")
        }//catch
        
        backgroundMusicPlayer.numberOfLoops = -1 //toSetInfiniteLoop
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isAlive {
            moveBackgroundsAndGrounds()
        }
        
        if isGamePause {
            pauseGame()
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            isAlive = true
            gameStarted = true
            press.removeFromParent()
            spawnObstacles()
            ship.physicsBody?.affectedByGravity = true
            ship.fly()
            
            if isAlive {
                ship.fly()
            }
            
            for touch in touches {
                let location = touch.location(in: self)
                
                if atPoint(location).name == "Retry" {
                    // restart the game
                    self.removeAllActions()
                    self.removeAllChildren()
                    initialize()
                }
                
                if atPoint(location).name == "Quit" {
                    let mainMenu = MenuScene(fileNamed: "MenuScene")
                    mainMenu?.scaleMode = .aspectFill
                    // presents mainmenu scene view controller
                    self.view?.presentScene(mainMenu!, transition: SKTransition.doorway(withDuration: 1))
                }
                

            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        // there is no way to determine that bodyA is always the ship - we have to do this if statement
        if contact.bodyA.node?.name == "Ship" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Ship" && secondBody.node?.name == "Score" {
            incrementScore()
        } else if firstBody.node?.name == "Ship" && secondBody.node?.name == "Obstacles" {
            
            if isAlive {
                shipOver()
            }
            } else if firstBody.node?.name == "ship" && secondBody.node?.name == "Ground" {

            if isAlive {
                shipOver()
            }
    }
    }
    
    func initialize() {
        
        gameStarted = false
        isAlive = false
        score = 0
        
        physicsWorld.contactDelegate = self
        
        createInstructions()
        createShips()
        getCoins()
        createBackgrounds()
        createGrounds()
        moveBackgroundsAndGrounds()
        createObstacles()
    }
    
    func createInstructions() {
        press = SKSpriteNode(imageNamed: "Press")
        press.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        press.position = CGPoint(x: 0, y: 0)
        press.setScale(1.8)
        press.zPosition = 10
        self.addChild(press)
    }
    
    func createShips() {
        ship = Ship(imageNamed: "\(GameManager.instance.getShip()) 1")
        ship.initialize()
        ship.position = CGPoint(x: -50, y: 0)
        self.addChild(ship)
    }
    func getCoins() {
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
        physicsWorld.contactDelegate = self
        
        ship = SKSpriteNode(imageNamed: "ship") as! Ship
        ship.zPosition = 1
        ship.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width / 5.12)
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.allowsRotation = false
        self.addChild(ship)
        
        coin = SKSpriteNode( imageNamed: "coin") as! Coin
        coin.physicsBody? = SKPhysicsBody(circleOfRadius: coin.size.height / 10)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.allowsRotation = false
        coin.zPosition = 1
        self.addChild(coin)
        
        if(self.action(forKey: "spawning") != nil){return}
        
        let action = SKAction.wait(forDuration: 7, withRange: 2)
        let spawnCoin = SKAction.run {
            
            self.coin = SKSpriteNode( imageNamed: "coin") as! Coin
            self.coin.physicsBody = SKPhysicsBody(circleOfRadius: self.coin.size.height / 10)
            self.coin.name = "coin"
            self.coin.physicsBody?.isDynamic = false
            self.coin.physicsBody?.allowsRotation = false
            
            var coinPosition = Array<CGPoint>()
            
            coinPosition.append((CGPoint(x:340, y:103)))
            coinPosition.append((CGPoint(x:340, y:148)))
            coinPosition.append((CGPoint(x:340, y:218)))
            coinPosition.append((CGPoint(x: 340, y:343)))
            
            let spawnLocation =     coinPosition[Int(arc4random_uniform(UInt32(coinPosition.count)))]
            let action = SKAction.repeatForever(SKAction.moveTo(x: +self.xScale, duration: 4.4))
            
            self.coin.run(action)
            self.coin.position = spawnLocation
            self.addChild(self.coin)
            
            print(spawnLocation)
            
        }
    }
    func createBackgrounds() {
        // loop 3 times
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day")
            bg.name = "BG"
            bg.zPosition = 0
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // this moves the screen across from the x position which is the changing position.
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            self.addChild(bg)
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.zPosition = 4
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // this puts the ground at the middle, then the minus will put it at the bottom
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            // be aware that if this has a "?" after physicsBody then it won't work!!!!!
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.affectedByGravity = false
            // makes the ground static so other phsyicsbodys cant move it
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
            
            //  Dont need this here because its already in the bird.swift file
            //  ground.physicsBody?.collisionBitMask = ColliderType.Bird
            //  ground.physicsBody?.contactTestBitMask = ColliderType.Bird
            self.addChild(ground)
        }
        
    }
    
    func moveBackgroundsAndGrounds() {
        // moves bground
        enumerateChildNodes(withName: "BG", using: ({
            (node, error) in
            // code here will be executed for children specified in withName
            
            // this will move every node 4.5 to the left side
            node.position.x -= 4.5
            
            if node.position.x < -(self.frame.width) {
                // times by 3 because there are 3 backgrounds in the gameplayscene.sks
                node.position.x += self.frame.width * 3
            }
            
        }))
        
        // moves ground
        enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            // code here will be executed for children specified in withName
            
            // this will move every node 2.5 to the left side
            node.position.x -= 2
            
            if node.position.x < -(self.frame.width) {
                // times by 3 because there are 3 backgrounds in the gameplayscene.sks
                node.position.x += self.frame.width * 3
            }
            
        }))
    }
    
    func createObstacles() {
        obstacleHolder = SKNode()
        obstacleHolder.name = "Holder"
        
        let pipeUp = SKSpriteNode(imageNamed: "Pipe 1")
        let pipeDown = SKSpriteNode(imageNamed: "Pipe 1")
        
        let scoreNode = SKSpriteNode()
        
        pipeUp.name = "Pipe"
        pipeUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeUp.position = CGPoint(x: 0, y: 630)
        pipeUp.yScale = 1.5
        // this rotates the sprite 180 degrees
        pipeUp.zRotation = CGFloat(Double.pi)
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.categoryBitMask = ColliderType.Obstacles
        pipeUp.physicsBody?.affectedByGravity = false
        // makes pipe static
        pipeUp.physicsBody?.isDynamic = false
        
        pipeDown.name = "Pipe"
        pipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeDown.position = CGPoint(x: 0, y: -630)
        pipeDown.yScale = 1.5
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeDown.physicsBody?.categoryBitMask = ColliderType.Obstacles
        pipeDown.physicsBody?.affectedByGravity = false
        // makes pipe static
        pipeDown.physicsBody?.isDynamic = false
        
        
        obstacleHolder.zPosition = 5
        obstacleHolder.position.x = self.frame.width + 100
        obstacleHolder.position.y = CGFloat.randomBetweenNumbers(firstNum: -300, secondNum: 300)
        
        obstacleHolder.addChild(pipeUp)
        obstacleHolder.addChild(pipeDown)
        obstacleHolder.addChild(scoreNode)
        
        // delete when the game is ready
        scoreNode.color = SKColor.red
        
        scoreNode.name = "Score"
        scoreNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scoreNode.position = CGPoint(x: 0, y: 0)
        scoreNode.size = CGSize(width: 5, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false

    }
    
    func spawnObstacles() {
        
        // this blocky
        let spawn = SKAction.run({ () -> Void in
            self.createObstacles()
        })
        
        // will spawn the pipes every 2 seconds
        let delay = SKAction.wait(forDuration: TimeInterval(2))
        let sequence = SKAction.sequence([spawn, delay])
        
        self.run(SKAction.repeatForever(sequence), withKey: "Spawn")
        
        
    }
    
    func createLabel() {
        scoreLabel.zPosition = 6
        scoreLabel.position = CGPoint(x: 0, y: 450)
        scoreLabel.fontSize = 120
        scoreLabel.text = "0"
        self.addChild(scoreLabel)
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    func shipOver() {
        // stops spawning
        self.removeAction(forKey: "Spawn")
        
        for child in children {
            if child.name == "Holder" {
                child.removeAction(forKey: "Move")
            }
    }
        
        isAlive = false
        
        let highscore = GameManager.instance.getHighScore()
        if highscore < score {
            // if current score is greater than the saved highscore then we have a new highscore
            GameManager.instance.setHighScore(highScore: score)
            
            let retry = SKSpriteNode(imageNamed: "Retry")
            let quit = SKSpriteNode(imageNamed: "Quit")
            
            retry.name = "Retry"
            retry.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            retry.position = CGPoint(x: -150, y: -150)
            retry.zPosition = 7
            retry.setScale(0)
            
            quit.name = "Quit"
            quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            quit.position = CGPoint(x: 150, y: -150)
            quit.zPosition = 7
            quit.setScale(0)
            
            let scaleUp = SKAction.scale(to: 1, duration: (0.5))
            retry.run(scaleUp)
            quit.run(scaleUp)
            
            self.addChild(retry)
            self.addChild(quit)
            
        }
    

    
}
    
    func pauseGame() {
        
        pauseScreen = SKShapeNode(rectOf: CGSize(width: self.size.width * 2, height: self.size.height * 2))
        pauseScreen.fillColor = SKColor (red: 0, green: 0, blue: 0, alpha: 0.5)
        pauseScreen.name = "pauseS"
        let pauseLabel = SKLabelNode(fontNamed: "Futura")
        pauseLabel.fontSize = 50
        pauseLabel.fontColor = UIColor(red: 0.9373, green: 0.2392, blue: 0.2902, alpha: 1.0)
        pauseLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150)
        pauseLabel.text = "PAUSED"
        let resumeLabel = SKLabelNode(fontNamed: "Futura")
        resumeLabel.fontSize = 30
        resumeLabel.fontColor = UIColor(white: 1, alpha: 1)
        resumeLabel.position = CGPoint(x: self.size.width / 2, y: 150)
        resumeLabel.text = "resume"
        resumeLabel.name = "resume"
        pauseScreen.addChild(pauseLabel)
        pauseScreen.addChild(resumeLabel)
        

        NotificationCenter.default.addObserver(self, selector: Selector(("pauseScene")),name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        let delay = SKAction.wait(forDuration: 0.5)
        let block = SKAction.run({
            self.view!.isPaused = true
            
        })
        
        let sequence = SKAction.sequence([delay, block])
        self.run(sequence)
        
    }
    
    func unpause() {
        let resumeLabel = SKLabelNode(fontNamed: "Futura")
        resumeLabel.fontSize = 30
        resumeLabel.fontColor = UIColor(white: 1, alpha: 1)
        resumeLabel.position = CGPoint(x: self.size.width / 2, y: 150)
        resumeLabel.text = "resume"
        resumeLabel.name = "resume"
        pauseScreen.addChild(resumeLabel)
        
        self.view!.isPaused = false
        
    }
    
    func gameOverTheme() {
        let popUpWindow = SKShapeNode(rect: CGRect(x: size.width / 4, y: size.height / 4 , width: size.width / 2, height: size.height / 2), cornerRadius: 15)
        popUpWindow.fillColor = UIColor.white
        
        
        let restartButton = SKSpriteNode(imageNamed: "restartButton")
        restartButton.position  = CGPoint(x:frame.size.width / 2, y:frame.size.height * (6/16))
        
        let popUpScoreLabel = SKLabelNode(text: "Score:")
        let popUPScoreNumLabel = SKLabelNode(text: "\(score)")
        
        let shareButton = SKSpriteNode()
        
        popUpScoreLabel.position = CGPoint(x:frame.size.width / 2 , y:10 * (frame.size.height / 16))
        popUPScoreNumLabel.position = CGPoint(x:frame.size.width / 2 , y:8.8 * (frame.size.height / 16))
        popUpScoreLabel.fontColor = UIColor.black
        popUPScoreNumLabel.fontColor = UIColor.black
        popUPScoreNumLabel.fontSize = 45
        popUPScoreNumLabel.fontName = "Arial-Bold"
        
        shareButton.position = CGPoint(x:frame.size.width / 2 , y:10 * (frame.size.height / 16))
        
        let textToShare = "I just did \(scoreLabel) on the game! Try to beat me, it's free!"
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.print]

        
        let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
        
        currentViewController.present(activityVC, animated: true, completion: nil)
        
        
        addChild(popUpWindow)
        addChild(popUpScoreLabel)
        addChild(popUPScoreNumLabel)
        addChild(restartButton)
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

    
    


}
