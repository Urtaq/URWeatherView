//
//  UREffectLightningBoltNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 26..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

/// make bolt path & run to draw the lightning line
class UREffectLightningBoltNode: SKNode {

    var option: UREffectLightningOption!
    var pathArray = [CGPoint]()
    var depth: Int = 0
    var startPoint: CGPoint!
    var endPoint: CGPoint!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(start startPoint: CGPoint, end endPoint: CGPoint, option drawOption: UREffectLightningOption = UREffectLightningOption()) {
        super.init()

        self.option = drawOption
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.drawBolt(start: startPoint, end: endPoint)
    }

    func drawBolt(start startPoint: CGPoint, end endPoint: CGPoint) {
        self.pathArray.append(startPoint)

        // Dynamically calculating displace
        let xRange = endPoint.x - startPoint.x
        let yRange = endPoint.y - startPoint.y
        let hypotenuse = hypot(fabs(xRange), fabs(yRange))

        let displace = Double(hypotenuse) * self.option.displaceCoefficient
        self.createBoltPath(start: startPoint, end: endPoint, displace: displace)

        for i in 0 ..< self.pathArray.count - 1 {
            self.addLineToBolt(start: self.pathArray[i], end: self.pathArray[i + 1], delay: Double(i) * self.option.lineDrawDelay)
        }

        let waitDuration = Double(self.pathArray.count - 1) * self.option.lineDrawDelay + self.option.lightningLifetimeCoefficient
        let disappear = SKAction.sequence([SKAction.wait(forDuration: waitDuration), SKAction.fadeOut(withDuration: self.option.lightningDisappeartime), SKAction.removeFromParent()])
        self.run(disappear)
    }

    func createBoltPath(start startPoint: CGPoint, end endPoint: CGPoint, displace: Double) {
        if displace < self.option.lineRangeCoefficient {
            let point = CGPoint(x: endPoint.x, y: endPoint.y)
            self.pathArray.append(point)
        } else {
            var midXOnRoute = (endPoint.x + startPoint.x) * 0.5
            var midYOnRoute = (endPoint.y + startPoint.y) * 0.5
            midXOnRoute += (CGFloat(arc4random_uniform(100)) * 0.01 - 0.5) * CGFloat(displace)
            midYOnRoute += (CGFloat(arc4random_uniform(100)) * 0.01 - 0.5) * CGFloat(displace)

            let halfDisplace = displace * 0.5
            self.createBoltPath(start: startPoint, end: CGPoint(x: midXOnRoute, y: midYOnRoute), displace: halfDisplace)
            self.createBoltPath(start: CGPoint(x: midXOnRoute, y: midYOnRoute), end: endPoint, displace: halfDisplace)
        }
    }

    func addLineToBolt(start startPoint: CGPoint, end endPoint: CGPoint, delay: Double) {
        let line = UREffectLightningLineNode(start: startPoint, end: endPoint, thickness: self.option.lineThickness)
        self.addChild(line)
        if delay == 0.0 {
            line.draw()
        } else {
            let delayAction = SKAction.wait(forDuration: delay)
            let draw = SKAction.run {
                line.draw()
            }
            line.run(SKAction.sequence([delayAction, draw]))
        }
    }

    func pointOnBoltPath(position: Double) -> CGPoint? {
        guard position >= 0.0 && position <= 1.0 else { return nil }

        let pathPosition: Int = Int(round(Double(self.pathArray.count - 1) * position))
        return self.pathArray[pathPosition]
    }
}
