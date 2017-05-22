//
//  LOTAnimationView+Filter.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 19..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Lottie

class URLOTAnimationView: LOTAnimationView, URToneCurveAppliable {
    var originalImages: [UIImage]!
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

extension URToneCurveAppliable where Self: LOTAnimationView {
    var originals: URRawImages {
        guard let originals = objc_getAssociatedObject(self, &AssociatedKey.extensionAddress) as? URRawImages else {
            let originals: URRawImages = URRawImages()
            objc_setAssociatedObject(self, &AssociatedKey.extensionAddress, originals, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return originals
        }

        return originals
    }

    func applyToneCurveFilter(filterValues: [String: [CGPoint]]) {
        if self.imageSolidLayers != nil {
//            if self.rawImages == nil {
//                self.rawImages = [UIImage]() as NSArray
//            }
            for imageLayer in self.imageSolidLayers {
                guard imageLayer.contents != nil else { continue }
                print("imageLayer before ====> \(imageLayer.contents!)")
                let cgImage = imageLayer.contents as! CGImage
//                self.originalImages[self.originalImages.count] = UIImage(cgImage: cgImage)
                self.originals.rawImages.append(UIImage(cgImage: cgImage))
//                self.originals.rawImages[self.originalImages.count] = UIImage(cgImage: cgImage)

                let red = URToneCurveFilter(cgImage: cgImage, with: filterValues["R"]!).outputImage!
                let green = URToneCurveFilter(cgImage: cgImage, with: filterValues["G"]!).outputImage!
                let blue = URToneCurveFilter(cgImage: cgImage, with: filterValues["B"]!).outputImage!

                guard let resultImage: CIImage = URToneCurveFilter.colorKernel.apply(withExtent: red.extent, arguments: [red, green, blue]) else {
                    return
                }

                let context = CIContext(options: nil)
                guard let resultCGImage = context.createCGImage(resultImage, from: resultImage.extent) else {
                    fatalError("Not able to make CGImage of the result Filtered Image!!")
                }
                imageLayer.contents = resultCGImage
                print("imageLayer after  ====> \(imageLayer.contents!)")
//                break
            }
        }
    }

    func removeToneCurveFilter() {
        if self.imageSolidLayers != nil {
            let tx = self.originals.rawImages
            print(tx)
            for (index, imageLayer) in self.imageSolidLayers.enumerated() {
                guard imageLayer.contents != nil else { continue }
                imageLayer.contents = self.originals.rawImages[index].cgImage
                print("\(self.originals.rawImages[index].cgImage!)")
            }
        }
    }
}
