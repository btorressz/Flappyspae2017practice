//
//  SelectShipScene.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/18/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit

/*
 
 Source Code:
 ////https://github.com/burczyk/SwiftTeamSelect/blob/master/SwiftTeamSelect/GameScene.swift
 
 */

class SelectShipScene: SKScene {

    enum Zone {
        case Left, Center, Right
    }
    
    var players = [SKSpriteNode]()
    
    var leftPlayer = SKSpriteNode()
    var centerPlayer = SKSpriteNode()
    var rightPlayer = SKSpriteNode()
    var isPlayerUnlocked:Bool = false
    var price: String = "0.99"
    
    
    var leftGuide : CGFloat {
        return round(view!.bounds.width / 6.0)
    }
    
    var rightGuide : CGFloat {
        return view!.bounds.width - leftGuide
    }
    
    var gap : CGFloat {
        return (size.width / 2 - leftGuide) / 2
    }
    
    
    // Initialization
    
    override init( size: CGSize) {
        super.init(size:size)
        createPlayers()
        centerPlayer = players[players.count/2]
        setLeftAndRightPlayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        placePlayersOnPositions()
        calculateZIndexesForPlayers()
    }
    
    func createPlayers() {
        let flatUIColors = UIColor.clear
        
        for i in 0..<9 {
            let player = SKSpriteNode(color: flatUIColors, size: CGSize(width:100, height:200))
            players.append(player)
        }
    }
    
    func placePlayersOnPositions() {
        for i in 0..<players.count/2 {
            players[i].position = CGPoint(x:leftGuide, y:size.height/2)
        }
        
        players[players.count/2].position = CGPoint(x:size.width/2, y:size.height/2)
        
        for i in players.count/2 + 1..<players.count {
            players[i].position = CGPoint(x:rightGuide, y:size.height/2)
        }
        
        for player in players {
            player.setScale(calculateScaleForX(x: player.position.x))
            self.addChild(player)
        }
        
    }
    
    
    // Helper functions
    
    func calculateScaleForX(x:CGFloat) -> CGFloat {
        let minScale = CGFloat(0.5)
        
        if x <= leftGuide || x >= rightGuide {
            return minScale
        }
        
        if x < size.width/2 {
            let a = 1.0 / (size.width - 2 * leftGuide)
            let b = 0.5 - a * leftGuide
            
            return (a * x + b)
        }
        
        let a = 1.0 / (frame.size.width - 2 * rightGuide)
        let b = 0.5 - a * rightGuide
        
        return (a * x + b)
    }
    
    func calculateZIndexesForPlayers() {
        var playerCenterIndex : Int = players.count / 2
        
        for i in 0..<players.count {
            if centerPlayer == players[i] {
                playerCenterIndex = i
            }
        }
        
        for i in 0...playerCenterIndex {
            players[i].zPosition = CGFloat(i)
        }
        
        for i in playerCenterIndex+1..<players.count {
            players[i].zPosition = centerPlayer.zPosition * 2 - CGFloat(i)
        }
        
    }
    
    func movePlayerToX(player: SKSpriteNode, x: CGFloat, duration: TimeInterval) {
        let moveAction = SKAction.moveTo(x: x, duration: duration)
        let scaleAction = SKAction.scale(to: calculateScaleForX(x: x), duration: duration)
        
        player.run(SKAction.group([moveAction, scaleAction]))
    }
    
    func movePlayerByX(player: SKSpriteNode, x: CGFloat) {
        let duration = 0.01
        
        if player.frame.midX <= rightGuide && player.frame.midX >= leftGuide {
            player.run(SKAction.moveBy(x: x, y: 0, duration: duration), completion: {
                player.setScale(self.calculateScaleForX(x: player.frame.midX))
            })
            
            if player.frame.midX < leftGuide {
                player.position = CGPoint(x:leftGuide, y:player.position.y)
            } else if player.frame.midX > rightGuide {
                player.position = CGPoint(x:rightGuide, y:player.position.y)
            }
        }
    }
    
