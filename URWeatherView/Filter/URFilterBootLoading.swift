//
//  URFilter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 9..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

typealias URFilterShaderCode = String
protocol URFilterBootLoading: class {
    var inputImage: CIImage? { get set }
    var customKernel: CIKernel? { get set }
    var customAttributes: [Any]? { get set }
    var extent: CGRect { get set }

    var outputCGImage: CGImage? { get }

    func applyFilter() -> CIImage

    init(frame: CGRect, cgImage: CGImage, inputValues: [Any])
    init(frame: CGRect, imageView: UIImageView, inputValues: [Any])
}

extension URFilterBootLoading {

    // MARK: - kernel shader loader
    func loadCIKernel(from filename: String) {
        let shaderCode = self.loadKernelShaderCode(filename)

        self.customKernel = CIKernel(string: shaderCode)
    }

    func loadCIColorKernel(from filename: String) {
        let shaderCode = self.loadKernelShaderCode(filename)

        self.customKernel = CIColorKernel(string: shaderCode)
    }

    private func loadKernelShaderCode(_ filename: String) -> URFilterShaderCode {
        let bundle = Bundle(for: Self.self)
        guard let path = bundle.path(forResource: filename, ofType: nil) else {
            fatalError("\(Self.self) \(#function) \(#line) : Shader file is not found!!")
        }

        let shaderCode: String
        do {
            shaderCode = try String(contentsOfFile: path)
        } catch {
            fatalError("\(Self.self) \(#function) \(#line) : Shader file is failed to be CIKernel instance!!")
        }

        return shaderCode
    }

    // MARK: - handler of Input Image
    public func extractInputImage(cgImage: CGImage) {
        let ciImage = CIImage(cgImage: cgImage)
        self.inputImage = ciImage
    }

    public func extractInputImage(_ image: UIImage) {
        if let ciImage = CIImage(image: image) {
            self.inputImage = ciImage

            return
        }

        if let ciImage = image.ciImage {
            self.inputImage = ciImage

            return
        }

        fatalError("Cannot get Core Image!!")
    }

    public func extractInputImage(imageView: UIImageView) {
        guard let rawImage = imageView.image else {
            fatalError("The UIImageView must have image!!")
        }
        self.extractInputImage(rawImage)
    }

    // MARK: - util
    func destToSource(x: CGFloat, center: CGFloat, k: CGFloat) -> CGFloat {
        var sourceX: CGFloat = x
        sourceX -= center
        sourceX = sourceX / (1.0 + fabs(sourceX / k))
        sourceX += center

        return sourceX
    }

    func region(of r: CGRect, center: CGFloat, k: CGFloat) -> CGRect {
        let leftP: CGFloat = destToSource(x: r.origin.x, center: center, k: k)
        let rightP: CGFloat = destToSource(x: r.origin.x + r.size.width, center: center, k: k)
        return CGRect(x: leftP, y: r.origin.y, width: rightP - leftP, height: r.size.height)
    }
}
