//
//  URShockWaveFilter.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 8..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderShockWave: String = "URKernelShaderShockWave.cikernel"

open class URShockWaveFilter: CIFilter, URFilter {
    open var inputImage: CIImage?
    var customKernel: CIKernel?
    /// [sampler: CISampler, center: CIVector, progress: TimeInterval, shocksParams: CIVector]
    var customAttributes: [Any]?

    var extent: CGRect = .zero

    let shockParams: CIVector = CIVector(x: 10.0, y: 0.8, z: 0.1)

    override init() {
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience public init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        self.init()

        self.extent = frame

        self.extractInputImage(cgImage: cgImage)

        self.loadCIKernel(from: URKernelShaderShockWave)

        guard inputValues.count == 3 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(self.shockParams)
    }

    convenience public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        self.init()

        self.extent = frame

        self.extractInputImage(imageView: imageView)

        self.loadCIKernel(from: URKernelShaderShockWave)

        guard inputValues.count == 3 else { return }
        self.customAttributes = inputValues
        self.customAttributes?.append(self.shockParams)
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
