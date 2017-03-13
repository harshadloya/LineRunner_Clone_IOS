//
//  GameScene.swift
//  p04-loya
//
//  Created by Harshad Loya on 3/13/17.
//  Copyright © 2017 Harshad Loya. All rights reserved.
//

import SpriteKit
import GameplayKit


struct PCat {
    
    static let Runner : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    //static let Runner : UInt32 = 0x1 << 1
}


class GameScene: SKScene {
    
    var Ground = SKSpriteNode()
    var Runner = SKSpriteNode()
    var Background = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        Ground = SKSpriteNode(imageNamed: "ground")
        Ground.setScale(0.62)
        Ground.position = CGPoint(x: self.frame.size.width / 2, y: 0 + Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PCat.Ground
        Ground.physicsBody?.collisionBitMask = PCat.Runner
        Ground.physicsBody?.contactTestBitMask = PCat.Runner
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        Ground.zPosition = 3
        self.addChild(Ground)
        
        
        Runner = SKSpriteNode(imageNamed: "ca")
        Runner.size = CGSize (width: 60, height: 70)
        Runner.position = CGPoint(x: self.frame.size.width / 2, y: 0 + self.frame.height / 2)
        
        Runner.physicsBody = SKPhysicsBody(circleOfRadius: Runner.frame.height / 2)
        Runner.physicsBody?.categoryBitMask = PCat.Runner
        Runner.physicsBody?.collisionBitMask = PCat.Ground
        Runner.physicsBody?.contactTestBitMask = PCat.Ground
        Runner.physicsBody?.affectedByGravity = true
        Runner.physicsBody?.isDynamic = true
        Runner.zPosition = 2
        self.addChild(Runner)
        
        Background = SKSpriteNode(imageNamed: "bg")
        Background.setScale(0.45)
        Background.position = CGPoint(x: 0, y: self.frame.height)
        Background.zPosition = 1
        self.addChild(Background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Runner.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        Runner.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
