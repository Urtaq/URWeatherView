//
//  URWeatherScene.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 24..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

/// weather type enumeration & each type's the setting options
public enum URWeatherType: String {
    case snow       = "MyParticleSnow.sks"
    case rain       = "MyParticleRain.sks"
    case dust       = "MyParticleDust.sks"
    case dust2      = "MyParticleDust2.sks"
    case lightning  = "0"
    case hot        = "1"
    case cloudy     = "2"
    case shiny      = "3"
    case comet      = "MyParticleBurningComet.sks"
    case smoke      = "MyParticleSmoke.sks"
    case none       = "None"

    public static let all: [URWeatherType] = [.snow,
                                       .rain,
                                       .dust,
                                       .dust2,
                                       .lightning,
                                       .hot,
                                       .cloudy,
                                       .comet
//                                       .shiny,
//                                       .smoke
    ]

    public var name: String {
        switch self {
        case .snow:
            return "Snow"
        case .rain:
            return "Rain"
        case .dust:
            return "Dust"
        case .dust2:
            return "Dust2"
        case .lightning:
            return "Lightning"
        case .hot:
            return "Hot"
        case .cloudy:
            return "Cloudy"
        case .shiny:
            return "Shiny"
        case .comet:
            return "Comet"
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

    public var imageFilterValues: [String: [CGPoint]]? {
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

    public var imageFilterValuesSub: [String: [CGPoint]]? {
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

    public var backgroundImage: UIImage? {
        let bundle = Bundle(for: URWeatherScene.self)
        switch self {
        case .dust:
            return UIImage(named: "yellowDust2", in: bundle, compatibleWith: nil)!
        case .dust2:
            return UIImage(named: "dustFrame", in: bundle, compatibleWith: nil)!
        case .lightning:
            return UIImage(named: "darkCloud_00000", in: bundle, compatibleWith: nil)!
        case .hot:
            return UIImage(named: "sunHot", in: bundle, compatibleWith: nil)!
        default:
            return nil
        }
    }

    public var backgroundImageOpacity: CGFloat {
        switch self {
        case .hot:
            return 0.85
        default:
            return 1.0
        }
    }

    public var startBirthRate: CGFloat? {
        switch self {
        case .dust:
            return 15.0
        case .dust2:
            return 3.0
        default:
            return nil
        }
    }

    public var defaultBirthRate: CGFloat {
        switch self {
        case .snow:
            return 40.0
        case .rain:
            return 150.0
        case .dust, .dust2, .smoke:
            return 200.0
        case .cloudy:
            return 10.0
        case .comet:
            return 455.0
        default:
            return 50.0
        }
    }

    public var maxBirthRate: CGFloat {
        switch self {
        case .snow:
            return 500.0
        case .rain:
            return 1500.0
        case .dust, .dust2:
            return 300.0
        case .cloudy:
            return 30.0
        default:
            return 300.0
        }
    }
}

enum URWeatherGroundType: String {
    case snow       = "MyParticleSnowGround.sks"
    case rain       = "MyParticleRainGround.sks"
    case none       = "None"

    var delayTime: TimeInterval {
        switch self {
        case .snow:
            return 2.0
        case .rain:
            return 2.0
        default:
            return 2.0
        }
    }
}

public struct URWeatherGroundEmitterOption {
    var position: CGPoint
    var rangeRatio: CGFloat = 0.117
    var angle: CGFloat

    public init(position: CGPoint, rangeRatio: CGFloat = 0.117, degree: CGFloat = -29.0) {
        self.position = position
        self.rangeRatio = rangeRatio
        self.angle = degree.degreesToRadians
    }

    public init(position: CGPoint, rangeRatio: CGFloat = 0.117, radian: CGFloat) {
        self.position = position
        self.rangeRatio = rangeRatio
        self.angle = radian
    }
}

public let URWeatherKeyCloudOption: String     = "URWeatherCloudOption"
public let URWeatherKeyLightningOption: String = "URWeatherLightningOption"

open class URWeatherScene: SKScene, URNodeMovable {
    fileprivate var emitter: SKEmitterNode!
    fileprivate var subEmitter: SKEmitterNode!
    fileprivate var groundEmitter: SKEmitterNode!
    fileprivate var subGroundEmitters: [SKEmitterNode]!
    open var subGroundEmitterOptions: [URWeatherGroundEmitterOption]! {
        didSet {
            self.stopGroundEmitter()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.startGroundEmitter()
            }
        }
    }

    private lazy var timers: [Timer] = [Timer]()

    open var weatherType: URWeatherType = .none
    var particleColor: UIColor!
    open var isGraphicsDebugOptionEnabled: Bool = false

    open var extraEffectBlock: ((UIImage?, CGFloat) -> Void)?

    var lastLocation: CGPoint = .zero {
        didSet {
            self.updateNodePosition()
        }
    }
    var touchedNode: SKNode!
    lazy var movableNodes: [SKNode] = [SKNode]()

    override public init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// switch the SpriteKit debug options
    open func enableDebugOptions(needToShow: Bool) {
        self.isGraphicsDebugOptionEnabled = needToShow
        guard self.emitter != nil else { return }

        self.view!.showsFPS = self.isGraphicsDebugOptionEnabled
        self.view!.showsNodeCount = self.isGraphicsDebugOptionEnabled
        self.view!.showsFields = self.isGraphicsDebugOptionEnabled
        self.view!.showsPhysics = self.isGraphicsDebugOptionEnabled
        self.view!.showsDrawCount = self.isGraphicsDebugOptionEnabled
    }

    /// setter of the particle birth rate
    open var birthRate: CGFloat = 0.0 {
        didSet {
            if self.emitter != nil {
                self.emitter.particleBirthRate = self.birthRate

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if self.groundEmitter != nil {
                        self.groundEmitter.particleBirthRate = self.birthRate / 2.0
                    }

                    guard let _ = self.subGroundEmitters, self.subGroundEmitters.count > 0 else { return }
                    for subGroundEmitter in self.subGroundEmitters {
                        subGroundEmitter.particleBirthRate = self.birthRate / 13.0
                    }
                }
            }
        }
    }

    /// draw the lightnings
    func drawLightningEffect(isDirectionInvertable: Bool = false) {
        var lightningNode: UREffectLigthningNode
        var lightningNode2: UREffectLigthningNode
        if isDirectionInvertable {
            lightningNode = UREffectLigthningNode(frame: CGRect(origin: CGPoint(x: self.size.width * 0.34, y: self.size.height * 0.568), size: CGSize(width: self.size.width * 0.35, height: self.size.height * 0.432)),
                                                  startPosition: UREffectLigthningPosition.topRight,
                                                  targetPosition: UREffectLigthningPosition.bottomLeft)
            lightningNode2 = UREffectLigthningNode(frame: CGRect(origin: CGPoint(x: self.size.width * 0.34, y: self.size.height * 0.568), size: CGSize(width: self.size.width * 0.35, height: self.size.height * 0.432)),
                                                   startPosition: UREffectLigthningPosition.topRight,
                                                   targetPosition: UREffectLigthningPosition.bottomLeft)
        } else {
            lightningNode = UREffectLigthningNode(frame: CGRect(origin: CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.600), size: CGSize(width: self.size.width * 0.39, height: self.size.height * 0.400)),
                                                  startPosition: UREffectLigthningPosition.topLeft,
                                                  targetPosition: UREffectLigthningPosition.bottomRight)
            lightningNode2 = UREffectLigthningNode(frame: CGRect(origin: CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.600), size: CGSize(width: self.size.width * 0.39, height: self.size.height * 0.400)),
                                                   startPosition: UREffectLigthningPosition.topLeft,
                                                   targetPosition: UREffectLigthningPosition.bottomRight)
        }

        self.addChild(lightningNode)
        self.addChild(lightningNode2)
        lightningNode.startLightning()
        lightningNode2.startLightning()
    }

