//
//  URToneCurveGraphView.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 11..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

fileprivate func < (left: CGPoint, right: CGPoint) -> Bool {
    return left.x < right.x
}

enum URToneCurveGraphControlMode {
    case prepared
    case custom
}

let DefaultToneCurveInputs: [CGPoint] = [.zero
    , CGPoint(x: 0.25, y: 0.25)
    , CGPoint(x: 0.5, y: 0.5)
    , CGPoint(x: 0.75, y: 0.75)
    , CGPoint(x: 1.0, y: 1.0)]

open class URToneCurveGraphView: UIView {
    enum URToneCurveColor {
        case `default`
        case red
        case green
        case blue
    }

    enum URToneCurveGraphDotPosition {
        case `default`
        case topLeft
        case topCenter
        case topRight
        case centerLeft
        case centerRight
        case bottomLeft
        case bottomCenter
        case bottomRight
    }

    class GraphDotView: UIView {
        var dotView: UIView!
        var dotPosition: URToneCurveGraphDotPosition = .default

        var relativeCenter: CGPoint {
            switch self.dotPosition {
            case .topLeft:
                return CGPoint(x: self.center.x + self.bounds.width / 2.0,   y: self.center.y + self.bounds.height / 2.0)
            case .topCenter:
                return CGPoint(x: self.center.x,                             y: self.center.y + self.bounds.height / 2.0)
            case .topRight:
                return CGPoint(x: self.center.x - self.bounds.width / 2.0,   y: self.center.y + self.bounds.height / 2.0)
            case .centerLeft:
                return CGPoint(x: self.center.x + self.bounds.width / 2.0,   y: self.center.y)
            case .centerRight:
                return CGPoint(x: self.center.x - self.bounds.width / 2.0,   y: self.center.y)
            case .bottomLeft:
                return CGPoint(x: self.center.x + self.bounds.width / 2.0,   y: self.center.y - self.bounds.height / 2.0)
            case .bottomCenter:
                return CGPoint(x: self.center.x,                             y: self.center.y - self.bounds.height / 2.0)
            case .bottomRight:
                return CGPoint(x: self.center.x - self.bounds.width / 2.0,   y: self.center.y - self.bounds.height / 2.0)
            default:
                return self.center
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)

            self.backgroundColor = UIColor.clear
            self.initView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func initView() {
            self.dotView = UIView()
            self.dotView.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            self.addSubview(self.dotView)
            self.dotView.translatesAutoresizingMaskIntoConstraints = false
        }

        func initDotConstraints() {
            self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.3, constant: 0.0))
            self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.3, constant: 0.0))

            switch self.dotPosition {
            case .topLeft:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            case .topCenter:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            case .topRight:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            case .centerLeft:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            case .centerRight:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            case .bottomLeft:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
            case .bottomCenter:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
            case .bottomRight:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
            default:
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                self.addConstraint(NSLayoutConstraint(item: self.dotView, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            }
        }

        func alignDot(centerPoint: CGPoint, position: URToneCurveGraphDotPosition = .default) {
            self.dotPosition = position

            switch self.dotPosition {
            case .topLeft:
                self.center = CGPoint(x: centerPoint.x - self.bounds.width / 2.0,   y: centerPoint.y - self.bounds.height / 2.0)
            case .topCenter:
                self.center = CGPoint(x: centerPoint.x,                             y: centerPoint.y - self.bounds.height / 2.0)
            case .topRight:
                self.center = CGPoint(x: centerPoint.x + self.bounds.width / 2.0,   y: centerPoint.y - self.bounds.height / 2.0)
            case .centerLeft:
                self.center = CGPoint(x: centerPoint.x - self.bounds.width / 2.0,   y: centerPoint.y)
            case .centerRight:
                self.center = CGPoint(x: centerPoint.x + self.bounds.width / 2.0,   y: centerPoint.y)
            case .bottomLeft:
                self.center = CGPoint(x: centerPoint.x - self.bounds.width / 2.0,   y: centerPoint.y + self.bounds.height / 2.0)
            case .bottomCenter:
                self.center = CGPoint(x: centerPoint.x,                             y: centerPoint.y + self.bounds.height / 2.0)
            case .bottomRight:
                self.center = CGPoint(x: centerPoint.x + self.bounds.width / 2.0,   y: centerPoint.y + self.bounds.height / 2.0)
            default:
                self.center = centerPoint
            }

            self.initDotConstraints()
        }
    }

    var controlMode: URToneCurveGraphControlMode = .prepared
    var rgbMode: URToneCurveColor = .default
    var isShowCurveArea: Bool = true {
        didSet {
            self.drawLine()
        }
    }
    var isShowAreaBetweenDots: Bool = true {
        didSet {
            self.drawLine()
        }
    }

    var tapGesture: UITapGestureRecognizer!
    var doubleTapGesture: UITapGestureRecognizer!

    var curveVectorDots: [GraphDotView] = [GraphDotView]()
    var curveVectorPoints: [CGPoint] {
        var points: [CGPoint] = [CGPoint]()

        points.append(CGPoint(x: 0, y: self.bounds.height))

        for view in self.curveVectorDots {
            points.append(view.center)
        }
        points.sort { $0 < $1 }

        points.append(CGPoint(x: self.bounds.width, y: 0))

        return points
    }
    var curveRelativeVectorPoints: [CGPoint] {
        var points: [CGPoint] = [CGPoint]()

        if self.curveVectorDots.count == 0 {
            points = DefaultToneCurveInputs
        } else {
            if self.rgbMode != .default {
                for (index, view) in self.curveVectorDots.enumerated() {
                    points.append(CGPoint(x: DefaultToneCurveInputs[index].x, y: 1 - (view.relativeCenter.y / self.bounds.height)))
                }
            } else {
                for view in self.curveVectorDots {
                    points.append(CGPoint(x: view.relativeCenter.x / self.bounds.width, y: 1 - (view.relativeCenter.y / self.bounds.height)))
                }
            }
            points.sort { $0 < $1 }
        }
        
        return points
    }

    var rulerLinesForAxisX: [CAShapeLayer]!
    var rulerLinesForAxisY: [CAShapeLayer]!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initView()
    }

    func initView() {
//        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)

        self.initGestures()
    }

    func initGestures() {
        if self.controlMode == .custom {
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            self.addGestureRecognizer(self.tapGesture)
        }

        self.doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        self.doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(self.doubleTapGesture)
    }

    func drawRulerLine() {
        self.layoutIfNeeded()

        let numberOfRulerLine: CGFloat = 4.0

        var index: CGFloat = 0.0

        if self.rulerLinesForAxisX != nil {
            for ruler in self.rulerLinesForAxisX {
                ruler.removeFromSuperlayer()
            }
        }
        self.rulerLinesForAxisX = [CAShapeLayer]()
        while index < numberOfRulerLine {
            let rulerLine: CAShapeLayer = CAShapeLayer()

            rulerLine.strokeColor = UIColor(white: 0.1, alpha: 0.2).cgColor
            rulerLine.lineWidth = 0.8
            rulerLine.fillColor = nil

            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: self.bounds.width / 4.0 * (index + 1.0), y: 0))
            linePath.addLine(to: CGPoint(x: self.bounds.width / 4.0 * (index + 1.0), y: self.bounds.height))

            rulerLine.path = linePath.cgPath
            rulerLine.drawsAsynchronously = true

            self.layer.addSublayer(rulerLine)
            self.rulerLinesForAxisX.append(rulerLine)

            index += 1
        }

        index = 0.0

        if self.rulerLinesForAxisY != nil {
            for ruler in self.rulerLinesForAxisY {
                ruler.removeFromSuperlayer()
            }
        }
        self.rulerLinesForAxisY = [CAShapeLayer]()
        while index < numberOfRulerLine {
            let rulerLine: CAShapeLayer = CAShapeLayer()
            self.layoutIfNeeded()

            rulerLine.strokeColor = UIColor(white: 0.1, alpha: 0.2).cgColor
            rulerLine.lineWidth = 1
            rulerLine.fillColor = nil

            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: 0, y: self.bounds.height / 4.0 * (index + 1.0)))
            linePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 4.0 * (index + 1.0)))

            rulerLine.path = linePath.cgPath
            rulerLine.drawsAsynchronously = true

            self.layer.addSublayer(rulerLine)
            self.rulerLinesForAxisY.append(rulerLine)
            
            index += 1
        }
    }

    var line: CAShapeLayer!
    var previousPoint: CGPoint = .zero
    var boundingRectangles: [URShapeLayer]! {
        didSet {
            let numberOfScope: Int = self.rulerLinesForAxisX.count

            if self.intersectedRectangles != nil {
                for rect in self.intersectedRectangles {
                    rect.removeFromSuperlayer()
                }
            }
            if self.boundingRectangles.count >= (numberOfScope + 2) {
                self.intersectedRectangles = [CAShapeLayer]()
                for rect in self.boundingRectangles {
                    for ruler in self.rulerLinesForAxisX {
                        let isIntersected: Bool = ruler.path!.isIntersectedRect(with: rect.path!.boundingBox)

                        if isIntersected {
                            let layer = self.drawRect(ruler.path!.intersectBounds(with: rect.path!.boundingBox), number: numberOfScope, isIntersected: true, customColor: rect.boundingBoxStyle.strokeColor, lineWidth: rect.boundingBoxStyle.lineWidth)
                            self.intersectedRectangles.append(layer)
                        }
                    }
                }
            }
        }
    }
    var intersectedRectangles: [CAShapeLayer]!
    func drawLine(_ withRuler: Bool = false, needToInit: Bool = false) {
        if let layer = self.line, let _ = layer.superlayer {
            self.line.removeFromSuperlayer()
            self.line = nil
        }

        self.line = CAShapeLayer()
        self.layoutIfNeeded()
//        self.line.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)

        switch self.rgbMode {
        case .red:
            self.line.strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.4).cgColor
        case .green:
            self.line.strokeColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.4).cgColor
        case .blue:
            self.line.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.4).cgColor
        default:
            self.line.strokeColor = UIColor(white: 0.1, alpha: 0.4).cgColor
        }
        self.line.lineWidth = 3
        self.line.fillColor = nil
        var linePath = UIBezierPath()
        if self.curveVectorDots.count > 0 {

            if self.boundingRectangles != nil {
                for layer in self.boundingRectangles {
                    layer.removeFromSuperlayer()
                }
            }
            self.boundingRectangles = [URShapeLayer]()

            if self.isShowAreaBetweenDots {
                for (index, point) in self.curveVectorPoints.enumerated() {
                    if index != 0 {
                        let boundingRectWidth: CGFloat = point.x - self.curveVectorPoints[index - 1].x
                        let boundingRectHeight: CGFloat = point.y - self.curveVectorPoints[index - 1].y

                        let rect: CGRect = CGRect(origin: self.curveVectorPoints[index - 1], size: CGSize(width: boundingRectWidth, height: boundingRectHeight))
                        let layer = self.drawRect(rect, number: index + 10)
                        layer.boundingBoxStyle = .forDots

                        self.boundingRectangles.append(layer)
                    }
                }
            }

            if let curvePath = UIBezierPath.interpolateCGPointsWithHermite(self.curveVectorPoints) {
                linePath = curvePath

//                linePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
//                linePath.addLine(to: CGPoint(x: 0, y: self.bounds.height))

                if self.isShowCurveArea {
                    let viewPointer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
                    linePath.cgPath.apply(info: viewPointer, function: { (info, pathElement) in

                        print("type is: \(pathElement.pointee.type.rawValue), point is: \(pathElement.pointee.points.pointee)")

                        let view = Unmanaged<URToneCurveGraphView>.fromOpaque(info!).takeUnretainedValue()
                        switch pathElement.pointee.type {
                        case .addCurveToPoint:
                            if view.previousPoint != .zero {
                                let boundingRectWidth: CGFloat = pathElement.pointee.points.pointee.x - view.previousPoint.x
                                let boundingRectHeight: CGFloat = pathElement.pointee.points.pointee.y - view.previousPoint.y

                                let layer = view.drawRect(CGRect(origin: view.previousPoint, size: CGSize(width: boundingRectWidth, height: boundingRectHeight)), number: view.boundingRectangles.count)
                                layer.boundingBoxStyle = .forCurves

                                view.boundingRectangles.append(layer)
                            }

                            view.previousPoint = pathElement.pointee.points.pointee
                        case .moveToPoint:
                            view.previousPoint = pathElement.pointee.points.pointee
                        default:
                            break
                        }
                        
                        print("apply")
                    })
                }
            }
        } else {
            linePath.move(to: CGPoint(x: 0, y: self.bounds.height))
            linePath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        }
        self.line.path = linePath.cgPath

        self.line.drawsAsynchronously = true

        self.layer.addSublayer(self.line)

        if withRuler {
            self.drawRulerLine()
            self.drawBasicLine()
        }

        if needToInit {
            if self.controlMode == .prepared {
                for point in DefaultToneCurveInputs {
                    self.drawDot(CGPoint(x: point.x * self.bounds.width, y: (1 - point.y) * self.bounds.height))
                }
            }
        }
    }

    func drawRect(_ rect: CGRect, number: Int, needLine: Bool = false, isIntersected: Bool = false, customColor: UIColor! = nil, lineWidth: CGFloat = 2.0) -> URShapeLayer {
        if needLine {
            let layer = URShapeLayer()

            let points: [CGPoint] = [rect.origin, self.curveVectorPoints[number], CGPoint(x: rect.maxX, y: rect.minY)]
            if let path = UIBezierPath.interpolateCGPointsWithHermite(points) {
                layer.path = path.cgPath
            }

            layer.strokeColor = UIColor(red: 0.1*CGFloat(number), green: 0.1*CGFloat(number), blue: 0.1*CGFloat(number), alpha: 0.5).cgColor
            layer.fillColor = nil
            layer.lineWidth = 2

            layer.drawsAsynchronously = true

            self.layer.addSublayer(layer)

            return layer
        } else {
            let layer = URShapeLayer()
            layer.path = UIBezierPath(rect: rect).cgPath

            if isIntersected {
                layer.strokeColor = customColor.cgColor
            } else {
                if number >= 10 {
                    layer.strokeColor = UIColor(red: 0.1*CGFloat(number % 10), green: 0.1, blue: 0.1, alpha: 0.5).cgColor
                } else {
                    layer.strokeColor = UIColor(red: 0.1*CGFloat(number), green: 0.1*CGFloat(number), blue: 0.1*CGFloat(number), alpha: 0.5).cgColor
                }
            }
            layer.fillColor = nil
            if isIntersected {
                layer.lineWidth = lineWidth
            } else {
                layer.lineWidth = 2
            }

            layer.drawsAsynchronously = true

            self.layer.addSublayer(layer)
            
            return layer
        }
    }

    var basicLine: CAShapeLayer!

    func drawBasicLine() {
        if self.basicLine != nil {
            self.basicLine.removeFromSuperlayer()
        }

        self.basicLine = CAShapeLayer()
        self.layoutIfNeeded()

        self.basicLine.strokeColor = UIColor(white: 0.1, alpha: 0.2).cgColor
        self.basicLine.lineWidth = 2
        self.basicLine.fillColor = nil

        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: self.bounds.height))
        linePath.addLine(to: CGPoint(x: self.bounds.width, y: 0))

