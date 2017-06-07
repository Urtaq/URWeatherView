//
//  URRGBToneCurveFilter.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 7..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let URKernelShaderRGBToneCurve: String = "URKernelShaderRGBToneCurve.cikernel"

public class URRGBToneCurveFilter: CIFilter, URFilter {
    var inputImage: CIImage?
    var customKernel: CIKernel?
    var customAttributes: [Any]?

    var extent: CGRect = .zero

    override init() {
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        self.init()

        self.extent = frame

        self.extractInputImage(cgImage: cgImage)

        self.loadCIColorKernel(from: URKernelShaderRGBToneCurve)

        guard inputValues.count >= 4 else { return }
        self.customAttributes = inputValues
    }

    convenience init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        self.init()

        self.extent = frame

        self.extractInputImage(imageView: imageView)

        self.loadCIColorKernel(from: URKernelShaderRGBToneCurve)

        guard inputValues.count >= 4 else { return }
        self.customAttributes = inputValues
    }

    override public var outputImage: CIImage? {
        return self.applyFilter()
    }

    func applyFilter() -> CIImage {
        guard let resultImage: CIImage = (self.customKernel as! CIColorKernel).apply(withExtent: self.extent, arguments: self.customAttributes) else {
            fatalError("Filtered Image merging is failed!!")
        }

        return resultImage
    }
}
