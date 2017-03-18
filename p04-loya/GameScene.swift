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
    static let Score : UInt32 = 0x1 << 4
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Ground = SKSpriteNode()
    var Runner = SKSpriteNode()
    var Obstacle = SKSpriteNode()
    var moveAndRemove = SKAction()
    var moveAndRemove2 = SKAction()
    var moveAndRemoveFish1 = SKAction()
    var moveAndRemoveFish2 = SKAction()
    var moveAndRemoveFish3 = SKAction()
    var moveAndRemoveFish4 = SKAction()
    var moveAndRemoveFish5 = SKAction()
    
    var score = Int()
    var scoreLbl = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        scoreLbl.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        self.addChild(scoreLbl)
        
        
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
        Ground.zPosition = 5
        self.addChild(Ground)
        
        //200px X 200px
        Runner = SKSpriteNode(imageNamed: "ca")
        Runner.size = CGSize (width: 60, height: 70)
        Runner.position = CGPoint(x: 25 + Runner.frame.size.width / 2, y: 0 + self.frame.height / 2)
        
        Runner.physicsBody = SKPhysicsBody(circleOfRadius: Runner.frame.height / 2)
        Runner.physicsBody?.categoryBitMask = PCat.Runner
        Runner.physicsBody?.collisionBitMask = PCat.Ground | PCat.Obstacle
        Runner.physicsBody?.contactTestBitMask = PCat.Ground | PCat.Obstacle
        Runner.physicsBody?.affectedByGravity = true
        Runner.physicsBody?.isDynamic = true
        Runner.physicsBody?.allowsRotation = false
        Runner.zPosition = 4
        self.addChild(Runner)
        
        
        //1334px X 750px
        let backgroundImg = SKSpriteNode(imageNamed: "back")
        backgroundImg.setScale(0.5)
        backgroundImg.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundImg.zPosition = 1
        self.addChild(backgroundImg)
        
        createBackgroundElements()
        
        
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstObj = contact.bodyA
        let secondObj = contact.bodyB
        
        if firstObj.categoryBitMask == PCat.Score && secondObj.categoryBitMask == PCat.Runner || firstObj.categoryBitMask == PCat.Runner && secondObj.categoryBitMask == PCat.Score {
            score += 1
            print(score)
            scoreLbl.text = "\(score)"
        }
        
        if firstObj.categoryBitMask == PCat.Obstacle && secondObj.categoryBitMask == PCat.Runner || firstObj.categoryBitMask == PCat.Runner && secondObj.categoryBitMask == PCat.Obstacle {
            
            //Died, Game Lost Condition to be added
            
        }
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
        obstacle.zPosition = 4
        
        let randomPosition = randomValue(min: 0, max: 130)
        obstacle.position.y = obstacle.position.y + randomPosition
        
        obstacle.run(moveAndRemove)
        
        self.addChild(obstacle)
        
    }
    
    //random value between starting and ending value
        func randomValue() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
        func randomValue(min : CGFloat, max : CGFloat) -> CGFloat
    {
        return randomValue() * (max - min) + min
    }
    
    func createBackgroundElements()
    {
        moveBubbles()
        
        let backgroundFish1 = SKSpriteNode(imageNamed: "fish1")
        backgroundFish1.name = "fish1"
        
        let spawnFish1 = SKAction.run {
            
            () in
            
            self.createFish(Fish: backgroundFish1)
        }
        
        let delayFish1 = SKAction.wait(forDuration: TimeInterval(randomValue(min: 5.0, max: 15.0)))
        let positionFish1 = SKAction.move(to: CGPoint(x: randomValue(min:  0, max: 1000), y: randomValue(min:  0, max: 700)), duration: 20)
        let obsSeqFish1 = SKAction.sequence([spawnFish1, delayFish1, positionFish1])
        let createFish1Forever = SKAction.repeatForever(obsSeqFish1)
        
        self.run(createFish1Forever)
        
        let maxHeight = CGFloat(self.frame.height - backgroundFish1.position.y)
        let maxWidth = CGFloat(self.frame.width - backgroundFish1.position.x)
        let moveFish1 = SKAction.moveBy(x:maxWidth, y: maxHeight, duration: TimeInterval(randomValue(min: 0.01, max: 0.07)*maxHeight))
        let removeFish1 = SKAction.removeFromParent()
        moveAndRemoveFish1 = SKAction.sequence([moveFish1, removeFish1])
        

        let backgroundFish2 = SKSpriteNode(imageNamed: "fish2")
        backgroundFish2.name = "fish2"
        let spawnFish2 = SKAction.run {
            
            () in
            
            self.createFish(Fish: backgroundFish2)
        }
        
        let delayFish2 = SKAction.wait(forDuration: TimeInterval(randomValue(min: 5.0, max: 15.0)))
        let positionFish2 = SKAction.move(to: CGPoint(x: randomValue(min:  0, max: 1000), y: randomValue(min:  0, max: 700)), duration: 20)
        let obsSeqFish2 = SKAction.sequence([spawnFish2, delayFish2, positionFish2])
        let createFish2Forever = SKAction.repeatForever(obsSeqFish2)
        
        self.run(createFish2Forever)
        
        
        let maxHeight2 = CGFloat(self.frame.height - backgroundFish2.position.y)
        let maxWidth2 = CGFloat(self.frame.width - backgroundFish2.position.x)
        let moveFish2 = SKAction.moveBy(x: -maxWidth2, y: -maxHeight2, duration: TimeInterval(randomValue(min: 0.01, max: 0.07)*maxHeight2))
        let removeFish2 = SKAction.removeFromParent()
        moveAndRemoveFish2 = SKAction.sequence([moveFish2, removeFish2])
        
        
        
        let backgroundFish3 = SKSpriteNode(imageNamed: "fish3")
        backgroundFish3.name = "fish3"
        let spawnFish3 = SKAction.run {
            
            () in
            
            self.createFish(Fish: backgroundFish3)
        }
        
        let delayFish3 = SKAction.wait(forDuration: TimeInterval(randomValue(min: 5.0, max: 15.0)))
        let positionFish3 = SKAction.move(to: CGPoint(x: randomValue(min:  0, max: 1000), y: randomValue(min:  0, max: 700)), duration: 20)
        let obsSeqFish3 = SKAction.sequence([spawnFish3, delayFish3, positionFish3])
        let createFish3Forever = SKAction.repeatForever(obsSeqFish3)
        
        self.run(createFish3Forever)
        
        
        let maxHeight3 = CGFloat(self.frame.height - backgroundFish3.position.y)
        let maxWidth3 = CGFloat(self.frame.width - backgroundFish3.position.x)
        let moveFish3 = SKAction.moveBy(x: maxWidth3, y: 0, duration: TimeInterval(randomValue(min: 0.01, max: 0.07)*maxHeight3))
        let removeFish3 = SKAction.removeFromParent()
        moveAndRemoveFish3 = SKAction.sequence([moveFish3, removeFish3])
        
        
        
        let backgroundFish4 = SKSpriteNode(imageNamed: "fish4")
        //let spawnFish4 = SKAction()
        backgroundFish4.name = "fish4"
        //if (!backgroundFish4.action)
        //{
            let spawnFish4 = SKAction.run
            {
                () in
                self.createFish(Fish: backgroundFish4)
            }
        
        
        let delayFish4 = SKAction.wait(forDuration: TimeInterval(randomValue(min: 10.0, max: 15.0)))
        let positionFish4 = SKAction.move(to: CGPoint(x: randomValue(min:  0, max: 1000), y: randomValue(min:  0, max: 700)), duration: 20)
        let obsSeqFish4 = SKAction.sequence([spawnFish4, delayFish4, positionFish4])
        let createFish4Forever = SKAction.repeatForever(obsSeqFish4)
        
        self.run(createFish4Forever)
        
        
        let maxHeight4 = CGFloat(self.frame.height - backgroundFish4.position.y)
        let maxWidth4 = CGFloat(self.frame.width - backgroundFish4.position.x)
        let moveFish4 = SKAction.moveBy(x:maxWidth4, y: 100, duration: TimeInterval(randomValue(min: 0.01, max: 0.07)*maxHeight4))
        let removeFish4 = SKAction.removeFromParent()
        moveAndRemoveFish4 = SKAction.sequence([moveFish4, removeFish4])
        //}
        
        let backgroundFish5 = SKSpriteNode(imageNamed: "fish5")
        backgroundFish5.name = "fish5"
        let spawnFish5 = SKAction.run {
            
            () in
            
            self.createFish(Fish: backgroundFish5)
        }
        
        let delayFish5 = SKAction.wait(forDuration: TimeInterval(randomValue(min: 5.0, max: 15.0)))
        let positionFish5 = SKAction.move(to: CGPoint(x: randomValue(min:  0, max: 1000), y: randomValue(min:  0, max: 700)), duration: 20)
        let obsSeqFish5 = SKAction.sequence([spawnFish5, delayFish5, positionFish5])
        let createFish5Forever = SKAction.repeatForever(obsSeqFish5)
        
        self.run(createFish5Forever)
        
        
        
        let maxHeight5 = CGFloat(self.frame.height - backgroundFish5.position.y)
        let maxWidth5 = CGFloat(self.frame.width - backgroundFish5.position.x)
        let moveFish5 = SKAction.moveBy(x:maxWidth5, y: 0, duration: TimeInterval(randomValue(min: 0.001, max: 0.007)*maxHeight5))
        let removeFish5 = SKAction.removeFromParent()
        moveAndRemoveFish5 = SKAction.sequence([moveFish5, removeFish5])
        
    }
    
    func createFish(Fish: SKSpriteNode)
    {
        Fish.setScale(randomValue(min: 0.15, max: 0.30))
        Fish.position = CGPoint(x: 10 + Fish.frame.width / 2, y: Ground.frame.height + Fish.frame.height / 2)
        Fish.zPosition = 2
        Fish.position.x = randomValue(min: 10, max: self.frame.width - Fish.frame.width)
        Fish.position.y = randomValue(min: 10, max: self.frame.height - Fish.frame.height / 2)
        
        if(Fish.name == "fish1")
        {
            Fish.run(moveAndRemoveFish1)
        }
        else if(Fish.name == "fish2")
        {
            Fish.run(moveAndRemoveFish2)
        }
        else if(Fish.name == "fish3")
        {
            Fish.run(moveAndRemoveFish3)
        }
        else if(Fish.name == "fish4")
        {
            Fish.run(moveAndRemoveFish4)
        }
        else if(Fish.name == "fish5")
        {
            Fish.run(moveAndRemoveFish5)
        }
        
        self.addChild(Fish)
    }
    
    
    func createBubbles()
    {
        
        let bubbleGroup = SKNode()
        
        for _ in 1...10
        {
            let backgroundBubble = SKSpriteNode(imageNamed: "bubble2")
            backgroundBubble.setScale(randomValue(min: 0.03, max: 0.2))
            backgroundBubble.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            backgroundBubble.zPosition = 2
            backgroundBubble.position.x = randomValue(min: 5, max: self.frame.width - backgroundBubble.frame.width / 2)
            backgroundBubble.position.y = randomValue(min: 10, max: self.frame.height - backgroundBubble.frame.height / 2)
            bubbleGroup.addChild(backgroundBubble)
        }
        
        //Background.addChild(bubbleGroup)
        bubbleGroup.run(moveAndRemove2)
        
        
        self.addChild(bubbleGroup)
    }
    
    func moveBubbles()
    {
        let spawnObs = SKAction.run {
            
            () in
            
            self.createBubbles()
        }
        
        let delay = SKAction.wait(forDuration: TimeInterval(randomValue(min: 5.1, max: 5.5)))
        let obsSeq = SKAction.sequence([spawnObs, delay])
        let createBackForever = SKAction.repeatForever(obsSeq)
        
        self.run(createBackForever)
        
        let dist = CGFloat(self.frame.height)
        let moveObs = SKAction.moveBy(x: 0, y: dist, duration: TimeInterval(randomValue(min: 0.01, max: 0.09)*dist))
        let removeObs = SKAction.removeFromParent()
        moveAndRemove2 = SKAction.sequence([moveObs, removeObs])

    }
}
