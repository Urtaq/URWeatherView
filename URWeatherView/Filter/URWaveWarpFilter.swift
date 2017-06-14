//
//  URWaveWarpFilter.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 8..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderkWaveWarp: String = "URKernelShaderWaveWarp.cikernel"

open class URWaveWarpFilter: CIFilter, URFilter {
    var inputImage: CIImage?
    var customKernel: CIKernel?
    /// [sampler: CISampler, progress: TimeInterval, velocity: Double, wRatio: Double, hRatio: Double]
    var customAttributes: [Any]?

    var extent: CGRect = .zero

    var roiRatio: CGFloat = 1.0

    override init() {
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect, cgImage: CGImage, inputValues: [Any], roiRatio: CGFloat = 1.0) {
        self.init()

        self.extent = frame
        self.roiRatio = roiRatio

        self.extractInputImage(cgImage: cgImage)

        self.loadCIKernel(from: URKernelShaderkWaveWarp)

        guard inputValues.count == 5 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(Double.pi)
    }

    convenience init(frame: CGRect, imageView: UIImageView, inputValues: [Any], roiRatio: CGFloat = 1.0) {
        self.init()

        self.extent = frame
        self.roiRatio = roiRatio

        self.extractInputImage(imageView: imageView)

        self.loadCIKernel(from: URKernelShaderkWaveWarp)

        guard inputValues.count == 5 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(Double.pi)
    }

    override open var outputImage: CIImage? {
        return self.applyFilter()
    }

    open var outputCGImage: CGImage? {
        let context = CIContext(options: nil)
        guard let output = self.outputImage, let resultCGImage = context.createCGImage(output, from: output.extent) else { return nil }

        return resultCGImage
    }

    func applyFilter() -> CIImage {
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
