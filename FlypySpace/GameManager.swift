//
//  GameManager.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/3/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import Foundation


class GameManager {
    
    static let instance = GameManager()
    
    private init() {}
        var shipIndex = Int(0)
        var ships = ["regular", "curved", "big"]
    
    
        func incrementIndex() {
            shipIndex += 1
            
            if shipIndex == ships.count {
                shipIndex = 0
            }
        }
    
    func getShip() -> String {
        return ships[shipIndex]
    }
    
    func setHighScore(highScore:Int) {
        UserDefaults.standard.set(highScore, forKey: "Highscore")

    }
    
    func getHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: "Highscore")

    }
    
      

    
    
}
