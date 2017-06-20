//
//  UREffectCloudNode.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 31..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

enum UREffectCloudType: Int {
    case type01 = 1
    case type02 = 2
    case type03 = 3
    case type04 = 4

    var texture: SKTexture {
        let bundle = Bundle(for: UREffectCloudNode.self)
        switch self {
        case .type01:
            return SKTexture(image: UIImage(named: "cloud_01", in: bundle, compatibleWith: nil)!)
        case .type02:
            return SKTexture(image: UIImage(named: "cloud_02", in: bundle, compatibleWith: nil)!)
        case .type03:
            return SKTexture(image: UIImage(named: "cloud_03", in: bundle, compatibleWith: nil)!)
        case .type04:
            return SKTexture(image: UIImage(named: "cloud_04", in: bundle, compatibleWith: nil)!)
        }
    }
}

public struct UREffectCloudOption: UREffectOption {
    /// emittable AreaRatio
    var emittableArea: CGRect

    var movingAngle: CGFloat

    var textureScaleRatio: CGFloat = 0.3

    var movingDuration: TimeInterval = 5.0

    static let DefaultSpeedCoefficient: CGFloat = 0.01

//    var makingCount: UInt32 = 10
//    var isRandomCountInMax: Bool = true

    public init(_ emittableArea: CGRect, angleInDegree: CGFloat, scaleRatio: CGFloat = 0.3, movingDuration: TimeInterval = 5.0) {
        self.init(emittableArea, angleInRadian: angleInDegree.degreesToRadians, scaleRatio: scaleRatio, movingDuration: movingDuration)
    }

    public init(_ emittableArea: CGRect, angleInRadian: CGFloat, scaleRatio: CGFloat = 0.3, movingDuration: TimeInterval = 5.0) {
        self.emittableArea = emittableArea
        self.movingAngle = angleInRadian
        self.textureScaleRatio = scaleRatio
        self.movingDuration = movingDuration
//        self.maxCount = maxCount
//        self.isRandomCountInMax = isRandomCountInMax
    }
}

/// create a sprite node of cloud which texture is random
class UREffectCloudNode: SKSpriteNode {
    class func makeClouds(maxCount: UInt32, isRandomCountInMax: Bool, cloudOption option: UREffectCloudOption, on scene: SKView) -> [UREffectCloudNode] {
        return UREffectCloudNode.makeClouds(maxCount: maxCount, isRandomCountInMax: isRandomCountInMax, emittableAreaRatio: option.emittableArea, on: scene, movingAngleInRadian: option.movingAngle, movingDuration: option.movingDuration)
    }

    class func makeClouds(maxCount: UInt32, isRandomCountInMax: Bool, emittableAreaRatio area: CGRect, on scene: SKView, movingAngleInDegree: CGFloat, movingDuration: TimeInterval = 5.0) -> [UREffectCloudNode] {
        return UREffectCloudNode.makeClouds(maxCount: maxCount, isRandomCountInMax: isRandomCountInMax, emittableAreaRatio: area, on: scene, movingAngleInRadian: movingAngleInDegree.degreesToRadians)
    }

    class func makeClouds(maxCount: UInt32, isRandomCountInMax: Bool, emittableAreaRatio area: CGRect, on scene: SKView, movingAngleInRadian: CGFloat, movingDuration: TimeInterval = 5.0) -> [UREffectCloudNode] {
        var clouds: [UREffectCloudNode] = [UREffectCloudNode]()

        var realMakingCount: UInt32 = maxCount
        if isRandomCountInMax {
            let minMakingCount: UInt32 = UInt32(floor(Double(maxCount) * 0.6))
            realMakingCount = arc4random_uniform(maxCount)
            if realMakingCount < minMakingCount {
                realMakingCount = minMakingCount
            }
        }
        for i in 0 ..< realMakingCount {
            let rect: CGRect = CGRect(x: area.origin.x * scene.bounds.size.width, y: area.origin.y * scene.bounds.size.height, width: area.size.width * scene.bounds.size.width, height: area.size.height * scene.bounds.size.height)
            let cloud: UREffectCloudNode = UREffectCloudNode(rect, angleInRadian: movingAngleInRadian)
            cloud.name = "cloud\(i)"
            clouds.append(cloud)
        }

        return clouds
    }

    var cloudType: UREffectCloudType
    var option: UREffectCloudOption!
    var emittingPosition: CGPoint = .zero

