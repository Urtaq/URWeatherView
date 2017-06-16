//
//  UIBezierPath+Interpolation.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 11..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

extension UIBezierPath {
    /// not consider the closed path
    class func interpolateCGPointsWithHermite(_ points: [CGPoint]) -> UIBezierPath? {
        guard points.count >= 2 else { return nil }

        let numberOfCurves: Int = points.count - 1

        let path: UIBezierPath = UIBezierPath()
        var curPoint: CGPoint = .zero
        var prevPoint: CGPoint = .zero
        var nextPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        for (index, _) in points.enumerated() {
            curPoint = points[index]

            if index == 0 {
                path.move(to: curPoint)
            }

            var nextIndex: Int = (index+1) % points.count
            var prevIndex: Int = (index - 1 < 0 ? points.count - 1 : index - 1)

            prevPoint = points[prevIndex]
            nextPoint = points[nextIndex]
            endPoint = nextPoint

            let controlPoint1: CGPoint = controlPoint(curPoint, prev: prevPoint, next: nextPoint, at: 1, when: index > 0)

            curPoint = points[nextIndex]

            nextIndex = (nextIndex + 1) % points.count
            prevIndex = index

            prevPoint = points[prevIndex]
            nextPoint = points[nextIndex]

            let controlPoint2: CGPoint = controlPoint(curPoint, prev: prevPoint, next: nextPoint, at: 2, when: index < (numberOfCurves - 1))

            path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)

            if (index + 1) >= numberOfCurves {
                break
            }
        }

        return path
    }

    class func controlPoint(_ curPoint: CGPoint, prev prevPoint: CGPoint, next nextPoint: CGPoint, at index: Int, when condition: Bool) -> CGPoint {

        var mx: CGFloat = 0.0
        var my: CGFloat = 0.0

        switch index {
        case 1:
            if condition {
                mx = (nextPoint.x - curPoint.x) * 0.5 + (curPoint.x - prevPoint.x) * 0.5
                my = (nextPoint.y - curPoint.y) * 0.5 + (curPoint.y - prevPoint.y) * 0.5
            } else {
                mx = (nextPoint.x - curPoint.x) * 0.5
                my = (nextPoint.y - curPoint.y) * 0.5
            }
            return CGPoint(x: curPoint.x + mx / 3.0, y: curPoint.y + my / 3.0)
        case 2:
            if condition {
                mx = (nextPoint.x - curPoint.x) * 0.5 + (curPoint.x - prevPoint.x) * 0.5
                my = (nextPoint.y - curPoint.y) * 0.5 + (curPoint.y - prevPoint.y) * 0.5
            } else {
                mx = (curPoint.x - prevPoint.x) * 0.5
                my = (curPoint.y - prevPoint.y) * 0.5
            }
            return CGPoint(x: curPoint.x - mx / 3.0, y: curPoint.y - my / 3.0)
        default:
            return .zero
        }
    }
}

extension CGPath {
    func intersectBounds(with other: CGRect) -> CGRect {
        var rawBoundingBox: CGRect = self.boundingBox
        if rawBoundingBox.width == 0.0 {
            rawBoundingBox.size.width = 1.0
        }
        if rawBoundingBox.height == 0.0 {
            rawBoundingBox.size.height = 1.0
        }
        
        var intersectionRect: CGRect = rawBoundingBox.intersection(other)
        if intersectionRect == .null {
            return .zero
        }

        if intersectionRect.width == 0.0 {
            intersectionRect.size.width = 1.0
        }
        if intersectionRect.height == 0.0 {
            intersectionRect.size.height = 1.0
        }
        return intersectionRect
    }

    func isIntersectedRect(with other: CGRect) -> Bool {
        let intersecttionBounds = self.intersectBounds(with: other)

        if intersecttionBounds == .zero {
            return false
        } else {
            return true
        }
    }
}
