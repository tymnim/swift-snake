//
//  GameManager.swift
//  Snake
//
//  Created by Tim Nimets on 2020-01-19.
//  Copyright © 2020 Tim Nimets. All rights reserved.
//

import SpriteKit

class GameManager {
    
    var scene: GameScene!
    var frame: CGRect!
    
    var nextTime: Double?
    var timeExtension: Double = 0.15

    let numCols = 20
    var numRows: Int!
    
    enum States {
        case up, right, down, left, dead
    }
    
    var playerDirection = States.up
    
    var currentScore: Int = 0
    
    init(scene: GameScene, frame: CGRect) {
        self.scene = scene
        self.frame = frame
    }
    
    // init game view and player
    func initGame() {
        numRows = Int((frame.size.height - 200) / ((frame.size.width - 100) / CGFloat(numCols)))
        scene.playerPositions.append((10, 10))
        scene.playerPositions.append((10, 11))
        scene.playerPositions.append((10, 12))
        renderChange()
        generateNewPoint()
    }
    
    // called every frame
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else {
            if time >= nextTime! {
                nextTime = time + timeExtension
                updatePlayerPosition()
                checkForScore()
                checkForDeath()
            }
        }
    }
    
    private func checkForScore() {
        if scene.scorePos != nil {
            let x = scene.playerPositions[0].0
            let y = scene.playerPositions[0].1
            if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                currentScore += 1
                scene.currentScore.text = "Score: \(currentScore)"
                generateNewPoint()
                scene.playerPositions.append(scene.playerPositions.last!)
                scene.playerPositions.append(scene.playerPositions.last!)
                scene.playerPositions.append(scene.playerPositions.last!)
            }
        }
    }
    
    private func checkForDeath() {
        if scene.playerPositions.count > 0 {
            var arrayOfPossitions = scene.playerPositions
            let headOfSnake = arrayOfPossitions[0]
            arrayOfPossitions.remove(at: 0)
            if contains(array: arrayOfPossitions, point: headOfSnake) {
                playerDirection = .dead
            }
        }
    }
    
    private func generateNewPoint() {
        var randomX = CGFloat(arc4random_uniform(UInt32(numCols)))
        var randomY = CGFloat(arc4random_uniform(UInt32(numRows)))
        while contains(array: scene.playerPositions, point: (Int(randomX), Int(randomY))) {
            randomX = CGFloat(arc4random_uniform(UInt32(numCols)))
            randomY = CGFloat(arc4random_uniform(UInt32(numRows)))
        }
        scene.scorePos = CGPoint(x: randomX, y: randomY)
    }
    
    func renderChange() {
        for (cell, x, y) in scene.gameArray {
            if contains(array: scene.playerPositions, point: (x, y)) {
                cell.fillColor = SKColor.cyan
            } else {
                cell.fillColor = SKColor.clear
                if (scene.scorePos != nil) {
                    if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                        cell.fillColor = SKColor.red
                    }
                }
            }
        }
    }
    
    func contains(array: [(Int, Int)], point: (Int, Int)) -> Bool {
        let (x, y) = point
        for (ax, ay) in array {
            if (ax == x && ay == y) {
                return true
            }
        }
        return false
    }
    
    private func updatePlayerPosition() {
        var xChange = -1
        var yChange = 0
        
        switch playerDirection {
        case .up:
            xChange = 0
            yChange = -1
            break
        case .right:
            xChange = 1
            yChange = 0
            break
        case .down:
            xChange = 0
            yChange = 1
            break
        case .left:
            xChange = -1
            yChange = 0
            break
        case .dead:
            xChange = 0
            yChange = 0
            break
        }
        
        if scene.playerPositions.count > 0 {
            let x = scene.playerPositions[0].1
            let y = scene.playerPositions[0].0
            if y > numRows {
                scene.playerPositions[0].0 = 0
            } else if y < 0 {
                scene.playerPositions[0].0 = numRows
            } else if x > numCols {
               scene.playerPositions[0].1 = 0
            } else if x < 0 {
                scene.playerPositions[0].1 = numCols
            }
            
            var start = scene.playerPositions.count - 1
            while start > 0 {
                scene.playerPositions[start] = scene.playerPositions[start - 1]
                start -= 1
            }
            scene.playerPositions[0] = (scene.playerPositions[0].0 + yChange, scene.playerPositions[0].1 + xChange)
        }
        
        renderChange()
    }
    
    func swipe(id: Int) {
        var direction: States!
        switch id {
        case 0:
            direction = .up
            break
        case 1:
            direction = .right
            break
        case 2:
            direction = .down
            break
        default: // 3 and all the rest we turn left
            direction = .left
            break
        }
        
        if (direction != .up && playerDirection == .down) ||
            (direction != .down && playerDirection == .up) ||
            (direction != .right && playerDirection == .left) ||
            (direction != .left && playerDirection == .right) {
            if (playerDirection != .dead) {
                    playerDirection = direction
            }
        }
    }
}
