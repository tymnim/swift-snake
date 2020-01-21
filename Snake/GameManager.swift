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
    
    var nextTime: Double?
    var timeExtension: Double = 0.15
    
    enum Direction {
        case up, right, down, left
    }
    
    var playerDirection = Direction.up
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    // init game view and player
    func initGame() {
        scene.playerPositions.append((10, 10))
        scene.playerPositions.append((10, 11))
        scene.playerPositions.append((10, 12))
        renderChange()
    }
    
    // called every frame
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else {
            if time >= nextTime! {
                nextTime = time + timeExtension
                updatePlayerPosition()
            }
        }
    }
    
    func renderChange() {
        for (cell, x, y) in scene.gameArray {
            if contains(array: scene.playerPositions, point: (x, y)) {
                cell.fillColor = SKColor.cyan
            } else {
                cell.fillColor = SKColor.clear
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
        default:
            break
        }
        
        if scene.playerPositions.count > 0 {
            var start = scene.playerPositions.count - 1
            while start > 0 {
                scene.playerPositions[start] = scene.playerPositions[start - 1]
                start -= 1
            }
            scene.playerPositions[0] = (scene.playerPositions[0].0 + yChange, scene.playerPositions[0].1 + xChange)
        }
        
        renderChange()
    }
}
