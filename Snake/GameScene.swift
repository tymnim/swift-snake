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
    
    var currentScore: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var gameBackground: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager(scene: self, frame: frame)
        initializeGameView()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        game.update(time: currentTime)
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
        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.gameLogo.isHidden = true
        }
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBackground.setScale(0)
            self.gameBackground.isHidden = false
            self.gameBackground.run(SKAction.scale(to: 1, duration: 0.4))

            self.currentScore.setScale(0)
            self.currentScore.isHidden = false
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            
            self.game.initGame()
        }
    }
    
    private func initializeMenu() {
        // Creates game title
        gameLogo = SKLabelNode(fontNamed: "ArialROundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "SNAKE"
        gameLogo.fontColor = SKColor.red
        self.addChild(gameLogo)
        
        // Creates best score
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x:0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: 0"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        
        // Creates plat button
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
    
    private func initializeGameView() {
        currentScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        self.addChild(currentScore)
        
        let numCols = 20
        let width = frame.size.width - 100
        let cellWidth = width / CGFloat(numCols)
        let aproximateHeight = frame.size.height - 200
        let numRows = Int(aproximateHeight / cellWidth)
        let height = cellWidth * CGFloat(numRows)
        
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBackground = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBackground.fillColor = SKColor.darkGray
        gameBackground.zPosition = 2
        gameBackground.isHidden = true
        self.addChild(gameBackground)
        
        createGameBoard(width: width, height: height, cellWidth: cellWidth, numRows: numRows, numCols: numCols)
    }
    
    public func createGameBoard(width: CGFloat, height: CGFloat,
                                cellWidth: CGFloat,
                                numRows: Int, numCols: Int) {
        // Creates a game board, initialize array of cells
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        // creates cells
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                
                gameArray.append((node: cellNode, x: i, y: j))
                gameBackground.addChild(cellNode)
                
                x += cellWidth
            }
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
}
