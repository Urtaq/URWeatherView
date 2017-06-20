//
//  URWeatherView.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 19..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

open class URWeatherView: UIView {
    var backgroundImageView: URFilterImageView!
    var backgroundDefaultImage: UIImage!

    var mainImageView: UIImageView!
    var mainLOTAnimationView: URLOTAnimationView!
    var mainLOTJSONDataName: String!

    var skView: SKView!
    var weatherScene: URWeatherScene!

    var upperImageView: UIImageView!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.upperImageView = UIImageView()
        self.addSubview(self.upperImageView)
        self.upperImageView.addConstraintEdgesToSuper()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.upperImageView = UIImageView(frame: frame)
        self.addSubview(self.upperImageView)
        self.upperImageView.addConstraintEdgesToSuper()
    }

    convenience public init(frame: CGRect, mainWeatherImage mainImage: UIImage, backgroundImage: UIImage?) {
        self.init(frame: frame)

        self.initView(mainWeatherImage: mainImage, backgroundImage: backgroundImage)
    }

    convenience public init(frame: CGRect, dataNameOfLottie data: String, backgroundImage: UIImage?) {
        self.init(frame: frame)

        self.initView(dataNameOfLottie: data, backgroundImage: backgroundImage)
    }

    open func initView(mainWeatherImage data: UIImage, backgroundImage: UIImage?) {

        self.configMain()

        self.mainImageView = UIImageView(frame: frame)
        self.insertSubview(self.mainImageView, belowSubview: self.upperImageView)
        self.mainImageView.addConstraintEdgesToSuper()

        self.backgroundDefaultImage = backgroundImage
        self.configBackground(image: backgroundImage)
    }

    open func initView(dataNameOfLottie data: String, backgroundImage: UIImage?) {

        self.configMain()

        self.mainLOTJSONDataName = data
        self.configMainLOTAnimation(data: data)

        self.backgroundDefaultImage = backgroundImage
        self.configBackground(image: backgroundImage)
    }

    func configMain() {
        self.skView = SKView(frame: self.frame)

        self.skView.backgroundColor = UIColor.clear
        self.insertSubview(self.skView, belowSubview: self.upperImageView)
        self.skView.addConstraintEdgesToSuper()

        self.layoutIfNeeded()

        self.weatherScene = URWeatherScene(size: self.skView.bounds.size)
        self.skView.presentScene(self.weatherScene)
    }

    func configBackground(image: UIImage?) {

        if let background = image {
            self.backgroundImageView = URFilterImageView(frame: frame)
            self.insertSubview(self.backgroundImageView, at: 0)
            self.backgroundImageView.addConstraintEdgesToSuper()

            self.backgroundImageView.image = background
        }
    }

    open func initWeather(backgroundImage: UIImage? = nil, data: String? = nil) {
        if self.backgroundDefaultImage != nil {
            self.backgroundImageView.image = self.backgroundDefaultImage
        }
        if let image = backgroundImage {
            self.backgroundImageView.image = image
        }
        if let jsonName = data, self.mainLOTAnimationView != nil {
            self.configMainLOTAnimation(data: jsonName)
        }
    }

    // MARK: - Scene handling
    open var weatherSceneSize: CGSize {
        return self.weatherScene.size
    }

    open var weatherType: URWeatherType {
        return self.weatherScene.weatherType
    }

    open var enableDebugOption: Bool = false {
        didSet {
            self.weatherScene.enableDebugOptions(needToShow: self.enableDebugOption)
        }
    }

    open var birthRate: CGFloat = 0.0 {
        didSet {
            self.weatherScene.birthRate = self.birthRate
        }
    }

    open var weatherGroundEmitterOptions: [URWeatherGroundEmitterOption]! {
        didSet {
            self.weatherScene.subGroundEmitterOptions = self.weatherGroundEmitterOptions
        }
    }

    open func setUpperImageEffect(duration: TimeInterval = 1.0, customImage: UIImage? = nil) {
        self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
            self.upperImageView.alpha = 0.0
            if let customImage = customImage {
                self.upperImageView.image = customImage
            } else {
                self.upperImageView.image = backgroundImage
            }

            if backgroundImage != nil {
                UIView.animate(withDuration: duration, animations: {
                    self.upperImageView.alpha = opacity
                })
            } else {
                self.upperImageView.alpha = opacity
            }
        }
    }

    open func startWeatherScene(_ weather: URWeatherType, duration: TimeInterval = 0.0, showTimes times: [Double]! = nil) {
        self.weatherScene.startScene(weather, duration: duration, showTimes: times)
    }

    open func startWeatherSceneBulk(_ weather: URWeatherType, upperImage: UIImage? = nil, duration: TimeInterval = 0.0, debugOption: Bool = false, additionalTask: (() -> Void)? = nil) {
        self.initWeather()

        self.setUpperImageEffect(customImage: upperImage)

        self.stop()
        self.enableDebugOption = debugOption

        switch weather {
        case .snow:
            if let filterValues = URWeatherType.snow.imageFilterValues, let filterValuesSub = URWeatherType.snow.imageFilterValuesSub {
                self.backgroundImageView.applyToneCurveFilter(filterValues: filterValues)
                self.mainLOTAnimationView.applyToneCurveFilter(filterValues: filterValues, filterValuesSub: filterValuesSub)
            }
            self.startWeatherScene(.snow)
            if let task = additionalTask {
                task()
            }
        case .rain:
            self.startWeatherScene(.rain)
            if let task = additionalTask {
                task()
            }
        case .dust:
            self.startWeatherScene(.dust)
            if let task = additionalTask {
                task()
            }
        case .dust2:
            self.startWeatherScene(.dust)
            if let task = additionalTask {
                task()
            }
        case .lightning:
            let times = [0.1, 0.103, 0.14,
                         0.17, 0.173, 0.20,
                         0.35, 0.353, 0.38,
                         0.385, 0.388, 0.415,
                         0.54, 0.543, 0.57,
                         0.69, 0.693, 0.72,
                         0.74, 0.743, 0.77,
                         0.93, 0.933, 0.96]

            let lightningShowTimes = [times[0] - 0.005, times[4] - 0.005, times[7] - 0.005, times[10] - 0.005, times[13] - 0.005, times[16] - 0.005, times[19] - 0.005, times[22] - 0.005]
            let duration: TimeInterval = 6.0
//                    let bundle = Bundle(for: URWeatherScene.self)
//                    let imageDark = UIImage(named: "darkCity_00000", in: bundle, compatibleWith: nil)!
//                    let imageLight = UIImage(named: "darkCity2_00006", in: bundle, compatibleWith: nil)!
//                    self.mainBackgroundImageView.applyBackgroundEffect(imageAssets: [imageDark, imageLight], duration: duration,
//                                                                       userInfo: ["times": times])
            let backgroundImages = self.weatherScene.makeLightningBackgroundEffect(imageView: self.backgroundImageView)
            self.backgroundImageView.applyBackgroundEffect(imageAssets: backgroundImages, duration: duration,
                                                               userInfo: ["times": times])
            if let filterValues = URWeatherType.lightning.imageFilterValues {
                self.mainLOTAnimationView.applyToneCurveFilter(filterValues: filterValues)
            }
            self.startWeatherScene(.lightning, duration: duration, showTimes: lightningShowTimes)
        case .hot:
            if let filterValues = URWeatherType.hot.imageFilterValues {
                self.backgroundImageView.applyToneCurveFilter(filterValues: filterValues)
                self.backgroundImageView.applyDistortionFilter()
                self.mainLOTAnimationView.applyToneCurveFilter(filterValues: filterValues)
                self.mainLOTAnimationView.applyDistortionFilter()
            }
            self.startWeatherScene(.hot)
        case .cloudy:
            self.startWeatherScene(.cloudy, duration: 33.0)
        case .comet:
            self.startWeatherScene(.comet)
        default:
            break
        }
    }

    open func stop() {
        self.stopWeatherScene()
        self.configMainLOTAnimation(data: self.mainLOTJSONDataName)
        self.stopBackgroundEffect()
    }

    open func stopWeatherScene() {
        self.upperImageView.image = nil
        self.weatherScene.stopScene()
    }

    open func stopBackgroundEffect() {
        if self.backgroundImageView != nil {
            self.backgroundImageView.stop {
                self.backgroundImageView.removeToneCurveFilter()
                self.backgroundImageView.removeGradientMask()
            }
        }
    }

    // MARK: - Lottie
    func configMainLOTAnimation(data: String?) {
        guard let JSONName = data else { return }

        var animationProgress: CGFloat = 0.0
        if let prevAnimationView = self.mainLOTAnimationView {
            animationProgress = prevAnimationView.animationProgress
            if animationProgress == 1.0 {
                animationProgress = 0.0
            }
            prevAnimationView.removeFromSuperview()

            self.mainLOTAnimationView = nil
        }

        self.mainLOTAnimationView = URLOTAnimationView(name: JSONName)
        self.insertSubview(self.mainLOTAnimationView, belowSubview: self.skView)
        self.mainLOTAnimationView.animationProgress = animationProgress
        self.mainLOTAnimationView.addConstraintEdgesToSuper()
    }

    open func play(eventHandler: (() -> Void)? = nil) {
        self.mainLOTAnimationView.play()
        guard let handler = eventHandler else { return }
        handler()
    }

    open func pause() {
        self.mainLOTAnimationView.pause()
    }
}

extension UIView {
    func addResizingMaskEdgesToSuper() {
        self.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
    }

    func addConstraintEdgesToSuper() {
        guard let parent = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["view" : self]))
        parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["view" : self]))
    }
}
