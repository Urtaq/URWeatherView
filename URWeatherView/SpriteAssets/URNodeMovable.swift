//
//  URNodeMovable.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 31..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

protocol URNodeMovable: class {
    var lastLocation: CGPoint { get set }
    var touchedNode: SKNode! { get set }
    var movableNodes: [SKNode] { get set }

    func handleTouch(_ touches: Set<UITouch>, isEnded: Bool)
    func updateNodePosition()

    func removeAllMovableNodes()
}

extension URNodeMovable {
    func removeAllMovableNodes() {
    }
}

extension URNodeMovable where Self: URWeatherScene {
    func handleTouch(_ touches: Set<UITouch>, isEnded: Bool = false) {
        guard !isEnded else {
            self.touchedNode = nil
            return
        }

        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            if self.touchedNode == nil {
                self.touchedNode = nodes.first
            } else {
                var isFound: Bool = false
                for node in nodes {
                    if node === self.touchedNode {
                        isFound = true
                        break
                    }
                }
                if !isFound {
                    self.touchedNode = nodes.first
                }
            }
            self.lastLocation = location
        }
    }

    func updateNodePosition() {
//        for movableNode in self.movableNodes {
//            movableNode.position = CGPoint(x: self.lastLocation.x, y: self.lastLocation.y)
//        }
        if self.touchedNode != nil {
            self.touchedNode.position = CGPoint(x: self.lastLocation.x, y: self.lastLocation.y)
        }
    }

    func removeAllMovableNodes() {
        self.movableNodes = [SKNode]()
    }
}

extension URNodeMovable where Self: SKNode {
    func handleTouch(_ touches: Set<UITouch>, isEnded: Bool = false) {
        for touch in touches {
            let location = touch.location(in: self)
            self.lastLocation = location
        }
    }

    func updateNodePosition() {
        self.position = CGPoint(x: self.lastLocation.x, y: self.lastLocation.y)
    }
}
