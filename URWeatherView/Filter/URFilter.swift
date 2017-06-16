//
//  URFilter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 16..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

open class URFilter: CIFilter, URFilterBootLoading {
    open var inputImage: CIImage?
    var customKernel: CIKernel?
    var customAttributes: [Any]?

    var extent: CGRect = .zero

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init() {
        super.init()
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - cgImage: Core Image of the input image
        - inputValues: attributes for CIKernel
     */
    required public init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        super.init()

        self.extent = frame

        self.extractInputImage(cgImage: cgImage)
    }

    /**
     Initialize CIFilter with **CGImage** and CIKernel shader params
     - parameters:
        - frame: The frame rectangle for the input image, measured in points.
        - imageView: The UIImageView of the input image
        - inputValues: attributes for CIKernel
     */
    required public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        super.init()

        self.extent = frame

        self.extractInputImage(imageView: imageView)
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
        return CIImage()
    }

    // MARK: - shaders
    open static let colorKernelForRGB: CIColorKernel = CIColorKernel(string:
        "kernel vec4 combineRGBChannel(__sample rgb) {" +
            "   return vec4(rgb.rgb, 1.0);" +
        "}")!

    open static let colorKernel: CIColorKernel = CIColorKernel(string:
        "kernel vec4 combineRGBChannel(__sample red, __sample green, __sample blue, __sample rgb) {" +
            "   vec4 result = vec4(red.r, green.g, blue.b, rgb.a);" +
            "   bool isTransparency = true;" +
            "   if (red.r == 0.0 && red.g == 0.0 && red.b == 0.0 && red.a == 0.0) {" +
            "       result.r = 0.0;" +
            "   } else {" +
            "       isTransparency = false;" +
            "   }" +
            "   if (green.r == 0.0 && green.g == 0.0 && green.b == 0.0 && green.a == 0.0) {" +
            "       result.g = 0.0;" +
            "   } else {" +
            "       isTransparency = false;" +
            "   }" +
            "   if (blue.r == 0.0 && blue.g == 0.0 && blue.b == 0.0 && blue.a == 0.0) {" +
            "       result.b = 0.0;" +
            "   } else {" +
            "       isTransparency = false;" +
            "   }" +
            "   if (isTransparency) {" +
            "       result.a = 0.0;" +
            "   }" +
            "   return result;" +
        "}")!

    open static let brightenKernel: CIKernel = CIKernel(string:
        "kernel vec4 brightenEffect (sampler src, float k)\n" +
            "{\n" +
            "    vec4 currentSource = sample (src, samplerCoord (src));         // 1\n" +
            "    currentSource.rgb = currentSource.rgb + k * currentSource.a;   // 2\n" +
            "    return currentSource;                                          // 3\n" +
        "}")!

    open static let holeDistortionKernel: CIKernel = CIKernel(string:
        "kernel vec4 hole (sampler src, vec2 center, vec2 params)                // 1\n" +
            "{\n" +
            "    vec2 t1;\n" +
            "    float distance0, distance1;\n" +
            "\n" +
            "    t1 = destCoord () - center;                                        // 2\n" +
            "    distance0 = dot (t1, t1);                                          // 3\n" +
            "    t1 = t1 * inversesqrt (distance0);                                 // 4\n" +
            "    distance0 = distance0 * inversesqrt (distance0) * params.x;        // 5\n" +
            "    distance1 = distance0 - (1.0 / distance0);                         // 6\n" +
            "    distance0 = (distance0 < 1.0 ? 0.0 : distance1) * params.y;        // 7\n" +
            "    t1 = t1 * distance0 + center;                                      // 8\n" +
            "\n" +
            "    return sample (src, samplerTransform (src, t1));                   // 9\n" +
        "}"
        )!

    open static let multiplyKernel: CIKernel = CIKernel(string:
        "kernel vec4 multiplyEffect (sampler src, __color mul)\n" +
            "{\n" +
            "    return sample (src, samplerCoord (src)) * mul;\n" +
        "}"
        )!

    open static let swirlKernel: CIKernel = CIKernel(string:
        "kernel vec4 swirl(sampler src, vec2 center, float radius, float angle, float time)\n" +
            "{\n" +
            "vec2 texSize = samplerSize(src);\n" +
            "vec2 texure2D = samplerCoord(src) * texSize;\n" +
            "texure2D -= center;\n" +
            "float distance = length(texure2D);\n" +
            "if (distance < radius)\n" +
            "{\n" +
            "float percent = (radius - distance) / radius;\n" +
            "float theta = percent * percent * angle * 8.0;\n" +
            "float s = sin(theta);\n" +
            "float c = cos(theta);\n" +
            "texure2D = vec2(dot(texure2D, vec2(c, -s)), dot(texure2D, vec2(s, c)));\n" +
            "}\n" +
            "texure2D += center;\n" +
            "vec3 color = sample(src, texure2D / texSize).rgb;\n" +
            "return vec4(color, 1.0);" +
        "}"
        )!

    /// Shock Wave Effect
    ///
    /// - Parameters:
    ///    - sampler: CISampler
    ///    - center: CIVertor(vec2)
    open static let shockWaveKernel: CIKernel = CIKernel(string:
        "kernel vec4 shockWave(sampler src, vec2 center, vec3 shockParams, float time)\n" +
            "{\n" +
            "vec2 texture2D = samplerCoord(src);\n" +
            "float distance = length(texture2D - center);\n" +
            "if ( (distance <= (time + shockParams.z)) && (distance >= (time - shockParams.z)) )\n" +
            "{\n" +
            "float diff = (distance - time);\n" +
            "float powDiff = 1.0 - pow(abs(diff * shockParams.x), shockParams.y);\n" +
            "float diffTime = diff  * powDiff;\n" +
            "vec2 diffUV = normalize(texture2D - center);\n" +
            "texture2D = texture2D + (diffUV * diffTime);\n" +
            "}\n" +
            "return vec4(sample(src, texture2D).rgba);" +
        "}"
        )!

    /// Wave Warp Effect
    ///
    /// - Parameters:
    ///    - sampler: CISampler
    ///    - center: CIVertor(vec2)
    open static let waveWarpKernel: CIKernel = CIKernel(string:
        "kernel vec4 waveWarp(sampler src, vec2 center, vec3 shockParams, float time)\n" +
            "{\n" +
            "vec2 texture2D = samplerCoord(src);\n" +
            "float distance = length(texture2D - center);\n" +
            "if ( (distance <= (time + shockParams.z)) && (distance >= (time - shockParams.z)) )\n" +
            "{\n" +
            "float diff = (distance - time);\n" +
            "float powDiff = 1.0 - pow(abs(diff * shockParams.x), shockParams.y);\n" +
            "float diffTime = diff  * powDiff;\n" +
            "vec2 diffUV = normalize(texture2D - center);\n" +
            "texture2D = texture2D + (diffUV * diffTime);\n" +
            "}\n" +
            "return vec4(sample(src, texture2D).rgba);" +
        "}"
        )!
}
