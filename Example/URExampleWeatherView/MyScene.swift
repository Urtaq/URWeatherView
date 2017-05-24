//
//  MyScene.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 23..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

class MyScene: SKScene, URScene, SKPhysicsContactDelegate {

    var emitter: SKEmitterNode!

    var isGraphicsDebugOptionEnabled: Bool = false

    var extraEffectBlock: ((UIImage?) -> Void)?

    var spark: SKSpriteNode!
    var bokehs: [SKSpriteNode] = [SKSpriteNode]()
    var portal: SKSpriteNode!

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        self.physicsWorld.contactDelegate = self

        self.spark = self.childNode(withName: "spark") as! SKSpriteNode
        self.portal = self.childNode(withName: "portal") as! SKSpriteNode

        for child in self.children {
            if child.name == "bokeh" {
                self.bokehs.append(child as! SKSpriteNode)
            }
        }
    }

    func startScene() -> SKScene? {
        for childNode in self.children {
            if childNode is SKLightNode {
            }
        }
        return nil
    }

    override func didSimulatePhysics() {
        self.updatePlayer()
        self.updateCamera()
    }

    private func checkNeedToHandlePosition(currentPosition: CGPoint, touchedPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchedPosition.x) > self.spark!.frame.width / 2 ||
            abs(currentPosition.y - touchedPosition.y) > self.spark!.frame.height / 2
    }

    var playerSpeed: CGFloat = 150.0
    var zombieSpeed: CGFloat = 75.0
    func updatePlayer() {
        if lastLocation != .zero {
            let currentPosition: CGPoint = self.spark.position
            if self.checkNeedToHandlePosition(currentPosition: currentPosition, touchedPosition: self.lastLocation) {
                let angle = atan2(currentPosition.y - lastLocation.y, currentPosition.x - lastLocation.x) + CGFloat.pi
                let rotateAction = SKAction.rotate(toAngle: angle - CGFloat.pi * 0.5, duration: 0)

                self.spark!.run(rotateAction)

                let velocityX = self.playerSpeed * cos(angle)
                let velocityY = self.playerSpeed * sin(angle)

                let newVelocity = CGVector(dx: velocityX, dy: velocityY)
                print("currentPosition : \(currentPosition), lastLocation : \(lastLocation), angle : \(angle), newVelocity : \(newVelocity)")
                self.spark!.physicsBody?.velocity = newVelocity
                self.updateCamera()
            }
        } else {
            self.spark!.physicsBody?.isResting = true
        }
    }

    func updateCamera() {
        guard let cam = self.camera else { return }
        cam.position = self.spark.position
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouch(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouch(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouch(touches)
    }

    var lastLocation: CGPoint = .zero
    func handleTouch(_ touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self)
            self.lastLocation = location
        }
    }

    func gameover(_ isWin: Bool) {
        print("\(#function) + \(isWin)")
    }

    // MARK: - SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        var firstPhysicsBody: SKPhysicsBody
        var secondPhysicsBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstPhysicsBody = contact.bodyA
            secondPhysicsBody = contact.bodyB
        } else {
            firstPhysicsBody = contact.bodyB
            secondPhysicsBody = contact.bodyA
        }

        if firstPhysicsBody.categoryBitMask == self.spark.physicsBody?.categoryBitMask &&
            secondPhysicsBody.categoryBitMask == self.bokehs[0].physicsBody?.categoryBitMask {
            self.gameover(false)
        } else if firstPhysicsBody.categoryBitMask == self.spark.physicsBody?.categoryBitMask &&
            secondPhysicsBody.categoryBitMask == self.portal.physicsBody?.categoryBitMask {
            self.gameover(true)
        }
    }
}
