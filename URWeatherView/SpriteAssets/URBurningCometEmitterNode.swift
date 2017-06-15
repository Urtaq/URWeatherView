//
//  URBurningCometEmitterNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

open class URBurningCometEmitterNode: SKEmitterNode {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init() {
        super.init()

        let bundle = Bundle(for: URBurningCometEmitterNode.self)
        let particleImage = UIImage(named: "spark", in: bundle, compatibleWith: nil)!
        self.particleTexture = SKTexture(image: particleImage)
        self.particleBirthRate = 300.0
//        self.particleBirthRateMax?
        self.particleLifetime = 1.5
        self.particleLifetimeRange = 0.0
        self.particlePositionRange = CGVector(dx: 5.0, dy: 5.0)
        self.zPosition = 0.0
        self.emissionAngle = CGFloat(150.0 * .pi / 180.0)
        self.emissionAngleRange = CGFloat(20.054 * .pi / 180.0)
        self.particleSpeed = 100.0
        self.particleSpeedRange = 50.0
        self.xAcceleration = 0.0
        self.yAcceleration = 100.0
        self.particleAlpha = 1.0
        self.particleAlphaRange = 0.2
        self.particleAlphaSpeed = -0.45
        self.particleScale = 0.5
        self.particleScaleRange = 0.4
        self.particleScaleSpeed = -0.5
        self.particleRotation = 0.0
        self.particleRotationRange = 0.0
        self.particleRotationSpeed = 0.0
        self.particleColorBlendFactor = 1.0
        self.particleColorBlendFactorRange = 0.0
        self.particleColorBlendFactorSpeed = 0.0
        self.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor(red: 78.0/255.0, green: 33.0/255.0, blue: 6.0/255.0, alpha: 1.0), UIColor(red: 249.0/255.0, green: 108.0/255.0, blue: 21.0/255.0, alpha: 1.0), UIColor(red: 249.0/255.0, green: 108.0/255.0, blue: 21.0/255.0, alpha: 1.0)], times: [0.0, 0.35, 1.0])
        self.particleBlendMode = .add
    }
}
