//
//  GameScene.swift
//  Snake
//
//  Created by Tim Nimets on 2020-01-19.
//  Copyright © 2020 Tim Nimets. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Declare content
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    
    var game: GameManager!
    
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
            }
        }
    }
    
    private func startGame() {
        print("start game")
    }
    
    private func initializeMenu() {
        // Create game title
        gameLogo = SKLabelNode(fontNamed: "ArialROundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "SNAKE"
        gameLogo.fontColor = SKColor.red
        self.addChild(gameLogo)
        
        // Create best score
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x:0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: 0"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        
        // Create plat button
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
    }
}
