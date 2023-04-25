//
//  SelectLevelScene.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/20/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit


class LevelSelectScene: SKScene {
    
    var level1:SKSpriteNode! = nil
    var level2:SKSpriteNode! = nil
    var level3:SKSpriteNode! = nil
    
    //level icons
    let level1Texture = SKTexture(imageNamed: "level1_01")
    let level2Texture = SKTexture(imageNamed: "level2_01")
    let level3Texture = SKTexture(imageNamed: "level3_01")
    let level1PressedTexture = SKTexture(imageNamed: "level1_02")
    let level2PressedTexture = SKTexture(imageNamed: "level2_02")
    let level3PressedTexture = SKTexture(imageNamed: "level3_02")
    let level2LockedTexture = SKTexture(imageNamed: "level2_lock")
    let level3LockedTexture = SKTexture(imageNamed: "level3_lock")
    
    var selectedBtn : SKSpriteNode?
    
    var level2IsLocked = true
    var level3IsLocked = true
    
    private let background = SKSpriteNode(imageNamed:"level_background")
    
    //return Btn to Initial Scene
    private var returnBtn: SKSpriteNode!
    private let returnBtnTexture = SKTexture(imageNamed: "level_return01")
    private let returnBtnPressedTexture = SKTexture(imageNamed:"level_return02")
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        //Setup background
        background.position = CGPoint(x: size.width/2,y:size.height/2)
        background.zPosition = -1
        addChild(background)
        
        //Setup level icons
        level1  = SKSpriteNode(texture: level1Texture)
        level1.size = CGSize(width:60,height:60)
        level1.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2 - 20)
        addChild(level1)
        
        if(level2IsLocked){
            level2 = SKSpriteNode(texture: level2LockedTexture)
        } else {
            level2 = SKSpriteNode(texture:level2Texture)
        }
        level2.size = CGSize(width: 60, height: 60)
        level2.position = CGPoint(x:size.width/2,y: size.height/2 - 20)
        addChild(level2)
        
        if(level3IsLocked){
            level3 = SKSpriteNode(texture: level3LockedTexture)
        } else {
            level3 = SKSpriteNode(texture:level3Texture)
        }
        level3.size = CGSize(width: 60, height: 60)
        level3.position = CGPoint(x:size.width/2 + 200 ,y: size.height/2 - 20)
        addChild(level3)
        
        returnBtn = SKSpriteNode(texture: returnBtnTexture)
        returnBtn.size = CGSize(width:40,height:40)
        returnBtn.position = CGPoint( x:40, y: size.height-40)
        addChild(returnBtn)
        
    }
    
    // Touch solution
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedBtn != nil {
                handlereturnBtnHover(isHovering: false)
                handlelevel1Hover(isHovering: false)
                handlelevel2Hover(isHovering: false)
            }
            
            if level1.contains(touch.location(in: self)) {
                selectedBtn = level1
                handlelevel1Hover(isHovering: true)
            } else if level2.contains(touch.location(in: self)) && !level2IsLocked {
                selectedBtn = level2
                handlelevel2Hover(isHovering: true)
            } else if returnBtn.contains(touch.location(in: self)) {
                selectedBtn = returnBtn
                handlereturnBtnHover(isHovering: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if selectedBtn == level1 {
                handlelevel1Hover(isHovering: (level1.contains(touch.location(in: self))))
            } else if selectedBtn == level2 {
                handlelevel2Hover(isHovering: (level2.contains(touch.location(in: self))))
            } else if selectedBtn == returnBtn {
                handlereturnBtnHover(isHovering: (returnBtn.contains(touch.location(in: self))))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if selectedBtn == level1 {
                handlelevel1Hover(isHovering: false)
                
                if (level1.contains(touch.location(in: self))) {
                    handlelevel1Click()
                }
                
            } else if selectedBtn == level2 {
                handlelevel2Hover(isHovering: false)
                
                if (level2.contains(touch.location(in: self))) {
                    handlelevel2Click()
                }
            } else if selectedBtn == returnBtn {
                handlereturnBtnHover(isHovering: false)
                
                if (returnBtn.contains(touch.location(in: self))) {
                    handlereturnBtnClick()
                }
            }
        }
        
        selectedBtn = nil
    }
    
    func handlelevel1Hover(isHovering : Bool) {
        if isHovering {
            level1.texture = level1PressedTexture
        } else {
            level1.texture = level1Texture
        }
    }
    
    func handlelevel2Hover(isHovering : Bool) {
        if isHovering {
            level2.texture = level2PressedTexture
        } else {
            level2.texture = level2Texture
        }
    }
    
    func handlereturnBtnHover (isHovering : Bool) {
        if isHovering {
            returnBtn.texture = returnBtnPressedTexture
        } else {
            returnBtn.texture = returnBtnTexture
        }
        
    }
    
    func handlelevel1Click() {
        let transition = SKTransition.fade(with: .black,duration: 0.3)
        
        /// transitate to levelScene
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view!
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: transition)
            
        }
    }
    
    //return to Initial Scene
    func handlereturnBtnClick() {
        
        let transition = SKTransition.reveal(with: .right, duration: 0.3)
        let menuScene = MenuScene(size:size)
        menuScene.scaleMode = .aspectFill
        self.view?.presentScene(menuScene, transition: transition)
        
    }
    
    func handlelevel2Click() {
        //        if SoundManager.sharedInstance.toggleMute() {
        //            //Is muted
        //            level2.texture = level2TextureOff
        //        } else {
        //            //Is not muted
        //            level2.texture = level2Texture
        //        }
    }
    
    
    
    
}
