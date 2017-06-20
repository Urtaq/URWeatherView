//
//  URFrostedGlassFilter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 8..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderkFrostedGlass: String = "URKernelShaderFrostedGlass.cikernel.fsh"

open class URFrostedGlassFilter: URFilter {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - cgImage: Core Image of the input image
        - inputValues: attributes for CIKernel. The format is like below.
     
              [sampler: CISampler, center: CIVector, progress: TimeInterval]
     */
    required public init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        super.init(frame: frame, cgImage: cgImage, inputValues: inputValues)

        self.loadCIKernel(from: URKernelShaderkFrostedGlass)

        guard inputValues.count == 3 else { return }
        self.customAttributes = inputValues
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - imageView: The UIImageView of the input image
        - inputValues: attributes for CIKernel. The format is like below.

              [sampler: CISampler, center: CIVector, progress: TimeInterval]
     */
    required public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        super.init(frame: frame, imageView: imageView, inputValues: inputValues)

        self.loadCIKernel(from: URKernelShaderkFrostedGlass)

        guard inputValues.count == 3 else { return }
        self.customAttributes = inputValues
    }

    override func applyFilter() -> CIImage {
        let samplerROI = CGRect(x: 0, y: 0, width: self.inputImage!.extent.width, height: self.inputImage!.extent.height)
        let ROICallback: (Int32, CGRect) -> CGRect = { (samplerIndex, destination) in
            if samplerIndex == 2 {
                return samplerROI
            }
            return destination
        }
        guard let resultImage: CIImage = self.customKernel?.apply(withExtent: self.extent, roiCallback: ROICallback, arguments: self.customAttributes) else {
            fatalError("Filtered Image merging is failed!!")
        }
        
        return resultImage
    }
}
