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
    case dust2      = "MyParticleDust2.sks"
    case comet      = "MyParticleBurningComet.sks"
    case lightning  = "0"
    case shiny      = "1"
    case hot        = "2"
    case smoke      = "MyParticleSmoke.sks"
    case none       = "None"

    static let all: [URWeatherType] = [.snow,
                                       .rain,
                                       .dust,
                                       .dust2,
                                       .comet,
                                       .lightning,
                                       .shiny,
                                       .hot,
                                       .smoke]

    var name: String {
        switch self {
        case .snow:
            return "Snow"
        case .rain:
            return "Rain"
        case .dust:
            return "Dust"
        case .dust2:
            return "Dust2"
        case .comet:
            return "Comet"
        case .lightning:
            return "Lightning"
        case .shiny:
            return "Shiny"
        case .hot:
            return "Hot"
        case .smoke:
            return "Smoke"
        default:
            return ""
        }
    }

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

    var imageFilterValues: [String: [CGPoint]]? {
        switch self {
        case .snow:
            let r: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.0875816794002757),
                                CGPoint(x: 0.5, y: 0.202614339192708),
                                CGPoint(x: 0.75, y: 0.571241850011489),
                                CGPoint(x: 1.0, y: 1.0)]
            let g: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.206535967658548),
                                CGPoint(x: 0.5, y: 0.5),
                                CGPoint(x: 0.75, y: 0.945098039215686),
                                CGPoint(x: 1.0, y: 1.0)]
            let b: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.454902020622702),
                                CGPoint(x: 0.5, y: 0.903268013748468),
                                CGPoint(x: 0.75, y: 0.972549019607843),
                                CGPoint(x: 1.0, y: 1.0)]
            return ["R": r,
                    "G": g,
                    "B": b
            ]
        case .hot:
            let r: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.281045771580116),
                                CGPoint(x: 0.5, y: 0.596078431372549),
                                CGPoint(x: 0.75, y: 0.920261457854626),
                                CGPoint(x: 1.0, y: 1.0)]
            let g: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.25),
                                CGPoint(x: 0.5, y: 0.5),
                                CGPoint(x: 0.75, y: 0.75),
                                CGPoint(x: 1.0, y: 1.0)]
            let b: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.25),
                                CGPoint(x: 0.5, y: 0.5),
                                CGPoint(x: 0.75, y: 0.75),
                                CGPoint(x: 1.0, y: 1.0)]
            return ["R": r,
                    "G": g,
                    "B": b
            ]
        default:
            return nil
        }
    }

    var imageFilterValuesSub: [String: [CGPoint]]? {
        switch self {
        case .snow:
            let r: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.20392160851971),
                                CGPoint(x: 0.5, y: 0.377777757831648),
                                CGPoint(x: 0.75, y: 0.670588235294118),
                                CGPoint(x: 1.0, y: 1.0)]
            let g: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.277124183006536),
                                CGPoint(x: 0.5, y: 0.5),
                                CGPoint(x: 0.75, y: 0.81437908496732),
                                CGPoint(x: 1.0, y: 1.0)]
            let b: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                CGPoint(x: 0.25, y: 0.491503287919986),
                                CGPoint(x: 0.5, y: 0.709803961460886),
                                CGPoint(x: 0.75, y: 0.958169914694393),
                                CGPoint(x: 1.0, y: 1.0)]
            return ["R": r,
                    "G": g,
                    "B": b
            ]
        default:
            return nil
        }
    }

    var backgroundImage: UIImage? {
        switch self {
        case .snow:
            return #imageLiteral(resourceName: "snow")
        case .rain:
            return #imageLiteral(resourceName: "rain")
        case .dust:
            return #imageLiteral(resourceName: "yellowDust2")
        case .dust2:
            return #imageLiteral(resourceName: "dustFrame")
        default:
            return nil
        }
    }

    var startBirthRate: CGFloat? {
        switch self {
        case .dust:
            return 15.0
        case .dust2:
            return 3.0
        default:
            return nil
        }
    }

    var defaultBirthRate: CGFloat {
        switch self {
        case .snow:
            return 40.0
        case .rain:
            return 150.0
        case .dust, .dust2, .smoke:
            return 200.0
        case .comet:
            return 455.0
        default:
            return 50.0
        }
    }

    var maxBirthRate: CGFloat {
        switch self {
        case .snow:
            return 500.0
        case .rain:
            return 1500.0
        case .dust, .dust2:
            return 300.0
        default:
            return 300.0
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let _ = self.groundEmitter else { return }
            self.groundEmitter.particleBirthRate = rate / 2.0
        }
    }

    var particleColor: UIColor!
//    func setParticleColor(_ color: UIColor) {
//        if self.emitter != nil {
//            self.emitter.particleColorSequence?.setKeyframeValue(color, for: 0)
//        }
//    }

    func makeScene(weather: URWeatherType = .shiny) {
        let node = SKLightNode(fileNamed: "MyScene.sks")

        self.addChild(node!)

        guard let block = self.extraEffectBlock else { return }
        block(self.weatherType.backgroundImage)
    }

    func startScene(_ weather: URWeatherType = .snow) {
        self.weatherType = weather

        switch weather {
        case .shiny, .lightning, .hot:
            self.makeScene(weather: weather)
        default:
            self.startEmitter(weather: weather)
        }
    }

    func startEmitter(weather: URWeatherType = .snow) {
        self.emitter = SKEmitterNode(fileNamed: weather.rawValue)

        var particlePositionRangeX: CGFloat = self.view!.bounds.width
        if self.weatherType == .rain {
            particlePositionRangeX *= 2.0
        }
        switch self.weatherType {
        case .snow:
            self.emitter.particlePositionRange = CGVector(dx: particlePositionRangeX, dy: 0)
            self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.height)
            self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { (timer) in
                if self.emitter.particleBirthRate <= 40.0 {
                    if self.emitter.xAcceleration == -10 {
                        self.emitter.xAcceleration = 10
                    } else {
                        self.emitter.xAcceleration = -10
                    }
                } else {
                    self.emitter.xAcceleration = 0
                }
            })
        case .comet:
            self.emitter.position = CGPoint(x: 0, y: self.view!.bounds.height)
            self.subEmitter = SKEmitterNode(fileNamed: weatherType.rawValue)

            self.subEmitter.position = CGPoint(x: self.view!.bounds.width, y: 0)
            self.subEmitter.emissionAngle = 330.0 * CGFloat.pi / 180.0
            self.subEmitter.yAcceleration = -100

            self.subEmitter.targetNode = self
            self.addChild(self.subEmitter)
        case .dust, .dust2:
            if let startBirthRate = self.weatherType.startBirthRate {
                self.emitter.particleBirthRate = startBirthRate
            }

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
        default:
            self.emitter.particlePositionRange = CGVector(dx: particlePositionRangeX, dy: 0)
            self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.height)
        }
        self.emitter.targetNode = self

        if self.particleColor != nil {
            self.emitter.particleColorSequence?.setKeyframeValue(self.particleColor, for: 0)
        }
        self.addChild(self.emitter)

        self.enableDebugOptions(needToShow: self.isGraphicsDebugOptionEnabled)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
        self.particleColor = nil

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
