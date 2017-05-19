//
//  ViewController.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 21..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import Lottie
import SpriteKit

let DefaultSnowBirthRate: Float = 40.0
let DefaultRainBirthRate: Float = 150.0
let DefaultSmokeBirthRate: Float = 200.0
let DefaultCometBirthRate: Float = 455.0

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var mainUpperImageView: UIImageView!
    @IBOutlet var btnOne: UIButton!
    @IBOutlet var btnTwo: UIButton!

    @IBOutlet var segment: UISegmentedControl!

    var mainAnimationView: LOTAnimationView!
    var skView: SKView!
    var weatherScene: URWeatherScene!

    @IBOutlet var slSnowBirthRate: UISlider!
    @IBOutlet var lbSnowBirthRateCurrent: UILabel!
    @IBOutlet var lbSnowBirthRateMax: UILabel!

    @IBOutlet var slRainBirthRate: UISlider!
    @IBOutlet var lbRainBirthRateCurrent: UILabel!
    @IBOutlet var lbRainBirthRateMax: UILabel!

    @IBOutlet var slSmokeBirthRate: UISlider!
    @IBOutlet var lbSmokeBirthRateCurrent: UILabel!
    @IBOutlet var lbSmokeBirthRateMax: UILabel!

    @IBOutlet var slCometBirthRate: UISlider!
    @IBOutlet var lbCometBirthRateCurrent: UILabel!
    @IBOutlet var lbComentBirthRateMax: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let animationView = LOTAnimationView(name: "data") {
            self.mainAnimationView = animationView
            self.mainView.addSubview(animationView)
            self.mainAnimationView.translatesAutoresizingMaskIntoConstraints = false

            self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.mainAnimationView]))
            self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.mainAnimationView]))

            print("\(animationView.sceneModel)")
