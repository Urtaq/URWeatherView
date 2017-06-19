//
//  URFilterImageView.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

open class URFilterImageView: UIImageView, URFilterAppliable {
    open var originalImages: [UIImage]!
    open var effectTimer: Timer!

    var animationManager: URFilterAnimationManager!

    override open var image: UIImage? {
        didSet {
            if let effectLayers = self.layer.sublayers {
                for sublayer in effectLayers {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
}

extension URFilterAppliable where Self: URFilterImageView {
    public func applyBackgroundEffect(imageAssets: [UIImage], duration: TimeInterval, userInfo: [String: Any]! = nil) {
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

    public func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]! = DefaultToneCurveInputs, pointsForGreen: [CGPoint]! = DefaultToneCurveInputs, pointsForBlue: [CGPoint]! = DefaultToneCurveInputs) {
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

    public func applyToneCurveFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]? = nil) {

        if self.originalImages == nil {
            self.originalImages = [UIImage]()
            self.originalImages.append(self.image!)
        }

        let cgImage = self.image!.cgImage

        var values = filterValues
        let red = cgImage != nil ? URToneCurveFilter(cgImage: cgImage!, with: values["R"]!).outputImage! : URToneCurveFilter(ciImage: self.image!.ciImage!, with: values["R"]!).outputImage!
        let green = cgImage != nil ? URToneCurveFilter(cgImage: cgImage!, with: values["G"]!).outputImage! : URToneCurveFilter(ciImage: self.image!.ciImage!, with: values["G"]!).outputImage!
        let blue = cgImage != nil ? URToneCurveFilter(cgImage: cgImage!, with: values["B"]!).outputImage! : URToneCurveFilter(ciImage: self.image!.ciImage!, with: values["B"]!).outputImage!

        let rgbFilter = URRGBToneCurveFilter(frame: red.extent, imageView: self, inputValues: [red, green, blue, cgImage != nil ? CIImage(cgImage: cgImage!) : self.image!.ciImage!])
        self.image = UIImage(cgImage: rgbFilter.outputCGImage!)
    }

    public func removeToneCurveFilter() {
        guard self.originalImages != nil else { return }
        self.image = self.originalImages[0]
    }

    public func applyDistortionFilter() {
        if self.originalImages == nil {
            self.originalImages = [UIImage]()
            self.originalImages.append(self.image!)
        }

        let cgImage = self.image!.cgImage

        let extent: CGRect = CGRect(origin: .zero, size: self.image!.size)

        let src: CISampler = (cgImage != nil) ? CISampler(image: CIImage(cgImage: cgImage!)) : CISampler(image: self.image!.ciImage!)

        self.animationManager = URFilterAnimationManager(duration: 0.8, fireBlock: { (progress) in
            let filter = URWaveWarpFilter(frame: extent, cgImage: cgImage!, inputValues: [src, progress, 0.2, 0.3, 8.0], roiRatio: 0.8)
            self.image = UIImage(ciImage: filter.outputImage!)
        })
        self.animationManager.isRepeatForever = true
        self.animationManager.play()
    }

    public func stop(_ completion: (() -> Void)?) {
        if self.animationManager != nil {
            self.animationManager.stop(completion)
        }

        guard let block = completion else { return }
        block()
    }
}

extension UIImageView {
    public func makeGradientMask(startPoint: CGPoint, endPoint: CGPoint, locations: [CGFloat]) -> CALayer {
        self.layoutIfNeeded()
        let screenScale = UIScreen.main.scale
        let selfBounds = self.bounds

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = screenScale
        gradientLayer.contentsScale = screenScale
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: selfBounds.width, height: selfBounds.height * (startPoint.y + 0.5))
//        gradientLayer.bounds = CGRect(origin: .zero, size: CGSize(width: self.bounds.width * screenScale, height: self.bounds.height * screenScale))

        var colors: [CGColor] = [CGColor]()
        for location in locations {
            colors.append(UIColor(white: 0.0, alpha: 1.0 - location).cgColor)
        }

        gradientLayer.locations = locations as [NSNumber]
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        return gradientLayer
    }

    public func applyGradientMask(startPoint: CGPoint, endPoint: CGPoint, locations: [CGFloat]) -> UIImage? {
        let gradientMask = self.makeGradientMask(startPoint: startPoint, endPoint: endPoint, locations: locations)

        self.layer.mask = gradientMask
        
        return self.image
    }

    public func removeGradientMask() {
        if let mask = self.layer.mask, mask is CAGradientLayer {
            self.layer.mask = nil
        }
    }
}
