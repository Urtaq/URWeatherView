//
//  URWeatherScene.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 24..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

enum URWeatherType: String {
    case snow       = "MyParticleSnow.sks"
    case rain       = "MyParticleRain.sks"
    case dust       = "MyParticleDust.sks"
    case comet      = "MyParticleBurningComet.sks"
    case smoke       = "MyParticleSmoke.sks"
    case none       = "None"

    var ground: URWeatherGroundType {
        switch self {
        case .snow:
            return .snow
        case .rain:
            return .rain
        default:
            return .none
        }
    }

    var backgroundImage: UIImage? {
        switch self {
        case .snow:
            return #imageLiteral(resourceName: "snow")
        case .rain:
            return #imageLiteral(resourceName: "rain")
        case .dust:
            return #imageLiteral(resourceName: "yellowDust")
        default:
            return nil
        }
    }
}

enum URWeatherGroundType: String {
    case snow       = "MyParticleSnowGround.sks"
    case rain       = "MyParticleRainGround.sks"
    case none       = "None"
}

class URWeatherScene: SKScene {
    private var emitter: SKEmitterNode!
    private var subEmitter: SKEmitterNode!
    private var groundEmitter: SKEmitterNode!

    private var timer: Timer!

    var weatherType: URWeatherType = .none
    var isGraphicsDebugOptionEnabled: Bool = false

    var extraEffectBlock: ((UIImage?) -> Void)?

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
            self.emitter.position = CGPoint(x: 0, y: self.view!.bounds.height)
            self.subEmitter = SKEmitterNode(fileNamed: weatherType.rawValue)

            self.subEmitter.position = CGPoint(x: self.view!.bounds.width, y: 0)
            self.subEmitter.emissionAngle = 330.0 * CGFloat.pi / 180.0
            self.subEmitter.yAcceleration = -100

            self.subEmitter.targetNode = self
            self.addChild(self.subEmitter)
        } else if self.weatherType == .dust {
            self.emitter.particlePositionRange = CGVector(dx: particlePositionRangeX, dy: self.view!.bounds.height)
            self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY)
            self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { (timer) in
                if self.emitter.yAcceleration == -10 {
                    self.emitter.yAcceleration = 10
                } else {
                    self.emitter.yAcceleration = -10
                }
            })

//            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
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

        guard let block = self.extraEffectBlock else { return }
        block(self.weatherType.backgroundImage)
    }

    func startGroundEmitter() {
        switch self.weatherType {
//        case .snow:
//            self.groundEmitter = SKEmitterNode(fileNamed: URWeatherGroundType.snow.rawValue)
        case .rain:
            self.groundEmitter = SKEmitterNode(fileNamed: URWeatherType.rain.ground.rawValue)
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

        if self.timer != nil {
            self.timer.invalidate()
        }
        self.backgroundColor = .clear
    }

    func stopGroundEmitter() {
        guard self.groundEmitter != nil else { return }

        self.groundEmitter.particleBirthRate = 0.0
        self.groundEmitter.targetNode = nil
        self.groundEmitter.removeFromParent()

        self.groundEmitter = nil
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.weatherType == .comet {
            if let _ = self.emitter.parent {
            } else {
                self.addChild(self.emitter)
            }
            if let _ = self.subEmitter.parent {
            } else {
                self.addChild(self.subEmitter)
            }

            let moveAction: SKAction = SKAction.move(to: CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY), duration: 0.5)
            let action: SKAction = SKAction.customAction(withDuration: 0.5, actionBlock: { (node, elapsedTime) in
                if node === self.emitter {
                    self.emitter.particlePositionRange = CGVector(dx: 100.0, dy: self.emitter.particlePositionRange.dy * 2.0)
                    self.emitter.emissionAngle = 90.0 * CGFloat.pi / 180.0
                }
            })
            let backAction: SKAction = SKAction.move(to: CGPoint(x: 0, y: self.view!.bounds.height), duration: 0.0)
            let initAction: SKAction = SKAction.customAction(withDuration: 0.0, actionBlock: { (node, elapsedTime) in
                if node === self.emitter {
                    self.emitter.particlePositionRange = CGVector(dx: 5.0, dy: 5.0)
                    self.emitter.emissionAngle = 150.0 * CGFloat.pi / 180.0
                }
            })

            self.emitter.run(SKAction.sequence([moveAction, action, backAction, initAction]))

            let move1Action: SKAction = SKAction.move(to: CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY), duration: 0.5)
            let action1: SKAction = SKAction.customAction(withDuration: 0.5, actionBlock: { (node, elapsedTime) in
                if node === self.emitter {
                    self.emitter.particlePositionRange = CGVector(dx: 100.0, dy: self.emitter.particlePositionRange.dy * 2.0)
                    self.emitter.emissionAngle = 270.0 * CGFloat.pi / 180.0
                }
            })
            let back1Action: SKAction = SKAction.move(to: CGPoint(x: self.view!.bounds.width, y: 0), duration: 0.0)

            self.subEmitter.run(SKAction.sequence([move1Action, action1, back1Action]))
        }
    }
}
