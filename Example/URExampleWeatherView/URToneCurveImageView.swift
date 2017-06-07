//
//  URToneCurveImageView.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class URToneCurveImageView: UIImageView, URFilterAppliable {
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

extension URFilterAppliable where Self: UIImageView {
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
            let rgbFilter = URRGBToneCurveFilter(frame: filteredImage.extent, imageView: self, inputValues: arguments)

            self.image = UIImage(ciImage: rgbFilter.outputImage!)
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

//        self.filterColorTone(red: red, green: green, blue: blue, originImage: cgImage)
        let rgbFilter = URRGBToneCurveFilter(frame: red.extent, imageView: self, inputValues: [red, green, blue, CIImage(cgImage: cgImage)])
        self.image = UIImage(ciImage: rgbFilter.outputImage!)

        self.testFilter()
    }

    func removeToneCurveFilter() {
        self.image = self.originalImages[0]
    }

    /// test about CIKernel
    func testFilter() {
        if self.originalImages == nil {
            self.originalImages = [UIImage]()
            self.originalImages.append(self.image!)
        }

        let cgImage = self.image!.cgImage

        let extent: CGRect = CGRect(origin: .zero, size: self.image!.size)

        let src: CISampler = (cgImage != nil) ? CISampler(image: CIImage(cgImage: cgImage!)) : CISampler(image: self.image!.ciImage!)

        let samplerROI = CGRect(x: 0, y: 0, width: self.image!.size.width, height: self.image!.size.height)
        let ROICallback: (Int32, CGRect) -> CGRect = { (samplerIndex, destination) in
            if samplerIndex == 2 {
                return samplerROI
            }
            return destination
        }

//        self.filterBrighten(extent, sampler: src, ROICallback: ROICallback, bright: 0.5)
//
//        let color: CIColor = CIColor(red: 0.23, green: 0.56, blue: 0.34, alpha: 0.82)
//        self.filterMutiply(extent, sampler: src, ROICallback: ROICallback, color: color)

//        let center: CIVector = CIVector(x: 250.5, y: 300.5)
//        let radius: CIVector = CIVector(x: 1.0 / 100.0, y: 100.0)
//        self.filterHoleDistortion(extent, sampler: src, ROICallback: ROICallback, center: center, radius: radius)

//        let center: CIVector = CIVector(x: 200.5, y: 100.5)
//        let radiusF: CGFloat = 200.0
//        let angle: CGFloat = 0.8
//        let time: CGFloat = 0.3
//        self.filterSwirlDistortion(extent, sampler: src, ROICallback: ROICallback, center: center, radius: radiusF, angle: angle, time: time)

        let shockParams: CIVector = CIVector(x: 10.0, y: 0.8, z: 0.1)
        let time: CGFloat = 2.0
        self.filterShockWaveDistortion(extent, sampler: src, ROICallback: ROICallback, center: CIVector(x: 0.5, y: 0.5), shockParams: shockParams, time: time)
    }

    func applyFilterEffect(_ filterKernel: CIColorKernel, extent: CGRect, arguments: [Any], imageLayer: CALayer! = nil) {
        guard let resultImage: CIImage = filterKernel.apply(withExtent: extent, arguments: arguments) else {
            fatalError("Filtered Image merging is failed!!")
        }

        self.image = UIImage(ciImage: resultImage)
    }

    func applyFilterEffect(_ filterKernel: CIKernel, extent: CGRect, roiCallback: @escaping CIKernelROICallback, arguments: [Any], imageLayer: CALayer! = nil) {
        guard let resultImage: CIImage = filterKernel.apply(withExtent: extent, roiCallback: roiCallback, arguments: arguments) else {
            fatalError("Filtered Image merging is failed!!")
        }

        self.image = UIImage(ciImage: resultImage)
    }
}
