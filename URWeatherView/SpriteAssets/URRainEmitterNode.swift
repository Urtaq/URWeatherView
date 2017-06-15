//
//  URRainEmitterNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

open class URRainEmitterNode: SKEmitterNode {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init() {
        super.init()

        let bundle = Bundle(for: URRainEmitterNode.self)
        let particleImage = UIImage(named: "rainDrop-1", in: bundle, compatibleWith: nil)!
        self.particleTexture = SKTexture(image: particleImage)
        self.particleBirthRate = 100.0
//        self.particleBirthRateMax?
        self.particleLifetime = 8.0
        self.particleLifetimeRange = 0.0
        self.particlePositionRange = CGVector(dx: 600.0, dy: 0.0)
        self.zPosition = 0.0
        self.emissionAngle = CGFloat(240.0 * .pi / 180.0)
        self.emissionAngleRange = 0.0
        self.particleSpeed = 200.0
        self.particleSpeedRange = 150.0
        self.xAcceleration = -100.0
        self.yAcceleration = -150.0
        self.particleAlpha = 0.7
        self.particleAlphaRange = 1.0
        self.particleAlphaSpeed = 0.0
        self.particleScale = 0.1
        self.particleScaleRange = 0.05
        self.particleScaleSpeed = 0.0
        self.particleRotation = CGFloat(-38.0 * .pi / 180.0)
        self.particleRotationRange = 0.0
        self.particleRotationSpeed = 0.0
        self.particleColorBlendFactor = 0.0
        self.particleColorBlendFactorRange = 0.0
        self.particleColorBlendFactorSpeed = 0.0
        self.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 1.0, alpha: 1.0), UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 1.0, alpha: 1.0)], times: [0.0, 1.0])
        self.particleBlendMode = .alpha
    }
}
