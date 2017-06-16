//
//  UREffectLightningLineNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 26..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

/// draw the lightning line
class UREffectLightningLineNode: SKNode {
    static let textureLightningHalfCircle: SKTexture = SKTexture(image: UIImage(named: "lightning_half_circle", in: Bundle(for: UREffectLigthningNode.self), compatibleWith: nil)!)
    static let textureLightningSegment: SKTexture = SKTexture(image: UIImage(named: "lightning_segment", in: Bundle(for: UREffectLigthningNode.self), compatibleWith: nil)!)

    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero

    var lineThickness = 1.3

    init(start startPoint: CGPoint, end endPoint: CGPoint, thickness: Double = 1.3) {
        super.init()

        self.startPoint = startPoint
        self.endPoint = endPoint

        self.lineThickness = thickness
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func draw() {
        let imageThickness = 2.0
        let ratioThickness = CGFloat(self.lineThickness / imageThickness)
        let startPointInNode = self.convert(self.startPoint, from: self.parent!)
        let endPointInNode = self.convert(self.endPoint, from: self.parent!)

        let angle = atan2(endPointInNode.y - startPointInNode.y, endPointInNode.x - startPointInNode.x)
        let length = hypot(fabs(endPointInNode.x - startPointInNode.x), fabs(endPointInNode.y - startPointInNode.y))

        let halfCircleFront = SKSpriteNode(texture: UREffectLightningLineNode.textureLightningHalfCircle)
        halfCircleFront.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        halfCircleFront.yScale = ratioThickness
        halfCircleFront.zRotation = angle
        halfCircleFront.blendMode = .alpha
        halfCircleFront.position = startPointInNode

        let halfCircleBack = SKSpriteNode(texture: UREffectLightningLineNode.textureLightningHalfCircle)
        halfCircleBack.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        halfCircleBack.xScale = -1.0
        halfCircleBack.yScale = ratioThickness
        halfCircleBack.zRotation = angle
        halfCircleBack.blendMode = .alpha
        halfCircleBack.position = endPointInNode

        let lightningSegment = SKSpriteNode(texture: UREffectLightningLineNode.textureLightningSegment)
        lightningSegment.xScale = length * 2.0
        lightningSegment.yScale = ratioThickness
        lightningSegment.zRotation = angle
        lightningSegment.position = CGPoint(x: (startPointInNode.x + endPointInNode.x) * 0.5, y: (startPointInNode.y + endPointInNode.y) * 0.5)

        self.addChild(halfCircleFront)
        self.addChild(halfCircleBack)
        self.addChild(lightningSegment)
    }
}
