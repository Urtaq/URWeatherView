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
                print("imageLayer before ====> \(imageLayer.contents!)")
                let cgImage = imageLayer.contents as! CGImage
                self.originals.rawImages.append(UIImage(cgImage: cgImage))

                var values = filterValues
                if let subValues = filterValuesSub, let imageName = imageLayerDic[kLOTAssetImageName] as? String, imageName != "img_0" && imageName != "img_5" {
                    values = subValues
                }
                let red = URToneCurveFilter(cgImage: cgImage, with: values["R"]!).outputImage!
                let green = URToneCurveFilter(cgImage: cgImage, with: values["G"]!).outputImage!
                let blue = URToneCurveFilter(cgImage: cgImage, with: values["B"]!).outputImage!

                self.filterColorTone(red: red, green: green, blue: blue, originImage: cgImage, imageLayer: imageLayer)
                print("imageLayer after  ====> \(imageLayer.contents!)")
            }

            self.testFilter(filterValues: filterValues, filterValuesSub: filterValuesSub)
        }
    }

    public func replaceLayer(_ targetLayer: CALayer, with cgImage: CGImage) {
        self.addRenewLayer(targetLayer, with: cgImage)

        targetLayer.removeFromSuperlayer()
    }

    func addRenewLayer(_ targetLayer: CALayer, with cgImage: CGImage) {
        guard let superLayer = targetLayer.superlayer else { return }
        let newLayer: CALayer = CALayer()
        newLayer.frame = targetLayer.frame
        newLayer.masksToBounds = targetLayer.masksToBounds
        newLayer.contents = cgImage
        superLayer.addSublayer(newLayer)
        superLayer.display()
    }

    public func removeToneCurveFilter() {
        if self.imageSolidLayers != nil {
            for (index, imageLayerDic) in self.imageSolidLayers.enumerated() {
                guard let imageLayer = imageLayerDic[kLOTImageSolidLayer] as? CALayer, imageLayer.contents != nil else { continue }
//                imageLayer.contents = self.originals.rawImages[index].cgImage
                self.replaceLayer(imageLayer, with: self.originals.rawImages[index].cgImage!)
            }
        }
    }

    /// test about CIKernel
    func testFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]? = nil) {

        for imageLayerDic in self.imageSolidLayers {
            guard let imageLayer = imageLayerDic[kLOTImageSolidLayer] as? CALayer, imageLayer.contents != nil else { continue }
            print("imageLayer before ====> \(imageLayer.contents!)")
            let cgImage = imageLayer.contents as! CGImage
            self.originals.rawImages.append(UIImage(cgImage: cgImage))

            let extent: CGRect = CGRect(origin: .zero, size: imageLayer.frame.size)

            let src: CISampler = CISampler(image: CIImage(cgImage: cgImage))

            let samplerROI = CGRect(x: 0, y: 0, width: imageLayer.frame.size.width, height: imageLayer.frame.size.height)
            let ROICallback: (Int32, CGRect) -> CGRect = { (samplerIndex, destination) in
                if samplerIndex == 2 {
                    return samplerROI
                }
                return destination
            }

            let shockParams: CIVector = CIVector(x: 10.0, y: 0.8, z: 0.1)
            let time: CGFloat = 2.0
            self.filterShockWaveDistortion(extent, sampler: src, ROICallback: ROICallback, center: CIVector(x: 0.5, y: 0.5), shockParams: shockParams, time: time, imageLayer: imageLayer)
            print("imageLayer after  ====> \(imageLayer.contents!)")
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
//        self.replaceLayer(imageLayer, with: resultCGImage)
        self.addRenewLayer(imageLayer, with: resultCGImage)
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
        self.addRenewLayer(imageLayer, with: resultCGImage)
        print(#function)
    }
}
