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
    var lost = Bool()
    var restartBtn = SKSpriteNode()
    
    func restartScene()
    {
        self.removeAllChildren()
        self.removeAllActions()
        lost = false
        score = 0
        self.isPaused = false
        createScene()
    }
    
    func createScene()
    {
        
        self.physicsWorld.contactDelegate = self
        
        scoreLbl.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "Roof runners active"
        scoreLbl.zPosition = 5
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
        Ground.zPosition = 4
        self.addChild(Ground)
        
        //200px X 200px
        Runner = SKSpriteNode(imageNamed: "ca")
        Runner.size = CGSize (width: 60, height: 70)
        Runner.position = CGPoint(x: 25 + Runner.frame.size.width / 2, y: 0 + self.frame.height / 2)
        
        Runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Runner.frame.width - 15, height: Runner.frame.height))
        Runner.physicsBody?.categoryBitMask = PCat.Runner
        Runner.physicsBody?.collisionBitMask = PCat.Ground | PCat.Obstacle
        Runner.physicsBody?.contactTestBitMask = PCat.Ground | PCat.Obstacle | PCat.Score
        Runner.physicsBody?.affectedByGravity = true
        Runner.physicsBody?.isDynamic = true
        Runner.physicsBody?.allowsRotation = false
        Runner.zPosition = 3
        self.addChild(Runner)
        
        
        //1334px X 750px
        let backgroundImg = SKSpriteNode(imageNamed: "back")
        backgroundImg.name = "bgImg"
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
        
        let dist = CGFloat(self.frame.size.width + 100)
        let moveObs = SKAction.moveBy(x: -dist, y: 0, duration: TimeInterval(0.005*dist))
        let removeObs = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveObs, removeObs])
    }
    
    override func didMove(to view: SKView) {
        
        createScene()
    }
    
    func createButton()
    {
        restartBtn = SKSpriteNode(imageNamed: "RstBtn")
        restartBtn.size = CGSize(width: 100, height: 50)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 5
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        
        restartBtn.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstObj = contact.bodyA
        let secondObj = contact.bodyB
        
        if firstObj.categoryBitMask == PCat.Score && secondObj.categoryBitMask == PCat.Runner || firstObj.categoryBitMask == PCat.Runner && secondObj.categoryBitMask == PCat.Score {
            score += 1
            scoreLbl.text = "\(score)"
        }
        
        if firstObj.categoryBitMask == PCat.Obstacle && secondObj.categoryBitMask == PCat.Runner || firstObj.categoryBitMask == PCat.Runner && secondObj.categoryBitMask == PCat.Obstacle {
            
            //Died, Game Lost Condition to be added
            lost = true
            
            
            enumerateChildNodes(withName: "obsScorePair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            }))
            
            createButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if lost == true
        {
            
        }
        else
        {
            Runner.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Runner.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 85))
        }
        
        for touch in touches
        {
            let touchPoint = touch.location(in: self)
            
            if lost == true
            {
                if restartBtn.contains(touchPoint)
                {
                    restartScene()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    func createObstacles()
    {
        
        let scoreNode = SKNode()
        
        
        let scoreNode1 = SKSpriteNode(imageNamed: "dia3")
        
        scoreNode1.size = CGSize (width: 20, height: 20)
        scoreNode1.position = CGPoint(x: self.frame.width, y: Ground.frame.height + scoreNode1.frame.height / 2)
        scoreNode1.zPosition = 3
        scoreNode1.physicsBody = SKPhysicsBody(rectangleOf: scoreNode1.size)
        scoreNode1.physicsBody?.affectedByGravity = false
        scoreNode1.physicsBody?.isDynamic = true
        scoreNode1.physicsBody?.categoryBitMask = PCat.Score
        scoreNode1.physicsBody?.collisionBitMask = PCat.Obstacle
        scoreNode1.physicsBody?.contactTestBitMask = PCat.Runner
        
        
        scoreNode.addChild(scoreNode1)
        /*
        Bonus Points Diamond
        
        let scoreNode2 = SKSpriteNode(imageNamed: "dia4")
        
        scoreNode2.size = CGSize (width: 25, height: 25)
        scoreNode2.position = CGPoint(x: scoreNode1.position.x + scoreNode2.frame.width / 2 + 20, y: Ground.frame.height + self.frame.height / 2)
        scoreNode2.zPosition = 3
        scoreNode2.physicsBody = SKPhysicsBody(rectangleOf: scoreNode2.size)
        scoreNode2.physicsBody?.affectedByGravity = false
        scoreNode2.physicsBody?.isDynamic = false
        scoreNode2.physicsBody?.categoryBitMask = PCat.Score
        scoreNode2.physicsBody?.collisionBitMask = 0
        scoreNode2.physicsBody?.contactTestBitMask = PCat.Runner
        
        scoreNode.addChild(scoreNode2)
        */
        
        let obsScorePair = SKNode()
        obsScorePair.name = "obsScorePair"
        //200px X 100px
        let obstacle = SKSpriteNode(imageNamed: "rock1")
        
        obstacle.setScale(randomValue(min: 0.15, max: 0.4))
        
        obstacle.position = CGPoint(x: self.frame.size.width, y: Ground.frame.height + obstacle.frame.size.height / 2)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.frame.width*obstacle.xScale, height: obstacle.frame.height*obstacle.yScale))
        obstacle.physicsBody?.categoryBitMask = PCat.Obstacle
        obstacle.physicsBody?.collisionBitMask = PCat.Runner | PCat.Score
        obstacle.physicsBody?.contactTestBitMask = PCat.Runner
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.isDynamic = true
        obstacle.zPosition = 3
        
        let randomObsPosition = randomValue(min: 0, max: 130)
        obstacle.position.y = obstacle.position.y + randomObsPosition
        
        let randomScoreItemPositionY = randomValue(min: 0, max: 130)
        let randomScoreItemPositionX = randomValue(min: 0, max: 100)
        scoreNode.position.x = scoreNode.position.x + randomScoreItemPositionX
        scoreNode.position.y = scoreNode.position.y + randomScoreItemPositionY
        
        obsScorePair.addChild(obstacle)
        
        obsScorePair.addChild(scoreNode)
        
        obsScorePair.run(moveAndRemove)
        
        self.addChild(obsScorePair)
        
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
        
        let delayFish2 = SKAction.wait(forDuration: TimeInterval(randomValue(min: 7.0, max: 15.0)))
        let positionFish2 = SKAction.move(to: CGPoint(x: randomValue(min:  0, max: 1000), y: randomValue(min:  0, max: 700)), duration: 20)
        let obsSeqFish2 = SKAction.sequence([spawnFish2, delayFish2, positionFish2])
        let createFish2Forever = SKAction.repeatForever(obsSeqFish2)
        
        self.run(createFish2Forever)
        
        
        let maxHeight2 = CGFloat(self.frame.height - backgroundFish2.position.y)
        let maxWidth2 = CGFloat(self.frame.width - backgroundFish2.position.x)
        let moveFish2 = SKAction.moveBy(x: -maxWidth2, y: -maxHeight2+100, duration: TimeInterval(randomValue(min: 0.01, max: 0.07)*maxHeight2))
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
        backgroundFish4.name = "fish4"
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
        Fish.setScale(randomValue(min: 0.05, max: 0.25))
        Fish.position = CGPoint(x: -Fish.frame.width / 2, y: Ground.frame.height + Fish.frame.height / 2)
        Fish.zPosition = 2
        //Fish.position.x = randomValue(min: 10, max: self.frame.width - Fish.frame.width)
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
