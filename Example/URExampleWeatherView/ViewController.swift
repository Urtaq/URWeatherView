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
let DefaultSmokeBirthRate: Float = 40.0

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var btnOne: UIButton!
    @IBOutlet var btnTwo: UIButton!

    var mainAnimationView: LOTAnimationView!
    var skView: SKView!
    var weatherScene: MyScene!

    @IBOutlet var slSnowBirthRate: UISlider!
    @IBOutlet var lbSnowBirthRateCurrent: UILabel!
    @IBOutlet var lbSnowBirthRateMax: UILabel!

    @IBOutlet var slRainBirthRate: UISlider!
    @IBOutlet var lbRainBirthRateCurrent: UILabel!
    @IBOutlet var lbRainBirthRateMax: UILabel!

    @IBOutlet var slSmokeBirthRate: UISlider!
    @IBOutlet var lbSmokeBirthRateCurrent: UILabel!
    @IBOutlet var lbSmokeBirthRateMax: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let animationView = LOTAnimationView(name: "data") {
            self.mainAnimationView = animationView
            self.mainView.addSubview(animationView)
            self.mainAnimationView.translatesAutoresizingMaskIntoConstraints = false

            self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.mainAnimationView]))
            self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.mainAnimationView]))
        }

        self.skView = SKView(frame: self.mainView.frame)
        self.weatherScene = MyScene(size: self.skView.bounds.size)

        self.skView.backgroundColor = UIColor.clear
        self.skView.presentScene(self.weatherScene)
        self.mainView.addSubview(self.skView)

        self.skView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.skView]))
        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.skView]))

        self.initValues()
    }

    func initValues() {
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

    @IBAction func changeBirthRate(_ sender: Any) {
        if let slider = sender as? UISlider {
            switch slider {
            case self.slSnowBirthRate:
                self.lbSnowBirthRateCurrent.text = "\(self.slSnowBirthRate.value)"
                self.weatherScene.setBirthRate(rate: CGFloat(self.slSnowBirthRate.value))

            case self.slRainBirthRate:
                self.lbRainBirthRateCurrent.text = "\(self.slRainBirthRate.value)"
                self.weatherScene.setBirthRate(rate: CGFloat(self.slRainBirthRate.value))

            case self.slSmokeBirthRate:
                self.lbSmokeBirthRateCurrent.text = "\(self.slSmokeBirthRate.value)"
                self.weatherScene.setBirthRate(rate: CGFloat(self.slSmokeBirthRate.value))

            default:
                break
            }
        }
    }

    @IBAction func tabSnow(_ sender: Any) {
        self.weatherScene.stopEmitter()
        self.weatherScene.startEmitter()
        self.weatherScene.setBirthRate(rate: CGFloat(self.slSnowBirthRate.value))
    }

    @IBAction func tabRain(_ sender: Any) {
        self.weatherScene.stopEmitter()
        self.weatherScene.startEmitter(weather: .rain)
        self.weatherScene.setBirthRate(rate: CGFloat(self.slRainBirthRate.value))
    }

    @IBAction func tabDust(_ sender: Any) {
        self.weatherScene.stopEmitter()
        self.weatherScene.startEmitter(weather: .dust)
        self.weatherScene.setBirthRate(rate: CGFloat(self.slSmokeBirthRate.value))
    }

    @IBAction func tabWeatherInit(_ sender: Any) {
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
        default:
            break
        }
        self.weatherScene.stopEmitter()
    }
}

