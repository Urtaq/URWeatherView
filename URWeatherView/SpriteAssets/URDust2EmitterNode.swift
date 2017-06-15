//
//  URDust2EmitterNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

open class URDust2EmitterNode: SKEmitterNode {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init() {
        super.init()

        let bundle = Bundle(for: URDust2EmitterNode.self)
        let particleImage = UIImage(named: "dust", in: bundle, compatibleWith: nil)!
        self.particleTexture = SKTexture(image: particleImage)
        self.particleBirthRate = 3.0
//        self.particleBirthRateMax?
        self.particleLifetime = 10.3
        self.particleLifetimeRange = 0.0
        self.particlePositionRange = CGVector(dx: 650.0, dy: 350.0)
        self.zPosition = 0.0
        self.emissionAngle = 0.0
        self.emissionAngleRange = 0.0
        self.particleSpeed = 5.0
        self.particleSpeedRange = 10.0
        self.xAcceleration = -10.0
        self.yAcceleration = 10.0
        self.particleAlpha = 1.0
        self.particleAlphaRange = 0.9
        self.particleAlphaSpeed = -0.5
        self.particleScale = 0.3
        self.particleScaleRange = 0.1
        self.particleScaleSpeed = 0.3
        self.particleRotation = 0.0
        self.particleRotationRange = 0.0
        self.particleRotationSpeed = 0.0
        self.particleColorBlendFactor = 1.0
        self.particleColorBlendFactorRange = 0.0
        self.particleColorBlendFactorSpeed = 0.0
        self.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor(red: 206.0/255.0, green: 144.0/255.0, blue: 82.0/255.0, alpha: 1.0), UIColor(red: 206.0/255.0, green: 144.0/255.0, blue: 82.0/255.0, alpha: 1.0)], times: [0.0, 1.0])
        self.particleBlendMode = .alpha
    }
}
