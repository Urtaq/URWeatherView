//
//  UREffectLightningNode.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 26..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

/// the default is .topLeft
enum UREffectLigthningPosition {
    case `default`
    case topLeft
    case topCenter
    case topRight
    case centerLeft
    case centerRight
    case bottomLeft
    case bottomCenter
    case bottomRight

    var position: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: 0.0, y: 1.0)
        case .topCenter:
            return CGPoint(x: 0.5, y: 1.0)
        case .topRight:
            return CGPoint(x: 1.0, y: 1.0)
        case .centerLeft:
            return CGPoint(x: 0.0, y: 0.5)
        case .centerRight:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottomLeft:
            return CGPoint(x: 0.0, y: 0.0)
        case .bottomCenter:
            return CGPoint(x: 0.5, y: 0.0)
        case .bottomRight:
            return CGPoint(x: 1.0, y: 0.0)
        default:
            return CGPoint(x: 0.0, y: 1.0)
        }
    }
}

struct UREffectLightningOption {
    var timeIntervalBetweenLightning = 0.15

    var lightningLifetimeCoefficient = 0.1
    var lightningDisappeartime = 0.25

    var lineDrawDelay = 0.00275

    var lineThickness = 1.3

    // 0.0 - the bolt will be a straight line. >1.0 - the bolt will look unnatural
    let displaceCoefficient = 0.25

    // Make bigger if you want bigger line lenght and vice versa
    let lineRangeCoefficient = 1.8
}

class UREffectLigthningNode: SKSpriteNode {
    var option: UREffectLightningOption = UREffectLightningOption()

    private var _startPoint: CGPoint = .zero
    private var startPoint: CGPoint {
        get {
            return self._startPoint
        }
        set {
            self._startPoint = CGPoint(x: self.size.width * newValue.x, y: self.size.height * newValue.y)
        }
    }

    private var _endPoint: CGPoint = .zero
    private var endPoint: CGPoint {
        get {
            return self._endPoint
        }
        set {
            self._endPoint = CGPoint(x: self.size.width * newValue.x, y: self.size.height * newValue.y)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    convenience init(frame: CGRect, startPosition: UREffectLigthningPosition = .default, targetPosition: UREffectLigthningPosition = .bottomRight) {
        self.init(texture: nil, color: .clear, size: frame.size)
        self.anchorPoint = .zero
        self.position = frame.origin

        self.startPoint = startPosition.position
        self.endPoint = targetPosition.position
    }

    func startLightning(isInfinite: Bool = false) {
        let wait = SKAction.wait(forDuration: self.option.timeIntervalBetweenLightning)
        let addLightning = SKAction.run {
            self.addLightning()
        }

        // draw lightning
        if !isInfinite {
            self.run(SKAction.sequence([addLightning, wait]), withKey: "lightning")
        } else {
            self.run(SKAction.repeatForever(SKAction.sequence([addLightning, wait])), withKey: "lightning")
        }
    }

    func stopLightning() {
        self.removeAction(forKey: "lightning")
    }

    var bolts: [UREffectLightningBoltNode] = [UREffectLightningBoltNode]()
    func addLightning() {
        let mainBolt = UREffectLightningBoltNode(start: self.startPoint, end: self.endPoint)
        self.bolts.append(mainBolt)

        self.addChild(mainBolt)

        self.addLightningBranch(parentBolt: mainBolt)
    }

    func addLightningBranch(parentBolt: UREffectLightningBoltNode) {
        let numberOfBranches: Int = Int(arc4random_uniform(6))

        var branchPoints: [Double] = [Double](repeating: 0.0, count: numberOfBranches)
        for i in 0 ..< numberOfBranches {
            branchPoints[i] = drand48()
        }

        for branchPoint in branchPoints {
            guard let branchStartPoint: CGPoint = parentBolt.pointOnBoltPath(position: branchPoint) else { break }
            // 30도 각도 * (index % 2) == 0 ? 1 : -1 -> radian으로 바꿔서, z축 기준으로 회전을 얻어온 후, 메인 번개에 해당 브랜치 번개 시작점부터 종료점까지 회전을 적용해서 브랜치 번개의 종료 목표 CGPoint를 얻는다.
            // 시작 점과 종료 점으로 bolt를 추가로 생성한다.
            // self.bolts.append(branchBolt)
        }
    }
}
