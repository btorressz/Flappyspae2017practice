//
//  TutorialScene.swift
//  FlypySpace
//
//  Created by Brandon Torres on 6/8/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit 
class TutorialScene: SKScene {
    var tutorialBTN = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        tutorialBTN = SKSpriteNode(imageNamed: "Tutorial")
        tutorialBTN.size = CGSize(width:self.frame.width, height:self.frame.height)
        tutorialBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        tutorialBTN.zPosition = 7
        tutorialBTN.setScale(0)
        tutorialBTN.color = UIColor.white
        self.addChild(tutorialBTN)
        tutorialBTN.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            
            
            if tutorialBTN.contains(location){
                
                let menuScene = MenuScene(size: self.size)
                menuScene.scaleMode = self.scaleMode
                
                self.view?.presentScene(menuScene)
                
            }
            
            
            
            
        }
        
        
    }

}
