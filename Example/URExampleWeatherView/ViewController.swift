//
//  ViewController.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 21..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var btnOne: UIButton!
    @IBOutlet var btnTwo: UIButton!

    var mainAnimationView: LOTAnimationView!

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tabOne(_ sender: Any) {
        self.btnOne.isSelected = true
        self.btnTwo.isSelected = false

        self.mainAnimationView.play()
    }

    @IBAction func tabTwo(_ sender: Any) {
        self.btnOne.isSelected = false
        self.btnTwo.isSelected = true

        self.mainAnimationView.play()
        Timer.scheduledTimer(withTimeInterval: 0.32, repeats: false) { (timer) in
            self.mainAnimationView.pause()
        }
    }
}

