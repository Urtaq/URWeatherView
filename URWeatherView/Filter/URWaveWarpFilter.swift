//
//  URWaveWarpFilter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 8..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderkWaveWarp: String = "URKernelShaderWaveWarp.cikernel.fsh"

open class URWaveWarpFilter: URFilter {
    var roiRatio: CGFloat = 1.0

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required public init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        fatalError("init(frame:cgImage:inputValues:) has not been implemented")
    }

    required public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        fatalError("init(frame:imageView:inputValues:) has not been implemented")
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - cgImage: Core Image of the input image
        - inputValues: attributes for CIKernel. The format is like below.

              [sampler: CISampler, progress: TimeInterval, velocity: Double, wRatio: Double, hRatio: Double]
        - roiRatio: Rect area ratio of Interest.
     */
    public init(frame: CGRect, cgImage: CGImage, inputValues: [Any], roiRatio: CGFloat = 1.0) {
        super.init(frame: frame, cgImage: cgImage, inputValues: inputValues)

        self.roiRatio = roiRatio

        self.loadCIKernel(from: URKernelShaderkWaveWarp)

        guard inputValues.count == 5 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(Double.pi)
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - imageView: The UIImageView of the input image
        - inputValues: attributes for CIKernel. The format is like below.
     
              [sampler: CISampler, progress: TimeInterval, velocity: Double, wRatio: Double, hRatio: Double]
        - roiRatio: Rect area ratio of Interest.
     */
    public init(frame: CGRect, imageView: UIImageView, inputValues: [Any], roiRatio: CGFloat = 1.0) {
        super.init(frame: frame, imageView: imageView, inputValues: inputValues)

        self.roiRatio = roiRatio

        self.loadCIKernel(from: URKernelShaderkWaveWarp)

        guard inputValues.count == 5 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(Double.pi)
    }

    override func applyFilter() -> CIImage {
//        let inputWidth: CGFloat = self.inputImage!.extent.size.width;

//        let k: CGFloat = inputWidth / ( 1.0 - 1.0 / UIScreen.main.scale )
//        let center: CGFloat = self.inputImage!.extent.origin.x + inputWidth / 2.0;

        let samplerROI = CGRect(x: 0, y: 0, width: self.inputImage!.extent.width, height: self.inputImage!.extent.height)
        let ROICallback: (Int32, CGRect) -> CGRect = { (samplerIndex, destination) in
            if samplerIndex == 1 {
                return samplerROI
            }
//            let destROI: CGRect = self.region(of: destination, center: center, k: k)
//            return destROI
            return destination
        }
        guard let resultImage: CIImage = self.customKernel?.apply(withExtent: self.extent, roiCallback: ROICallback, arguments: self.customAttributes) else {
            fatalError("Filtered Image merging is failed!!")
        }
        
        return resultImage
    }
}
