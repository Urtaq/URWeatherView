//
//  URDustEmitterNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

open class URDustEmitterNode: SKEmitterNode {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init() {
        super.init()

        let bundle = Bundle(for: URDustEmitterNode.self)
        let particleImage = UIImage(named: "spark", in: bundle, compatibleWith: nil)!
        self.particleTexture = SKTexture(image: particleImage)
        self.particleBirthRate = 15.0
//        self.particleBirthRateMax?
        self.particleLifetime = 2.3
        self.particleLifetimeRange = 0.0
        self.particlePositionRange = CGVector(dx: 650.0, dy: 350.0)
        self.zPosition = 0.0
        self.emissionAngle = 0.0
        self.emissionAngleRange = 0.0
        self.particleSpeed = 10.0
        self.particleSpeedRange = 50.0
        self.xAcceleration = -10.0
        self.yAcceleration = 10.0
        self.particleAlpha = 1.0
        self.particleAlphaRange = 0.1
        self.particleAlphaSpeed = -0.5
        self.particleScale = 0.0
        self.particleScaleRange = 0.1
        self.particleScaleSpeed = 0.1
        self.particleRotation = 0.0
        self.particleRotationRange = 0.0
        self.particleRotationSpeed = 0.0
        self.particleColorBlendFactor = 1.0
        self.particleColorBlendFactorRange = 0.0
        self.particleColorBlendFactorSpeed = 0.0
        self.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor(red: 95.0/255.0, green: 85.0/255.0, blue: 58.0/255.0, alpha: 1.0), UIColor(red: 95.0/255.0, green: 85.0/255.0, blue: 58.0/255.0, alpha: 1.0)], times: [0.0, 1.0])
        self.particleBlendMode = .alpha
    }
}