    private override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.cloudType = UREffectCloudType(rawValue: Int(arc4random_uniform(3) + 1))!

        super.init(texture: self.cloudType.texture, color: .clear, size: self.cloudType.texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(_ emittableArea: CGRect, angleInDegree: CGFloat, textureScaleRatio: CGFloat = 0.3, movingDuration: TimeInterval = 5.0) {
        self.init(texture: nil, color: .clear, size: .zero)
        self.option = UREffectCloudOption(emittableArea, angleInDegree: angleInDegree, scaleRatio: textureScaleRatio, movingDuration: movingDuration)

        self.initNode()
    }

    convenience init(_ emittableArea: CGRect, angleInRadian: CGFloat, textureScaleRatio: CGFloat = 0.3, movingDuration: TimeInterval = 5.0) {
        self.init(texture: nil, color: .clear, size: .zero)
        self.option = UREffectCloudOption(emittableArea, angleInRadian: angleInRadian, scaleRatio: textureScaleRatio, movingDuration: movingDuration)

        self.initNode()
    }

    func initNode() {
        let rawSize: CGSize = self.cloudType.texture.size()
        let ratioAppliedSize: CGSize = CGSize(width: rawSize.width * self.option.textureScaleRatio, height: rawSize.height * self.option.textureScaleRatio)
        self.size = ratioAppliedSize

        let rangeX: CGFloat = self.option.emittableArea.origin.x + (CGFloat(arc4random_uniform(UInt32(self.option.emittableArea.width * 100.0))) / 100.0)
        let rangeY: CGFloat = self.option.emittableArea.origin.y + (CGFloat(arc4random_uniform(UInt32(self.option.emittableArea.height * 100.0))) / 100.0)
        self.emittingPosition = CGPoint(x: rangeX, y: rangeY)
        self.position = self.emittingPosition
    }

    func makeStreamingAction(isRepeat: Bool = false) {
        let actionFadeOut: SKAction = SKAction.fadeOut(withDuration: 0.0)

        let actionFadeIn: SKAction = SKAction.fadeIn(withDuration: 0.5)

        let speedCoefficient: CGFloat = CGFloat(arc4random_uniform(5) + 5) * UREffectCloudOption.DefaultSpeedCoefficient
        let actionMoveToDestination: SKAction = SKAction.move(to: self.destinationPoint, duration: self.option.movingDuration / Double(speedCoefficient * 10.0))

        actionMoveToDestination.speed = speedCoefficient
        let actionFadeOut2: SKAction = SKAction.fadeOut(withDuration: 0.5)

        if isRepeat {
            let startPoint: CGPoint = self.emittingPosition
            let actionMoveToStarting: SKAction = SKAction.move(to: startPoint, duration: 0.0)

            self.run(SKAction.repeatForever(SKAction.sequence([actionFadeOut, actionFadeIn, actionMoveToDestination, actionFadeOut2, actionMoveToStarting])))
        } else {
            let actionDestroy: SKAction = SKAction.run {
                self.removeFromParent()
            }

            self.run(SKAction.sequence([actionFadeOut, actionFadeIn, actionMoveToDestination, actionFadeOut2, actionDestroy]))
        }
    }

    var destinationPoint: CGPoint {
        let pointZeroAngleOnAxisY: CGPoint = CGPoint(x: self.emittingPosition.x + self.option.emittableArea.width, y: self.emittingPosition.y)
        let rotatedPoint: CGPoint = pointZeroAngleOnAxisY.rotateAround(point: self.emittingPosition, angle: self.option.movingAngle)

        return CGPoint(x: rotatedPoint.x + self.size.width * 0.2, y: rotatedPoint.y + self.size.height * 0.2)
    }
}

extension UREffectCloudNode: Comparable {
    open static func <(lhs: UREffectCloudNode, rhs: UREffectCloudNode) -> Bool {
        return lhs.emittingPosition.y < rhs.emittingPosition.y
    }

    open static func <=(lhs: UREffectCloudNode, rhs: UREffectCloudNode) -> Bool {
        return lhs.emittingPosition.y <= rhs.emittingPosition.y
    }

    open static func >=(lhs: UREffectCloudNode, rhs: UREffectCloudNode) -> Bool {
        return lhs.emittingPosition.y >= rhs.emittingPosition.y
    }

    open static func >(lhs: UREffectCloudNode, rhs: UREffectCloudNode) -> Bool {
        return lhs.emittingPosition.y > rhs.emittingPosition.y
    }
}
