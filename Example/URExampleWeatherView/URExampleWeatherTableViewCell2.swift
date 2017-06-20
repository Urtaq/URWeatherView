//
//  URExampleWeatherTableViewCell2.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 22..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import URWeatherView

class URExampleWeatherTableViewCell2: URExampleWeatherTableViewCell {
    override func configCell(_ weather: URWeatherType) {
        super.configCell(weather)

        if weather == .dust {
            self.btnDustColor1.isSelected = true
            self.btnDustColor2.isSelected = false
        }
    }

    @IBOutlet var btnDustColor1: UIButton!
    @IBOutlet var btnDustColor2: UIButton!
    @IBAction func tapDustColor(_ sender: Any) {
        self.btnDustColor1.isSelected = !self.btnDustColor1.isSelected
        self.btnDustColor2.isSelected = !self.btnDustColor2.isSelected

        guard let apply = self.applyWeatherBlock else { return }
        apply()
    }
}
