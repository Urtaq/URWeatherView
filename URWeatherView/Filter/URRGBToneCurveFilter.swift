//
//  URRGBToneCurveFilter.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 7..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderRGBToneCurve: String = "URKernelShaderRGBToneCurve.cikernel"

open class URRGBToneCurveFilter: CIFilter, URFilter {
    open var inputImage: CIImage?
    var customKernel: CIKernel?
    /// [red: CIImage, green: CIImage, blue: CIImage, CIImage(cgImage: cgImage)]
    var customAttributes: [Any]?

    var extent: CGRect = .zero

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

        self.loadCIColorKernel(from: URKernelShaderRGBToneCurve)

        guard inputValues.count == 4 else { return }
        self.customAttributes = inputValues
    }

    convenience public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        self.init()

        self.extent = frame

        self.extractInputImage(imageView: imageView)

        self.loadCIColorKernel(from: URKernelShaderRGBToneCurve)

        guard inputValues.count >= 4 else { return }
        self.customAttributes = inputValues
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
        guard let resultImage: CIImage = (self.customKernel as! CIColorKernel).apply(withExtent: self.extent, arguments: self.customAttributes) else {
            fatalError("Filtered Image merging is failed!!")
        }

        return resultImage
    }
}
