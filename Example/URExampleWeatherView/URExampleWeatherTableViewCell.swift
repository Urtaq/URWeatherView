//
//  URExampleWeatherTableViewCell.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 22..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import URWeatherView

class URExampleWeatherTableViewCell: UITableViewCell {
    @IBOutlet var btnApplyWeather: UIButton!
    @IBOutlet var slBirthRate: UISlider!
    @IBOutlet var lbBirthRateCurrent: UILabel!
    @IBOutlet var lbBirthRateMax: UILabel!

    var weather: URWeatherType = .snow

    var applyWeatherBlock: (() -> Void)?
    var stopWeatherBlock: (() -> Void)?
    var removeToneFilterBlock: (() -> Void)?
    var birthRateDidChange: ((CGFloat) -> Void)?

    func configCell(_ weather: URWeatherType) {
        self.weather = weather

        self.btnApplyWeather.setTitle(weather.name, for: .normal)
        self.slBirthRate.value = Float(weather.defaultBirthRate)
        self.slBirthRate.maximumValue = Float(weather.maxBirthRate)
        self.lbBirthRateCurrent.text = "\(self.slBirthRate.value)"
        self.lbBirthRateMax.text = "\(self.slBirthRate.maximumValue)"

        switch weather {
        case .lightning, .hot:
            self.slBirthRate.isEnabled = false
        default:
            break
        }
    }

    @IBAction func tapApplyWeather(_ sender: Any) {
        guard let apply = self.applyWeatherBlock else { return }
        apply()

        guard let setBirthRate = self.birthRateDidChange else { return }
        setBirthRate(CGFloat(self.slBirthRate.value))
    }

    @IBAction func tapWeatherInit(_ sender: Any) {
        self.slBirthRate.value = Float(self.weather.defaultBirthRate)
        self.lbBirthRateCurrent.text = "\(self.slBirthRate.value)"

        if let block = self.removeToneFilterBlock {
            block()
        }

        guard let block = self.stopWeatherBlock else { return }
        block()
    }

    @IBAction func changeBirthRate(_ sender: Any) {
        self.lbBirthRateCurrent.text = "\(self.slBirthRate.value)"

        guard let block = self.birthRateDidChange else { return }
        block(CGFloat(self.slBirthRate.value))
    }
}
