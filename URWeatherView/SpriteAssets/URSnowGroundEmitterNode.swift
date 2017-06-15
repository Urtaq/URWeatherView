//
//  URSnowGroundEmitterNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 14..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

open class URSnowGroundEmitterNode: SKEmitterNode {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init() {
        super.init()

        let bundle = Bundle(for: URSnowGroundEmitterNode.self)
        let particleImage = UIImage(named: "snow_typeB", in: bundle, compatibleWith: nil)!
        self.particleTexture = SKTexture(image: particleImage)
        self.particleBirthRate = 100.0
//        self.particleBirthRateMax?
        self.particleLifetime = 2.0
        self.particleLifetimeRange = 5.0
        self.particlePositionRange = CGVector(dx: 100.0, dy: 7.5)
        self.zPosition = 0.0
        self.emissionAngle = CGFloat(-90.0 * .pi / 180.0)
        self.emissionAngleRange = 0.0
        self.particleSpeed = 0.1
        self.particleSpeedRange = 0.1
        self.xAcceleration = 0.0
        self.yAcceleration = 0.0
        self.particleAlpha = 0.1
        self.particleAlphaRange = 0.3
        self.particleAlphaSpeed = 0.3
        self.particleScale = 0.06
        self.particleScaleRange = 0.1
        self.particleScaleSpeed = 0.0
        self.particleRotation = 0.0
        self.particleRotationRange = 0.0
        self.particleRotationSpeed = 0.0
        self.particleColorBlendFactor = 1.0
        self.particleColorBlendFactorRange = 0.0
        self.particleColorBlendFactorSpeed = 0.0
        self.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 1.0, alpha: 1.0), UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 1.0, alpha: 1.0)], times: [0.0, 1.0])
        self.particleBlendMode = .alpha
    }
}
