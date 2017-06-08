//
//  LOTAnimationView+Filter.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 19..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Lottie

public class URLOTAnimationView: LOTAnimationView, URFilterAppliable {
    public var originalImages: [UIImage]!
    public var effectTimer: Timer!
}

struct AssociatedKey {
    static var extensionAddress: UInt8 = 0
}

class URRawImages: NSObject {
    var rawImages: [UIImage]

    override init() {
        self.rawImages = [UIImage]()
        super.init()
    }
}

extension URFilterAppliable where Self: LOTAnimationView {
    var originals: URRawImages {
        guard let originals = objc_getAssociatedObject(self, &AssociatedKey.extensionAddress) as? URRawImages else {
            let originals: URRawImages = URRawImages()
            objc_setAssociatedObject(self, &AssociatedKey.extensionAddress, originals, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return originals
        }

        return originals
    }

    public func applyToneCurveFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]? = nil) {
        if self.imageSolidLayers != nil {
            for imageLayerDic in self.imageSolidLayers {
                guard let imageLayer = imageLayerDic[kLOTImageSolidLayer] as? CALayer, imageLayer.contents != nil else { continue }
                let cgImage = imageLayer.contents as! CGImage
                self.originals.rawImages.append(UIImage(cgImage: cgImage))

                var values = filterValues
                if let subValues = filterValuesSub, let imageName = imageLayerDic[kLOTAssetImageName] as? String, imageName != "img_0" && imageName != "img_5" {
                    values = subValues
                }
                let red = URToneCurveFilter(cgImage: cgImage, with: values["R"]!).outputImage!
                let green = URToneCurveFilter(cgImage: cgImage, with: values["G"]!).outputImage!
                let blue = URToneCurveFilter(cgImage: cgImage, with: values["B"]!).outputImage!

//                self.filterColorTone(red: red, green: green, blue: blue, originImage: cgImage, imageLayer: imageLayer)
                let rgbFilter = URRGBToneCurveFilter(frame: red.extent, cgImage: cgImage, inputValues: [red, green, blue, CIImage(cgImage: cgImage)])
                imageLayer.contents = rgbFilter.outputCGImage!
            }

//            self.testFilter(filterValues: filterValues, filterValuesSub: filterValuesSub)
        }
    }

    public func removeToneCurveFilter() {
        if self.imageSolidLayers != nil {
            for (index, imageLayerDic) in self.imageSolidLayers.enumerated() {
                guard let imageLayer = imageLayerDic[kLOTImageSolidLayer] as? CALayer, imageLayer.contents != nil else { continue }
                imageLayer.contents = self.originals.rawImages[index].cgImage
            }
        }
    }

    /// test about CIKernel
    func testFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]? = nil) {

        for imageLayerDic in self.imageSolidLayers {
            guard let imageLayer = imageLayerDic[kLOTImageSolidLayer] as? CALayer, imageLayer.contents != nil else { continue }
            let cgImage = imageLayer.contents as! CGImage
            self.originals.rawImages.append(UIImage(cgImage: cgImage))

            let extent: CGRect = CGRect(origin: .zero, size: imageLayer.frame.size)

            let src: CISampler = CISampler(image: CIImage(cgImage: cgImage))

            _ = URFilterAnimationManager(duration: 0.8, startTime: CACurrentMediaTime(), fireBlock: { (progress) in
                let shockWaveFilter = URShockWaveFilter(frame: extent, cgImage: cgImage, inputValues: [src, CIVector(x: 0.5, y: 0.5), progress])
                imageLayer.contents = shockWaveFilter.outputCGImage
            })
        }
    }

    public func applyFilterEffect(_ filterKernel: CIColorKernel, extent: CGRect, arguments: [Any], imageLayer: CALayer!) {
        guard let resultImage: CIImage = filterKernel.apply(withExtent: extent, arguments: arguments) else {
            fatalError("Filtered Image merging is failed!!")
        }

        let context = CIContext(options: nil)
        guard let resultCGImage = context.createCGImage(resultImage, from: resultImage.extent) else {
            fatalError("Not able to make CGImage of the result Filtered Image!!")
        }
        imageLayer.contents = resultCGImage
    }

    public func applyFilterEffect(_ filterKernel: CIKernel, extent: CGRect, roiCallback: @escaping CIKernelROICallback, arguments: [Any], imageLayer: CALayer!) {
        guard let resultImage: CIImage = filterKernel.apply(withExtent: extent, roiCallback: roiCallback, arguments: arguments) else {
            fatalError("Filtered Image merging is failed!!")
        }

        let context = CIContext(options: nil)
        guard let resultCGImage = context.createCGImage(resultImage, from: resultImage.extent) else {
            fatalError("Not able to make CGImage of the result Filtered Image!!")
        }
        imageLayer.contents = resultCGImage
    }
}