//        linePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
//        linePath.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        self.basicLine.path = linePath.cgPath

        self.basicLine.drawsAsynchronously = true
        
        self.layer.addSublayer(self.basicLine)
    }

    func handleTap(_ gesture: UITapGestureRecognizer) {
        print(#function)

        defer {
            self.drawLine()
        }

        if gesture.state == .ended {
            let position: CGPoint = gesture.location(in: self)

            if self.curveVectorDots.count > 0 {
                for (index, dot) in self.curveVectorDots.enumerated() {
                    guard let _ = dot.hitTest(position, with: nil) else { continue }
                    dot.removeFromSuperview()
                    self.curveVectorDots.remove(at: index)
                    return
                }
            }

            if let path = self.line.path {
                let touchablePath: CGPath = path.copy(strokingWithWidth: 9.0, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: 5.0)

                if touchablePath.contains(position) && self.curveVectorDots.count < 5 {
                    print("line touched!!")

                    self.drawDot(position)
                }
            }
        }
    }

    func drawDot(_ position: CGPoint, needSave: Bool = true) {
        let dot: GraphDotView = GraphDotView(frame: CGRect(origin: position, size: CGSize(width: 24, height: 24)))
        if self.curveVectorDots.count == 0 {
            dot.alignDot(centerPoint: position, position: .topRight)
        } else if self.curveVectorDots.count == DefaultToneCurveInputs.count - 1 {
            dot.alignDot(centerPoint: position, position: .bottomLeft)
        } else {
            dot.alignDot(centerPoint: position)
        }

        if needSave {
            self.curveVectorDots.append(dot)
        }

        self.addSubview(dot)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        dot.addGestureRecognizer(panGesture)
    }

    func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        print(#function)

        defer {
            self.drawLine(true, needToInit: true)

            if let block = self.pointDidChanged {
                block()
            }
        }

        // remove dots
        for dot in self.curveVectorDots {
            dot.removeFromSuperview()
        }
        self.curveVectorDots.removeAll()

        // remove bounding rectangles
        if self.boundingRectangles != nil {
            for rectangle in self.boundingRectangles {
                rectangle.removeFromSuperlayer()
            }
            self.boundingRectangles.removeAll()
        }

        self.previousPoint = .zero

        if self.intersectedRectangles != nil {
            for rectangle in self.intersectedRectangles {
                rectangle.removeFromSuperlayer()
            }
            self.intersectedRectangles.removeAll()
        }
    }

    var preLocation: CGPoint = .zero
    var pointDidChanged: (() -> Void)?

    func handlePan(_ gesture: UIPanGestureRecognizer) {
        print(#function)

        var position: CGPoint = .zero

        defer {
            print(gesture.view!.frame.origin)
            self.drawLine()
        }

        switch gesture.state {
        case .began:
            self.preLocation = gesture.location(in: self)
            print("at the beginning : \(self.preLocation)")
        case .changed:
            let changedPosition: CGPoint = gesture.translation(in: self)
            print("at changing : \(changedPosition)")
            var origin: CGPoint = self.preLocation
            origin = CGPoint(x: origin.x + changedPosition.x, y: origin.y + changedPosition.y)

            guard let _ = self.hitTest(origin, with: nil) else { return }

            gesture.view!.center = origin

            // reset the bounding rectangle point
            self.previousPoint = .zero

            if let block = self.pointDidChanged {
                block()
            }
        case .ended, .cancelled, .failed:
            print("at the end")
        default:
            break
        }
    }
}

enum URBoundingBoxStyle {
    case forCurves
    case forDots

    var strokeColor: UIColor {
        switch self {
        case .forCurves:
            return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .forDots:
            return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        }
    }

    var lineWidth: CGFloat {
        switch self {
        case .forCurves:
            return 1.0
        case .forDots:
            return 2.0
        }
    }
}

class URShapeLayer: CAShapeLayer {
    var boundingBoxStyle: URBoundingBoxStyle = .forCurves
}
