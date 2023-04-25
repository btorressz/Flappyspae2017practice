//
//  GameViewController.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/3/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}


class GameViewController: UIViewController {
    
    var bannerView = GADBannerView()

    override func viewDidLoad() {
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        

        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func didTapSNS(_ sender: UIButton) {
        
        let activityVC = shareText(text: "Share Text")
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func shareText(text: String) -> UIActivityViewController{
        
        let items = [text]
        let activityViewController = UIActivityViewController(activityItems: items,
                                                              applicationActivities: nil)
        
        let excludedActivityTypes = [
            UIActivityType.addToReadingList,
            UIActivityType.assignToContact,
            UIActivityType.airDrop,
            UIActivityType.print        ]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        return activityViewController
    }
    
    private func shareTextAndImage(text: String, image: UIImage) -> UIActivityViewController{
        
        let items = [text, image] as [Any]
        let activityViewController = UIActivityViewController(activityItems: items,
                                                              applicationActivities: nil)
        
        let excludedActivityTypes = [
            UIActivityType.addToReadingList,
            UIActivityType.assignToContact,
            UIActivityType.airDrop,
            UIActivityType.print
        ]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        return activityViewController
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
