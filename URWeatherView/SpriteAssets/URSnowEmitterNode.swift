//
//  URSnowEmitterNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 14..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

open class URSnowEmitterNode: SKEmitterNode {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init() {
        super.init()

        let bundle = Bundle(for: URSnowEmitterNode.self)
        let particleImage = UIImage(named: "snow_typeA", in: bundle, compatibleWith: nil)!
        self.particleTexture = SKTexture(image: particleImage)
        self.particleBirthRate = 40.0
//        self.particleBirthRateMax?
        self.particleLifetime = 50.0
        self.particleLifetimeRange = 0.0
        self.particlePositionRange = CGVector(dx: 363.44, dy: -30.0)
        self.zPosition = 0.0
        self.emissionAngle = CGFloat(269.863 * .pi / 180.0)
        self.emissionAngleRange = CGFloat(22.918 * .pi / 180.0)
        self.particleSpeed = 10.0
        self.particleSpeedRange = 30.0
        self.xAcceleration = -2
        self.yAcceleration = -1
        self.particleAlpha = 1.0
        self.particleAlphaRange = 0.2
        self.particleAlphaSpeed = 0.0
        self.particleScale = 0.1
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
