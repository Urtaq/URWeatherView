//
//  URRGBToneCurveFilter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 7..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderRGBToneCurve: String = "URKernelShaderRGBToneCurve.cikernel.fsh"

open class URRGBToneCurveFilter: URFilter {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
         - frame: The frame rectangle for the input image, measured in points.
         - cgImage: Core Image of the input image
         - inputValues: attributes for CIKernel. The format is like below.
     
               [red: CIImage, green: CIImage, blue: CIImage, original: CIImage]
     */
    required public init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        super.init(frame: frame, cgImage: cgImage, inputValues: inputValues)

        self.loadCIColorKernel(from: URKernelShaderRGBToneCurve)

        guard inputValues.count == 4 else { return }
        self.customAttributes = inputValues
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - imageView: The UIImageView of the input image
        - inputValues: attributes for CIKernel. The format is like below.
     
              [red: CIImage, green: CIImage, blue: CIImage, original: CIImage]
     */
    required public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        super.init(frame: frame, imageView: imageView, inputValues: inputValues)

        self.loadCIColorKernel(from: URKernelShaderRGBToneCurve)

        guard inputValues.count >= 4 else { return }
        self.customAttributes = inputValues
    }

    override func applyFilter() -> CIImage {
        guard let resultImage: CIImage = (self.customKernel as! CIColorKernel).apply(withExtent: self.extent, arguments: self.customAttributes) else {
            fatalError("Filtered Image merging is failed!!")
        }

        return resultImage
    }
}