//            print("\(animationView.imageSolidLayers)")
        }

        self.skView = SKView(frame: self.mainView.frame)
        self.weatherScene = URWeatherScene(size: self.skView.bounds.size)

        self.skView.backgroundColor = UIColor.clear
        self.skView.presentScene(self.weatherScene)
        self.mainView.insertSubview(self.skView, belowSubview: self.mainUpperImageView)

        self.skView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.skView]))
        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.skView]))

        self.initValues()
    }

    func initValues() {
        self.slSnowBirthRate.value = DefaultSnowBirthRate
        self.slRainBirthRate.value = DefaultRainBirthRate
        self.slSmokeBirthRate.value = DefaultSmokeBirthRate
        self.slCometBirthRate.value = DefaultCometBirthRate

        self.lbSnowBirthRateMax.text = "\(self.slSnowBirthRate.maximumValue)"
        self.lbRainBirthRateMax.text = "\(self.slRainBirthRate.maximumValue)"
        self.lbSmokeBirthRateMax.text = "\(self.slSmokeBirthRate.maximumValue)"

        self.lbSnowBirthRateCurrent.text = "\(self.slSnowBirthRate.value)"
        self.lbRainBirthRateCurrent.text = "\(self.slRainBirthRate.value)"
        self.lbSmokeBirthRateCurrent.text = "\(self.slSmokeBirthRate.value)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tabOne(_ sender: Any) {
        if !self.btnOne.isSelected {
            self.btnOne.isSelected = true
            self.btnTwo.isSelected = false

            self.mainAnimationView.play()
        }
    }

    @IBAction func tabTwo(_ sender: Any) {
        if !self.btnTwo.isSelected {
            self.btnOne.isSelected = false
            self.btnTwo.isSelected = true

            self.mainAnimationView.play()
            Timer.scheduledTimer(withTimeInterval: 0.32, repeats: false) { (timer) in
                self.mainAnimationView.pause()
            }
        }
    }
    @IBAction func changeSpriteKitDebugOption(_ sender: Any) {
        if let segment = sender as? UISegmentedControl {
            let selected: Bool = segment.selectedSegmentIndex == 0
            self.weatherScene.enableDebugOptions(needToShow: selected)
        }
    }

    @IBAction func changeBirthRate(_ sender: Any) {
        if let slider = sender as? UISlider {
            var birthRate: Float = 0.0

            switch slider {
            case self.slSnowBirthRate:
                self.lbSnowBirthRateCurrent.text = "\(self.slSnowBirthRate.value)"
                birthRate = self.slSnowBirthRate.value

            case self.slRainBirthRate:
                self.lbRainBirthRateCurrent.text = "\(self.slRainBirthRate.value)"
                birthRate = self.slRainBirthRate.value

            case self.slSmokeBirthRate:
                self.lbSmokeBirthRateCurrent.text = "\(self.slSmokeBirthRate.value)"
                birthRate = self.slSmokeBirthRate.value

            case self.slCometBirthRate:
                self.lbCometBirthRateCurrent.text = "\(self.slCometBirthRate.value)"
                birthRate = self.slCometBirthRate.value

            default:
                break
            }

            self.weatherScene.setBirthRate(rate: CGFloat(birthRate))
        }
    }

    @IBAction func tabSnow(_ sender: Any) {
        self.weatherScene.extraEffectBlock = { (backgroundImage) in
            self.mainUpperImageView.alpha = 0.0
            self.mainUpperImageView.image = backgroundImage

            UIView.animate(withDuration: 1.0, animations: { 
                self.mainUpperImageView.alpha = 1.0
            })
        }

        self.weatherScene.stopEmitter()
        self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
        self.weatherScene.startEmitter()
        self.weatherScene.setBirthRate(rate: CGFloat(self.slSnowBirthRate.value))
    }

    @IBAction func tabRain(_ sender: Any) {
        self.weatherScene.extraEffectBlock = { (backgroundImage) in
            self.mainUpperImageView.alpha = 0.0
            self.mainUpperImageView.image = backgroundImage

            UIView.animate(withDuration: 1.0, animations: {
                self.mainUpperImageView.alpha = 1.0
            })
        }

        self.weatherScene.stopEmitter()
        self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
        self.weatherScene.startEmitter(weather: .rain)
        self.weatherScene.setBirthRate(rate: CGFloat(self.slRainBirthRate.value))
    }

    @IBAction func tabDust(_ sender: Any?) {
        self.weatherScene.extraEffectBlock = { (backgroundImage) in
            self.mainUpperImageView.alpha = 0.0
            self.mainUpperImageView.image = backgroundImage

            UIView.animate(withDuration: 1.0, animations: {
                self.mainUpperImageView.alpha = 1.0
            })
        }

        self.weatherScene.stopEmitter()
        self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
        if self.btnDustColor1.isSelected {

            self.weatherScene.startEmitter(weather: .dust)
            if let startBirthRate = URWeatherType.dust.startBirthRate {
                self.slSmokeBirthRate.value = Float(startBirthRate)
                self.changeBirthRate(self.slSmokeBirthRate)
            }
        }
        if self.btnDustColor2.isSelected {

            self.weatherScene.startEmitter(weather: .dust2)
            if let startBirthRate = URWeatherType.dust2.startBirthRate {
                self.slSmokeBirthRate.value = Float(startBirthRate)
                self.changeBirthRate(self.slSmokeBirthRate)
            }
        }
        self.weatherScene.setBirthRate(rate: CGFloat(self.slSmokeBirthRate.value))
    }

    @IBOutlet var btnDustColor1: UIButton!
    @IBOutlet var btnDustColor2: UIButton!
    @IBAction func tapDustColor(_ sender: Any) {
        self.btnDustColor1.isSelected = !self.btnDustColor1.isSelected
        self.btnDustColor2.isSelected = !self.btnDustColor2.isSelected

        self.tabDust(nil)
    }

    @IBAction func tabComet(_ sender: Any) {
        self.weatherScene.extraEffectBlock = { (backgroundImage) in
            self.mainUpperImageView.image = backgroundImage
        }

        self.weatherScene.stopEmitter()
        self.weatherScene.startEmitter(weather: .comet)
        self.weatherScene.setBirthRate(rate: CGFloat(self.slCometBirthRate.value))
    }

    @IBAction func tabWeatherInit(_ sender: Any) {
        self.mainUpperImageView.image = nil

        switch self.weatherScene.weatherType {
        case .snow:
            self.slSnowBirthRate.value = DefaultSnowBirthRate
            self.lbSnowBirthRateCurrent.text = "\(self.slSnowBirthRate.value)"
        case .rain:
            self.slRainBirthRate.value = DefaultRainBirthRate
            self.lbRainBirthRateCurrent.text = "\(self.slRainBirthRate.value)"
        case .dust:
            self.slSmokeBirthRate.value = DefaultSmokeBirthRate
            self.lbSmokeBirthRateCurrent.text = "\(self.slSmokeBirthRate.value)"
        case .dust2:
            self.slSmokeBirthRate.value = DefaultSmokeBirthRate
            self.lbSmokeBirthRateCurrent.text = "\(self.slSmokeBirthRate.value)"
        case .comet:
            self.slCometBirthRate.value = DefaultCometBirthRate
            self.lbCometBirthRateCurrent.text = "\(self.slCometBirthRate.value)"
        default:
            break
        }
        self.weatherScene.stopEmitter()
    }
}