    open func makeLightningBackgroundEffect(imageView: UIImageView) -> [UIImage] {
        let cgImage = imageView.image!.cgImage!

        var rgb: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                              CGPoint(x: 0.311631917953491, y: 0.177777817670037),
                              CGPoint(x: 0.512152751286825, y: 0.624836641199449),
                              CGPoint(x: 0.730902751286825, y: 0.997385660807292),
                              CGPoint(x: 1.0, y: 1.0)]

        let foreCGImage = URToneCurveFilter(cgImage: cgImage, with: rgb).outputCGImage!

        rgb =               [CGPoint(x: 0.0998263756434123, y: 0.0),
                             CGPoint(x: 0.467013875643412, y: 0.0549019607843138),
                             CGPoint(x: 0.714409708976746, y: 0.159477144129136),
                             CGPoint(x: 0.885416666666667, y: 0.355555575501685),
                             CGPoint(x: 1.0, y: 0.661437928442862)]

        let backCGImage = URToneCurveFilter(cgImage: cgImage, with: rgb).outputCGImage!

        return [UIImage(cgImage: backCGImage), UIImage(cgImage: foreCGImage)]
    }

    /// draw clouds
    func drawCloudEffect(duration: TimeInterval, interval: TimeInterval = 0.0, index: Int) {
        var cloudNodes: [UREffectCloudNode] = [UREffectCloudNode]()

        let makeAction = SKAction.run {
            cloudNodes = UREffectCloudNode.makeClouds(maxCount: UInt32(self.birthRate), isRandomCountInMax: true, emittableAreaRatio: CGRect(x: -0.8, y: -0.2, width: 1.7, height: 0.3), on: self.view!, movingAngleInDegree: 30.0, movingDuration: duration)
            cloudNodes = cloudNodes.sorted(by: >)

            for cloudNode in cloudNodes {
                self.addChild(cloudNode)

                cloudNode.makeStreamingAction()
            }
        }
        let waitAction = SKAction.wait(forDuration: duration * 2.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.run(SKAction.repeatForever(SKAction.sequence([makeAction, waitAction])), withKey: self.weatherType.name + "\(index)")
        }
    }

    /// draw clouds
    func drawCloudEffect(cloudOption option: UREffectCloudOption, interval: TimeInterval = 0.0, index: Int) {
        var cloudNodes: [UREffectCloudNode] = [UREffectCloudNode]()

        let makeAction = SKAction.run {
            cloudNodes = UREffectCloudNode.makeClouds(maxCount: UInt32(self.birthRate), isRandomCountInMax: true, cloudOption: option, on: self.view!)
            cloudNodes = cloudNodes.sorted(by: >)

            for cloudNode in cloudNodes {
                self.addChild(cloudNode)

                cloudNode.makeStreamingAction()
            }
        }
        let waitAction = SKAction.wait(forDuration: option.movingDuration * 2.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.run(SKAction.repeatForever(SKAction.sequence([makeAction, waitAction])), withKey: self.weatherType.name + "\(index)")
        }
    }

    /// make the weather effect scene
    func makeScene(weather: URWeatherType = .shiny, duration: TimeInterval = 0.0, showTimes times: [Double]! = nil, userInfo: [String: UREffectOption]! = nil) {
        switch weather {
        case .lightning:
            var actions = [SKAction]()
            for (index, time) in times.enumerated() {
                var waiting: SKAction
                if index == 0 {
                    waiting = SKAction.wait(forDuration: duration * time)
                } else {
                    waiting = SKAction.wait(forDuration: duration * (time - times[index - 1]))
                }
                let drawLightning: SKAction = SKAction.run {
                    self.drawLightningEffect(isDirectionInvertable: Double(index) >= (Double(times.count) / 2.0))
                }
                actions.append(waiting)
                actions.append(drawLightning)

                if index == times.count - 1 {
                    let waitingForFinish = SKAction.wait(forDuration: duration * (1.0 - time))
                    actions.append(waitingForFinish)
                }
            }
            self.run(SKAction.repeatForever(SKAction.sequence(actions)), withKey: weather.name)
        case .cloudy:
//            self.drawCloudEffect(duration: duration, interval: 0.0, index: 1)
//            self.drawCloudEffect(duration: duration, interval: duration + 0.5, index: 2)

            if let option = userInfo[URWeatherKeyCloudOption] as? UREffectCloudOption {
                self.drawCloudEffect(cloudOption: option, index: 1)
                self.drawCloudEffect(cloudOption: option, interval: option.movingDuration, index: 2)
            }
        default:
            break
        }
    }

    /// start the whole weather scene
    open func startScene(_ weather: URWeatherType = .snow, duration: TimeInterval = 0.0, showTimes times: [Double]! = nil, userInfo: [String: UREffectOption]! = nil) {
        self.weatherType = weather

        switch weather {
        case .lightning, .hot, .cloudy, .shiny:
            self.makeScene(weather: weather, duration: duration, showTimes: times, userInfo: userInfo)
        default:
            self.startEmitter(weather: weather)
        }

        guard let block = self.extraEffectBlock else { return }
        block(self.weatherType.backgroundImage, self.weatherType.backgroundImageOpacity)
    }

    /// start the particle effects by the weather type
    func startEmitter(weather: URWeatherType = .snow) {
        self.emitter = SKEmitterNode(fileNamed: weather.rawValue)

        var particlePositionRangeX: CGFloat = self.view!.bounds.width
        if self.weatherType == .rain {
            particlePositionRangeX *= 2.0
        }
        switch self.weatherType {
        case .snow:
            if self.emitter == nil {
                self.emitter = URSnowEmitterNode()
            }
            self.emitter.particlePositionRange = CGVector(dx: particlePositionRangeX, dy: 0)
            self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.height)
            let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeXAcceleration), userInfo: nil, repeats: true)
            self.timers.append(timer)
        case .rain:
            if self.emitter == nil {
                self.emitter = URRainEmitterNode()
            }
            self.emitter.particlePositionRange = CGVector(dx: particlePositionRangeX, dy: 0)
            self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.height)
        case .dust, .dust2:
            if self.emitter == nil {
                if self.weatherType == .dust {
                    self.emitter = URDustEmitterNode()
                } else if self.weatherType == .dust2 {
                    self.emitter = URDust2EmitterNode()
                }
            }
            if let startBirthRate = self.weatherType.startBirthRate {
                self.emitter.particleBirthRate = startBirthRate
            }

            self.emitter.particlePositionRange = CGVector(dx: particlePositionRangeX, dy: self.view!.bounds.height)
            self.emitter.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY)
            let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeXAcceleration), userInfo: nil, repeats: true)
            self.timers.append(timer)

