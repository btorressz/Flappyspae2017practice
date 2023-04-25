//
//  Coin.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/4/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit

class Coin: SKSpriteNode {
    var coinnimation = [SKTexture]()
    var coinAnimationAction = SKAction()
    var coin = SKSpriteNode()
    var initialSize = CGSize(width: 25, height: 25)
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "")
    var value:Int = 1
    
    init() {
        let yellowTexture = textureAtlas.textureNamed("")
        super.init(texture:yellowTexture, color: .clear, size:initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.affectedByGravity = false
    }
    
    func bigCoin() {
        self.texture =
            textureAtlas.textureNamed("")
        self.value = 5
    }
    
    func Tap(){}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
