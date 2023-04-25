//
//  Ship.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/3/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit

struct ColliderType {
    static let Shipp: UInt32 = 1
    static let Ground: UInt32 = 2
    static let Obstacles:UInt32 = 3
    static let Score:UInt32 = 4
}
class Ship: SKSpriteNode {

    var shipAnimation = [SKTexture]()
    var shipAnimationAction = SKAction()
    
    var overTexture = SKTexture()
    
    func initialize() {
        for i in 2..<4 {
            let name = "\(GameManager.instance.getShip()) \(i)"

            shipAnimation.append(SKTexture(imageNamed: name))

        }
        shipAnimationAction = SKAction.animate(with: shipAnimation, timePerFrame: 0.08, resize: true, restore: true)

        overTexture = SKTexture(imageNamed: "\(GameManager.instance.getShip()) 4")
        self.name = "Bird"
        self.zPosition = 3
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderType.Shipp
        self.physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Obstacles
        self.physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Obstacles | ColliderType.Score
    }
    
    func fly() {
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
        self.run(shipAnimationAction)
    }
    
}