//            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        case .comet:
            if self.emitter == nil {
                self.emitter = URBurningCometEmitterNode()
            }
            self.emitter.position = CGPoint(x: 0, y: self.view!.bounds.height)
            self.subEmitter = SKEmitterNode(fileNamed: weatherType.rawValue)
            if self.subEmitter == nil {
                self.subEmitter = URBurningCometEmitterNode()
            }

            self.subEmitter.position = CGPoint(x: self.view!.bounds.width, y: 0)
            self.subEmitter.emissionAngle = 330.0 * CGFloat.pi / 180.0
            self.subEmitter.yAcceleration = -100

            self.subEmitter.targetNode = self
            self.addChild(self.subEmitter)
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.startGroundEmitter()
        }
    }

    @objc private func changeXAcceleration() {
        switch self.weatherType {
        case .snow:
            if self.emitter.particleBirthRate <= 40.0 {
                if self.emitter.xAcceleration == -3 {
                    self.emitter.xAcceleration = 3
                } else {
                    self.emitter.xAcceleration = -3
                }
            } else {
                self.emitter.xAcceleration = 0
            }
        case .dust, .dust2:
            if self.emitter.yAcceleration == -10 {
                self.emitter.yAcceleration = 10
            } else {
                self.emitter.yAcceleration = -10
            }
        default:
            break
        }
    }

    /// start the particle effect around ground
    func startGroundEmitter() {
        switch self.weatherType {
        case .snow:
            self.subGroundEmitters = [SKEmitterNode]()
            for i in 0 ..< self.subGroundEmitterOptions.count {
                let subGroundEmitter = URSnowGroundEmitterNode()

                subGroundEmitter.particlePositionRange = CGVector(dx: self.size.width * self.subGroundEmitterOptions[i].rangeRatio, dy: subGroundEmitter.particlePositionRange.dy)
                subGroundEmitter.position = self.subGroundEmitterOptions[i].position
                subGroundEmitter.targetNode = self
                subGroundEmitter.particleBirthRate = self.emitter.particleBirthRate / 13.0
                subGroundEmitter.zRotation = CGFloat(30.0).degreesToRadians
                subGroundEmitter.numParticlesToEmit = 0

                self.insertChild(subGroundEmitter, at: 0)

                subGroundEmitter.run(SKAction.rotate(toAngle: self.subGroundEmitterOptions[i].angle, duration: 0.0))

                self.subGroundEmitters.insert(subGroundEmitter, at: 0)
            }
        case .rain:
            self.groundEmitter = URRainGroundEmitterNode()
            self.groundEmitter.particleScaleRange = 0.2

            self.subGroundEmitters = [SKEmitterNode]()
            for i in 0 ..< self.subGroundEmitterOptions.count {
                let subGroundEmitter = URRainGroundEmitterNode()

                subGroundEmitter.particlePositionRange = CGVector(dx: self.size.width * self.subGroundEmitterOptions[i].rangeRatio, dy: 7.5)
                subGroundEmitter.position = self.subGroundEmitterOptions[i].position
                subGroundEmitter.targetNode = self
                subGroundEmitter.particleBirthRate = self.emitter.particleBirthRate / 13.0

                self.insertChild(subGroundEmitter, at: 0)

                subGroundEmitter.run(SKAction.rotate(toAngle: self.subGroundEmitterOptions[i].angle, duration: 0.0))

                self.subGroundEmitters.insert(subGroundEmitter, at: 0)
            }
        default:
            self.groundEmitter = nil
            self.subGroundEmitters = nil
        }

        guard self.groundEmitter != nil else { return }

        self.groundEmitter.particlePositionRange = CGVector(dx: self.view!.bounds.width, dy: 0)
        self.groundEmitter.position = CGPoint(x: self.view!.bounds.midX, y: 5)
        self.groundEmitter.targetNode = self
        self.groundEmitter.particleBirthRate = self.emitter.particleBirthRate / 2.0

        self.insertChild(self.groundEmitter, at: 0)
    }

    /// remove the whole scene
    open func stopScene() {
        self.weatherType = .none
        self.particleColor = nil

        for weather in URWeatherType.all {
            self.removeAction(forKey: weather.name)

            if weather == .cloudy {
                self.removeAction(forKey: weather.name + "1")
                self.removeAction(forKey: weather.name + "2")

                self.removeAllActions()
            }
        }

        for subNode in self.children {
            subNode.removeFromParent()
        }

        guard let _ = self.emitter else { return }

        self.emitter.particleBirthRate = 0.0
        self.emitter.targetNode = nil

        self.emitter = nil

        self.enableDebugOptions(needToShow: false)

        self.stopGroundEmitter()

        for timer in self.timers {
            timer.invalidate()
        }
        self.backgroundColor = .clear
    }

    /// remove the particle effects around ground
    func stopGroundEmitter() {
        if self.groundEmitter != nil {
            self.groundEmitter.particleBirthRate = 0.0
            self.groundEmitter.targetNode = nil
            self.groundEmitter.removeFromParent()

            self.groundEmitter = nil
        }

        guard self.subGroundEmitters != nil else { return }

        for subGroundEmitter in self.subGroundEmitters {
            subGroundEmitter.particleBirthRate = 0.0
            subGroundEmitter.targetNode = nil
            subGroundEmitter.removeFromParent()
        }

        self.subGroundEmitters.removeAll()
        self.subGroundEmitters = nil
    }
}

extension URWeatherScene {

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.weatherType == .cloudy {
            self.handleTouch(touches)
        }
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.weatherType == .cloudy {
            self.handleTouch(touches)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.weatherType == .cloudy {
            self.handleTouch(touches, isEnded: true)
        } else if self.weatherType == .comet {
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
