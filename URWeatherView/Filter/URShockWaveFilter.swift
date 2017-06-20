//
//  URShockWaveFilter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 8..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderShockWave: String = "URKernelShaderShockWave.cikernel.fsh"

open class URShockWaveFilter: URFilter {

    let shockParams: CIVector = CIVector(x: 10.0, y: 0.8, z: 0.1)

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - cgImage: Core Image of the input image
        - inputValues: attributes for CIKernel. The format is like below.

              [sampler: CISampler, center: CIVector, progress: TimeInterval, shocksParams: CIVector]
    */
    required public init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        super.init(frame: frame, cgImage: cgImage, inputValues: inputValues)

        self.loadCIKernel(from: URKernelShaderShockWave)

        guard inputValues.count == 3 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(self.shockParams)
    }

    /**
     Initialize CIFilter with **UIImageView** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - imageView: The UIImageView of the input image
        - inputValues: attributes for CIKernel. The format is like below.

              [sampler: CISampler, center: CIVector, progress: TimeInterval, shocksParams: CIVector]
     */
    required public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        super.init(frame: frame, imageView: imageView, inputValues: inputValues)

        self.loadCIKernel(from: URKernelShaderShockWave)

        guard inputValues.count == 3 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(self.shockParams)
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
