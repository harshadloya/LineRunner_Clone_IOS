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
    static let Obstacle : UInt32 = 0x1 << 3
}


class GameScene: SKScene {
    
    var Ground = SKSpriteNode()
    var Runner = SKSpriteNode()
    var Background = SKSpriteNode()
    var Obstacle = SKSpriteNode()
    var moveAndRemove = SKAction()
    
    override func didMove(to view: SKView) {
        
        //1080px X 100px
        Ground = SKSpriteNode(imageNamed: "ground")
        Ground.setScale(0.62)
        Ground.position = CGPoint(x: self.frame.size.width / 2, y: Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PCat.Ground
        Ground.physicsBody?.collisionBitMask = PCat.Runner
        Ground.physicsBody?.contactTestBitMask = PCat.Runner
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        Ground.zPosition = 3
        self.addChild(Ground)
        
        //200px X 200px
        Runner = SKSpriteNode(imageNamed: "ca")
        Runner.size = CGSize (width: 60, height: 70)
        Runner.position = CGPoint(x: 25 + Runner.frame.size.width / 2, y: 0 + self.frame.height / 2)
        
        //Runner.physicsBody = SKPhysicsBody(circleOfRadius: Runner.frame.height / 2)
        Runner.physicsBody = SKPhysicsBody(rectangleOf: Runner.size)
        Runner.physicsBody?.categoryBitMask = PCat.Runner
        Runner.physicsBody?.collisionBitMask = PCat.Ground | PCat.Obstacle
        Runner.physicsBody?.contactTestBitMask = PCat.Ground | PCat.Obstacle
        Runner.physicsBody?.affectedByGravity = true
        Runner.physicsBody?.isDynamic = true
        Runner.physicsBody?.allowsRotation = false
        Runner.zPosition = 2
        self.addChild(Runner)
        
        Background = SKSpriteNode(imageNamed: "bg")
        Background.setScale(0.45)
        Background.position = CGPoint(x: 0, y: self.frame.height)
        Background.zPosition = 1
        self.addChild(Background)
        
        let spawnObs = SKAction.run {
            
            () in
            
            self.createObstacles()
        }
        
        let delay = SKAction.wait(forDuration: 2.0)
        let obsSeq = SKAction.sequence([spawnObs, delay])
        let createObsForever = SKAction.repeatForever(obsSeq)
        
        self.run(createObsForever)
        
        let dist = CGFloat(self.frame.size.width)
        let moveObs = SKAction.moveBy(x: -dist, y: 0, duration: TimeInterval(0.01*dist))
        let removeObs = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveObs, removeObs])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Runner.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        Runner.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func createObstacles()
    {
        //let obstacle = SKSpriteNode(imageNamed: "ca")
        let obstacle = SKSpriteNode (color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), size: CGSize(width: 100, height: 100))
        //should be 100 x 1000
        obstacle.setScale(0.3)
        obstacle.position = CGPoint(x: self.frame.size.width, y: Ground.frame.height + obstacle.frame.size.height / 2)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = PCat.Obstacle
        obstacle.physicsBody?.collisionBitMask = PCat.Runner
        obstacle.physicsBody?.contactTestBitMask = PCat.Runner
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.isDynamic = false
        obstacle.zPosition = 2
        
        let randomPosition = randomHeight(min: -5, max: 145)
        obstacle.position.y = obstacle.position.y + randomPosition
        
        obstacle.run(moveAndRemove)
        
        self.addChild(obstacle)
        
    }
    
    //will give random height for the obstacles
    //static
        func randomHeight() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    //static
        func randomHeight(min : CGFloat, max : CGFloat) -> CGFloat
    {
        return randomHeight() * (max - min) + min
    }
}
