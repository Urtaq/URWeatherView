//
//  ToneCurveGraphView.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 11..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class ToneCurveGraphView: UIView {
    var tapGesture: UITapGestureRecognizer!
    var doubleTapGesture: UITapGestureRecognizer!

    var curveVectorDots: [UIView] = [UIView]()
    var curveVectorPoints: [CGPoint] {
        var points: [CGPoint] = [CGPoint]()

        points.append(CGPoint(x: 0, y: self.bounds.height))

        for view in self.curveVectorDots {
            points.append(view.frame.origin)
        }

        points.append(CGPoint(x: self.bounds.width, y: 0))

        return points
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initView()
    }

    func initView() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)

        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(self.tapGesture)

        self.doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        self.doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(self.doubleTapGesture)
    }

    var line: CAShapeLayer!

    func drawLine() {
        if let layer = self.line, let _ = layer.superlayer {
            self.line.removeFromSuperlayer()
            self.line = nil
        }

        self.line = CAShapeLayer()
        self.layoutIfNeeded()
        self.line.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)

        self.line.strokeColor = UIColor(white: 0.1, alpha: 0.4).cgColor
        self.line.lineWidth = 3
        self.line.fillColor = nil
        var linePath = UIBezierPath()
        if self.curveVectorDots.count > 0 {
//            for dot in self.curveVectorDots {
//                linePath.addLine(to: dot.frame.origin)
//            }
            if let curvePath = UIBezierPath.interpolateCGPointsWithHermite(self.curveVectorPoints) {
                linePath = curvePath
            }
        } else {
            linePath.move(to: CGPoint(x: 0, y: self.bounds.height))
            linePath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        }
        self.line.path = linePath.cgPath

        self.line.drawsAsynchronously = true

        self.layer.addSublayer(self.line)
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

    func drawDot(_ position: CGPoint) {
        let dot: UIView = UIView()
        dot.frame = CGRect(origin: position, size: CGSize(width: 10, height: 10))
        dot.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        self.curveVectorDots.append(dot)

        self.addSubview(dot)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        dot.addGestureRecognizer(panGesture)
    }

    func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        print(#function)

        defer {
            self.drawLine()
        }

        for dot in self.curveVectorDots {
            dot.removeFromSuperview()
        }
        self.curveVectorDots.removeAll()
    }

    var preLocation: CGPoint = .zero

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

            gesture.view!.frame.origin = origin
        case .ended, .cancelled, .failed:
            //
            print("at the end")
        default:
            break
        }
    }
}
