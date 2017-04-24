//
//  MyScene.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 24..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

enum URWeatherType: String {
    case snow = "MyParticleSnow.sks"
    case rain = "MyParticleRain.sks"
    case dust = "MyParticleSmoke.sks"
    case none = "None"
}

class MyScene: SKScene {
    private var emitter: SKEmitterNode!

    var weatherType: URWeatherType = .none

    override init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setBirthRate(rate: CGFloat) {
        guard let _ = self.emitter else { return }

        self.emitter.particleBirthRate = rate
    }

    func startEmitter(weather: URWeatherType = .snow) {
        self.weatherType = weather
        self.emitter = SKEmitterNode(fileNamed: weather.rawValue)

        self.emitter.particlePositionRange = CGVector(dx: self.view!.bounds.width, dy: 0)
        self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.height)
        self.emitter.targetNode = self

        self.addChild(emitter)
    }

    func stopEmitter() {
        self.weatherType = .none

        guard let _ = self.emitter else { return }

        self.emitter.particleBirthRate = 0.0
        self.emitter.targetNode = nil
        self.emitter.removeFromParent()

        self.emitter = nil
    }
}