    func zoneOfCenterPlayer() -> Zone {
        let gap = size.width / 2 - leftGuide
        
        switch centerPlayer.frame.midX {
            
        case let x where x < leftGuide + gap/2:
            return .Left
            
        case let x where x > rightGuide - gap/2:
            return .Right
            
        default: return .Center
            
        }
    }
    
    func setLeftAndRightPlayers() {
        var playerCenterIndex : Int = players.count / 2
        
        for i in 0..<players.count {
            if centerPlayer == players[i] {
                playerCenterIndex = i
            }
        }
        
        if playerCenterIndex > 0 && playerCenterIndex < players.count {
            leftPlayer = players[playerCenterIndex-1]
        } else {
            leftPlayer == nil
        }
        
        if playerCenterIndex > -1 && playerCenterIndex < players.count-1 {
            rightPlayer = players[playerCenterIndex+1]
        } else {
            rightPlayer == nil
        }
    }
    
    
    
    // Touch interactions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            //        let touch = touches.anyObject() as UITouch

//        let node = self.nodeAtPoint(locationInNode(self))
          
         //   var node = touch.location(in: self)
            
           // let node = self.location(in:self)
            
       //     let node = self.nodes(at:touch.location(in:self))
            
            let node = self.nodes(at:self.position)

        if node == [centerPlayer] {
            let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.15)
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.15)
            
            self.centerPlayer.run(fadeOut, completion: { self.centerPlayer.run(fadeIn) })
        }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let duration = 0.01
       let touch = touches as AnyObject
       // let touch = touches as AnyObject?
        let newPosition = touch.location(in:self)
        let oldPosition = touch.previousLocation(in:self)
         let xTranslation = newPosition.x - oldPosition.x
        
        if centerPlayer.frame.midX > size.width/2 {
            if (leftPlayer != nil) {
                let actualTranslation = leftPlayer.frame.midX + xTranslation > leftGuide ? xTranslation : leftGuide - leftPlayer.frame.midX
                movePlayerByX(player: leftPlayer, x: actualTranslation)
            }
        } else {
            if (rightPlayer != nil) {
                let actualTranslation = rightPlayer.frame.midX + xTranslation < rightGuide ? xTranslation : rightGuide - rightPlayer.frame.midX
                movePlayerByX(player: rightPlayer, x: actualTranslation)
            }
        }
        
        movePlayerByX(player: centerPlayer, x: xTranslation)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches as AnyObject?
        let duration = 0.25
        
        switch zoneOfCenterPlayer() {
            
        case .Left:
            if (rightPlayer != nil) {
                movePlayerToX(player: centerPlayer, x: leftGuide, duration: duration)
                // movePlayerToX(rightPlayer: centerPlayer!, x: leftGuide, duration: duration)
                if (leftPlayer != nil) {
                    movePlayerToX(player: leftPlayer, x: leftGuide, duration: duration)
                }
                if (rightPlayer != nil) {
                    movePlayerToX(player: rightPlayer, x: size.width/2, duration: duration)
                }
                
                centerPlayer = rightPlayer
                setLeftAndRightPlayers()
            } else {
                movePlayerToX(player: centerPlayer, x: size.width/2, duration: duration)
            }
            
        case .Right:
            if (leftPlayer != nil) {
                movePlayerToX(player: centerPlayer, x: rightGuide, duration: duration)
                if (rightPlayer != nil) {
                    movePlayerToX(player: rightPlayer, x: rightGuide, duration: duration)
                }
                if (leftPlayer != nil) {
                    movePlayerToX(player: leftPlayer, x: size.width/2, duration: duration)
                }
                
                centerPlayer = leftPlayer
                setLeftAndRightPlayers()
            } else {
                movePlayerToX(player: centerPlayer, x: size.width/2, duration: duration)
            }
            
        case .Center:
            movePlayerToX(player: centerPlayer, x: size.width/2, duration: duration)
            if (leftPlayer != nil) {
                movePlayerToX(player: leftPlayer, x: leftGuide, duration: duration)
            }
            if (rightPlayer != nil) {
                movePlayerToX(player: rightPlayer, x: rightGuide, duration: duration)
            }
        }
        
        calculateZIndexesForPlayers()
    }
    
}
