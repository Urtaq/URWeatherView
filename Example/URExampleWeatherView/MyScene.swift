//
//  MyScene.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 24..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

enum URWeatherType: String {
    case snow       = "MyParticleSnow.sks"
    case rain       = "MyParticleRain.sks"
    case dust       = "MyParticleSmoke.sks"
    case comet      = "MyParticleBurningComet.sks"
    case none       = "None"
}

enum URWeatherGroudType: String {
    case snow       = "MyParticleSnowGround.sks"
    case rain       = "MyParticleRainGround.sks"
    case none       = "None"
}

class MyScene: SKScene {
    private var emitter: SKEmitterNode!
    private var groundEmitter: SKEmitterNode!

    var weatherType: URWeatherType = .none
    var isGraphicsDebugOptionEnabled: Bool = false

    override init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func enableDebugOptions(needToShow: Bool) {
        self.isGraphicsDebugOptionEnabled = needToShow
        guard self.emitter != nil else { return }

        self.view!.showsFPS = self.isGraphicsDebugOptionEnabled
        self.view!.showsNodeCount = self.isGraphicsDebugOptionEnabled
        self.view!.showsFields = self.isGraphicsDebugOptionEnabled
        self.view!.showsPhysics = self.isGraphicsDebugOptionEnabled
        self.view!.showsDrawCount = self.isGraphicsDebugOptionEnabled
    }

    func setBirthRate(rate: CGFloat) {
        guard let _ = self.emitter else { return }
        self.emitter.particleBirthRate = rate

        guard let _ = self.groundEmitter else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.groundEmitter.particleBirthRate = rate / 2.0
        }
    }

    func startEmitter(weather: URWeatherType = .snow) {
        self.weatherType = weather
        self.emitter = SKEmitterNode(fileNamed: weather.rawValue)

        var particlePositionRangeX: CGFloat = self.view!.bounds.width
        if self.weatherType == .rain {
            particlePositionRangeX *= 2.0
        }
        if self.weatherType == .comet {
            self.emitter.position = CGPoint(x: 0, y: 0)
        } else {
            self.emitter.particlePositionRange = CGVector(dx: particlePositionRangeX, dy: 0)
            self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.height)
        }
        self.emitter.targetNode = self

        self.addChild(self.emitter)

        self.enableDebugOptions(needToShow: self.isGraphicsDebugOptionEnabled)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.startGroundEmitter()
        }
    }

    func startGroundEmitter() {
        switch self.weatherType {
        case .snow:
            self.groundEmitter = SKEmitterNode(fileNamed: URWeatherGroudType.snow.rawValue)
        case .rain:
            self.groundEmitter = SKEmitterNode(fileNamed: URWeatherGroudType.rain.rawValue)
        default:
            self.groundEmitter = nil
        }

        guard self.groundEmitter != nil else { return }

        self.groundEmitter.particlePositionRange = CGVector(dx: self.view!.bounds.width, dy: 0)
        self.groundEmitter.position = CGPoint(x: self.view!.bounds.midX, y: 5)
        self.groundEmitter.targetNode = self
        self.groundEmitter.particleBirthRate = self.emitter.particleBirthRate / 2.0

        self.addChild(self.groundEmitter)
    }

    func stopEmitter() {
        self.weatherType = .none

        guard let _ = self.emitter else { return }

        self.emitter.particleBirthRate = 0.0
        self.emitter.targetNode = nil
        self.emitter.removeFromParent()

        self.emitter = nil

        self.enableDebugOptions(needToShow: false)

        self.stopGroundEmitter()
    }

    func stopGroundEmitter() {
        guard self.groundEmitter != nil else { return }

        self.groundEmitter.particleBirthRate = 0.0
        self.groundEmitter.targetNode = nil
        self.groundEmitter.removeFromParent()

        self.groundEmitter = nil
    }
}
