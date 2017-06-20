//
//  LOTAnimationView+Filter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 19..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import LottieEx

open class URLOTAnimationView: LOTAnimationView, URFilterAppliable {
    open var originalImages: [UIImage]!
    open var effectTimer: Timer!
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

extension URFilterAppliable where Self: URLOTAnimationView {
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

                let rgbFilter = URRGBToneCurveFilter(frame: red.extent, cgImage: cgImage, inputValues: [red, green, blue, CIImage(cgImage: cgImage)])
                imageLayer.contents = rgbFilter.outputCGImage!
            }
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

    public func applyDistortionFilter() {

        for imageLayerDic in self.imageSolidLayers {
            guard let imageLayer = imageLayerDic[kLOTImageSolidLayer] as? CALayer, imageLayer.contents != nil else { continue }
            let cgImage = imageLayer.contents as! CGImage
            self.originals.rawImages.append(UIImage(cgImage: cgImage))

            let extent: CGRect = CGRect(origin: .zero, size: imageLayer.frame.size)

            let src: CISampler = CISampler(image: CIImage(cgImage: cgImage))

            _ = URFilterAnimationManager(duration: 4.0, startTime: CACurrentMediaTime(), fireBlock: { (progress) in
                let filter = URWaveWarpFilter(frame: extent, cgImage: cgImage, inputValues: [src, progress, 0.2, 0.3, 0.625], roiRatio: 0.8)
                imageLayer.contents = filter.outputCGImage
            })
        }
    }
}
