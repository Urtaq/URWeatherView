//
//  URToneCurveImageView.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class URToneCurveImageView: UIImageView, URToneCurveAppliable {
    var originalImages: [UIImage]!
    var effectTimer: Timer!

    override var image: UIImage? {
        didSet {
            if let effectLayers = self.layer.sublayers {
                for sublayer in effectLayers {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
}

extension URToneCurveAppliable where Self: UIImageView {
    func applyBackgroundEffect(imageAssets: [UIImage], duration: TimeInterval, userInfo: [String: Any]! = nil) {
        guard imageAssets.count >= 2 else { return }
        let layer1: CALayer = CALayer()
        layer1.frame = self.bounds
        layer1.contents = imageAssets[0].cgImage

        self.layer.addSublayer(layer1)

        let layer2: CALayer = CALayer()
        layer2.frame = self.bounds
        layer2.contents = imageAssets[1].cgImage
        layer2.opacity = 0.0

        self.layer.addSublayer(layer2)

        let invisibleOpacity = 0.0
        let visibleOpacity = 1.0

        let times = userInfo["times"] as! [NSNumber]

        var values: [Double] = [Double]()
        for i in 0 ..< times.count {
            if (i != 0) && ((i + 1) % 3 == 0) {
                values.append(invisibleOpacity)
                values.append(visibleOpacity)
                values.append(invisibleOpacity)
            }
        }

        let blinkAnimation = CAKeyframeAnimation(keyPath: "opacity")
        blinkAnimation.values = values
        blinkAnimation.keyTimes = times as [NSNumber]
        blinkAnimation.duration = duration
        blinkAnimation.repeatCount = .infinity

        layer2.add(blinkAnimation, forKey: nil)
    }

    func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]! = DefaultToneCurveInputs, pointsForGreen: [CGPoint]! = DefaultToneCurveInputs, pointsForBlue: [CGPoint]! = DefaultToneCurveInputs) {
        if self.originalImages == nil {
            self.originalImages = [UIImage]()
            self.originalImages.append(self.image!)
        }

        var filter = URToneCurveFilter(imageView: self, with: curvePoints)
        filter.extractInputImage(self.originalImages[0])

        let filteredImage = filter.outputImage!

        var arguments: [CIImage] = [CIImage]()
        arguments.append(CIImage(image: self.originalImages[0])!)
        if !(pointsForRed == DefaultToneCurveInputs
            && pointsForGreen == DefaultToneCurveInputs
            && pointsForBlue == DefaultToneCurveInputs) {
            var filteredImageForRed: CIImage!
            if let points = pointsForRed, points != DefaultToneCurveInputs {
                filter = URToneCurveFilter(curvePoints: points)
                filter.extractInputImage(self.originalImages[0])

                filteredImageForRed = filter.outputImage!
            } else {
                filteredImageForRed = filter.inputImage
            }
            arguments.append(filteredImageForRed)

            var filteredImageForGreen: CIImage!
            if let points = pointsForGreen, points != DefaultToneCurveInputs {
                filter = URToneCurveFilter(curvePoints: points)
                filter.extractInputImage(self.originalImages[0])

                filteredImageForGreen = filter.outputImage!
            } else {
                filteredImageForGreen = filter.inputImage
            }
            arguments.append(filteredImageForGreen)

            var filteredImageForBlue: CIImage!
            if let points = pointsForBlue, points != DefaultToneCurveInputs {
                filter = URToneCurveFilter(curvePoints: points)
                filter.extractInputImage(self.originalImages[0])

                filteredImageForBlue = filter.outputImage!
            } else {
                filteredImageForBlue = filter.inputImage
            }
            arguments.append(filteredImageForBlue)
        }

        if arguments.count == 4 {
            guard let resultImage: CIImage = URToneCurveFilter.colorKernel.apply(withExtent: filteredImage.extent, arguments: arguments) else {
                fatalError("Filtered Image merging is failed!!")
            }

            self.image = UIImage(ciImage: resultImage)
        } else {
            self.image = UIImage(ciImage: filteredImage)
        }
    }

    func applyToneCurveFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]? = nil) {
        if self.originalImages == nil {
            self.originalImages = [UIImage]()
            self.originalImages.append(self.image!)
        }

        let cgImage = self.image!.cgImage!

        var values = filterValues
        let red = URToneCurveFilter(cgImage: cgImage, with: values["R"]!).outputImage!
        let green = URToneCurveFilter(cgImage: cgImage, with: values["G"]!).outputImage!
        let blue = URToneCurveFilter(cgImage: cgImage, with: values["B"]!).outputImage!

//        guard let resultImage: CIImage = URToneCurveFilter.colorKernel.apply(withExtent: red.extent, arguments: [red, green, blue, CIImage(cgImage: cgImage)]) else {
        let src: CISampler = CISampler(image: CIImage(cgImage: cgImage))
        let center: CIVector = CIVector(x: 0.5, y: 0.5)
        let radius: CIVector = CIVector(x: 0.5, y: 2.0)
        let color: CIColor = CIColor(red: 0.23, green: 0.56, blue: 0.34, alpha: 0.82)
        print("center : \(center), radius: \(radius)")
        let samplerROI = CGRect(x: 0, y: 0, width: red.extent.width, height: red.extent.height)
        let ROICallback: (Int32, CGRect) -> CGRect = { (samplerIndex, destination) in
            if samplerIndex == 2 {
                return samplerROI
            }
            return destination
        }

//        guard let resultImage: CIImage = URToneCurveFilter.kernel.apply(withExtent: red.extent, roiCallback: ROICallback, arguments: [src, 0.5]) else {
        guard let resultImage: CIImage = URToneCurveFilter.holeDistortionKernel.apply(withExtent: red.extent, roiCallback: ROICallback, arguments: [src, center, radius]) else {
//        guard let resultImage: CIImage = URToneCurveFilter.multiplyKernel.apply(withExtent: red.extent, roiCallback: ROICallback, arguments: [src, color]) else {
            fatalError("Filtered Image merging is failed!!")
        }

        self.image = UIImage(ciImage: resultImage)
    }

    func removeToneCurveFilter() {
        self.image = self.originalImages[0]
    }
}

