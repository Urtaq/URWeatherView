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

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var mainUpperImageView: UIImageView!
    @IBOutlet var btnOne: UIButton!
    @IBOutlet var btnTwo: UIButton!

    @IBOutlet var segment: UISegmentedControl!

    @IBOutlet var mainBackgroundImageView: URToneCurveImageView!
    var mainAnimationView: URLOTAnimationView!
    var skView: SKView!
    var weatherScene: URWeatherScene!

    @IBOutlet var effectTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.skView = SKView(frame: self.mainView.frame)

        self.skView.backgroundColor = UIColor.clear
        self.mainView.insertSubview(self.skView, belowSubview: self.mainUpperImageView)

        self.skView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.skView]))
        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.skView]))

        self.mainView.layoutIfNeeded()
        self.weatherScene = URWeatherScene(size: self.skView.bounds.size)
        self.skView.presentScene(self.weatherScene)

        self.initMainAnimation()
    }

    func initMainAnimation() {
        self.mainBackgroundImageView.image = #imageLiteral(resourceName: "img_back")

        var animationProgress: CGFloat = 0.0
        if let prevAnimationView = self.mainAnimationView {
            animationProgress = prevAnimationView.animationProgress
            if animationProgress == 1.0 {
                animationProgress = 0.0
            }
            prevAnimationView.removeFromSuperview()

            self.mainAnimationView = nil
        }

        self.mainAnimationView = URLOTAnimationView(name: "data")
        self.mainView.insertSubview(self.mainAnimationView, belowSubview: self.skView)
        self.mainAnimationView.animationProgress = animationProgress
        self.mainAnimationView.translatesAutoresizingMaskIntoConstraints = false

        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.mainAnimationView]))
        self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : self.mainAnimationView]))

//        print("\(self.mainAnimationView.sceneModel)")
//        print("\(self.mainAnimationView.imageSolidLayers)")
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

            self.changedMainState()
        }
    }

    @IBAction func tabTwo(_ sender: Any) {
        if !self.btnTwo.isSelected {
            self.btnOne.isSelected = false
            self.btnTwo.isSelected = true

            self.mainAnimationView.play()
            Timer.scheduledTimer(withTimeInterval: 0.32, repeats: false) { (timer) in
                self.mainAnimationView.pause()

                self.changedMainState()
            }
        }
    }
    @IBAction func changeSpriteKitDebugOption(_ sender: Any) {
        if let segment = sender as? UISegmentedControl {
            let selected: Bool = segment.selectedSegmentIndex == 0
            self.weatherScene.enableDebugOptions(needToShow: selected)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URWeatherType.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if URWeatherType.all[indexPath.row] == .dust ||
            URWeatherType.all[indexPath.row] == .dust2  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "effectCell2", for: indexPath) as! URExampleWeatherTableViewCell2

            cell.configCell(URWeatherType.all[indexPath.row])

            cell.applyWeatherBlock = {
                self.initMainAnimation()

                switch cell.weather {
                case .dust, .dust2:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.alpha = 0.0
                        self.mainUpperImageView.image = backgroundImage

                        UIView.animate(withDuration: 1.0, animations: {
                            self.mainUpperImageView.alpha = opacity
                        })
                    }

                    self.weatherScene.stopScene()
                    self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
                    if cell.btnDustColor1.isSelected {

                        self.weatherScene.startScene(.dust)
                        if let startBirthRate = URWeatherType.dust.startBirthRate {
                            cell.slBirthRate.value = Float(startBirthRate)
                            cell.changeBirthRate(cell.slBirthRate)
                        }
                    }
                    if cell.btnDustColor2.isSelected {

                        self.weatherScene.startScene(.dust2)
                        if let startBirthRate = URWeatherType.dust2.startBirthRate {
                            cell.slBirthRate.value = Float(startBirthRate)
                            cell.changeBirthRate(cell.slBirthRate)
                        }
                    }
                default:
                    break
                }
            }

            cell.stopWeatherBlock = {
                self.mainUpperImageView.image = nil

                self.weatherScene.stopScene()
            }

            cell.removeToneFilterBlock = {
                self.mainAnimationView.removeToneCurveFilter()
                self.mainBackgroundImageView.removeToneCurveFilter()
            }

            cell.birthRateDidChange = { (birthRate) in
                self.weatherScene.birthRate = birthRate
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "effectCell1", for: indexPath) as! URExampleWeatherTableViewCell
            cell.configCell(URWeatherType.all[indexPath.row])

            cell.applyWeatherBlock = {
                self.initMainAnimation()
                self.mainBackgroundImageView.stop({
                    self.mainBackgroundImageView.removeToneCurveFilter()
                })

                switch cell.weather {
                case .snow:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.alpha = 0.0
                        self.mainUpperImageView.image = backgroundImage

                        UIView.animate(withDuration: 1.0, animations: {
                            self.mainUpperImageView.alpha = opacity
                        })
                    }

                    if let filterValues = URWeatherType.snow.imageFilterValues, let filterValuesSub = URWeatherType.snow.imageFilterValuesSub {
                        self.mainBackgroundImageView.applyToneCurveFilter(filterValues: filterValues)
                        self.mainAnimationView.applyToneCurveFilter(filterValues: filterValues, filterValuesSub: filterValuesSub)
                    }

                    self.weatherScene.stopScene()
                    self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
                    self.weatherScene.startScene()
                    self.changedMainState()
                case .rain:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.alpha = 0.0
                        self.mainUpperImageView.image = backgroundImage

                        UIView.animate(withDuration: 1.0, animations: {
                            self.mainUpperImageView.alpha = opacity
                        })
                    }

                    self.weatherScene.stopScene()
                    self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
                    self.weatherScene.startScene(.rain)
                    self.changedMainState()
                case .lightning:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.alpha = 0.0
                        self.mainUpperImageView.image = backgroundImage

                        UIView.animate(withDuration: 1.0, animations: {
                            self.mainUpperImageView.alpha = opacity
                        })
                    }

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
                    self.mainBackgroundImageView.applyBackgroundEffect(imageAssets: [#imageLiteral(resourceName: "darkCity_00000"), #imageLiteral(resourceName: "darkCity2_00006")], duration: duration,
                                                                       userInfo: ["times": times])
                    if let filterValues = URWeatherType.lightning.imageFilterValues {
                        self.mainAnimationView.applyToneCurveFilter(filterValues: filterValues)
                    }
                    self.weatherScene.stopScene()
                    self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
                    self.weatherScene.startScene(.lightning, duration: duration, showTimes: lightningShowTimes)
                case .hot:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.alpha = 0.0
                        self.mainUpperImageView.image = backgroundImage

                        UIView.animate(withDuration: 1.0, animations: {
                            self.mainUpperImageView.alpha = opacity
                        })
                    }

                    if let filterValues = URWeatherType.hot.imageFilterValues {
                        self.mainBackgroundImageView.applyToneCurveFilter(filterValues: filterValues)
                        self.mainAnimationView.applyToneCurveFilter(filterValues: filterValues)
                    }
                    self.weatherScene.stopScene()
                    self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
                    self.weatherScene.startScene(.hot)
                case .cloudy:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.image = backgroundImage
                    }

                    self.weatherScene.stopScene()
                    self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
                    self.weatherScene.startScene(.cloudy, duration: 63.0)
                case .comet:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.image = backgroundImage
                    }

                    self.weatherScene.stopScene()
                    self.weatherScene.isGraphicsDebugOptionEnabled = self.segment.selectedSegmentIndex == 0
                    self.weatherScene.startScene(.comet)
                default:
                    self.weatherScene.extraEffectBlock = { (backgroundImage, opacity) in
                        self.mainUpperImageView.image = backgroundImage
                    }

                    self.weatherScene.stopScene()
                }
            }

            cell.stopWeatherBlock = {
                self.mainUpperImageView.image = nil

                self.weatherScene.stopScene()
            }

            cell.removeToneFilterBlock = {
                self.initMainAnimation()
                self.mainBackgroundImageView.stop({
                    self.mainBackgroundImageView.removeToneCurveFilter()
                })
            }

            cell.birthRateDidChange = { (birthRate) in
                self.weatherScene.birthRate = birthRate
            }

            return cell
        }
    }

    func changedMainState() {
        switch self.weatherScene.weatherType {
        case .snow:
            let sceneSize: CGSize = self.weatherScene.size
            if self.btnOne.isSelected {
                self.weatherScene.subGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.290, y: sceneSize.height * 0.572)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.237, y: sceneSize.height * 0.530)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.188, y: sceneSize.height * 0.484)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.101, y: sceneSize.height * 0.475), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.752, y: sceneSize.height * 0.748), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.829, y: sceneSize.height * 0.602), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.663, y: sceneSize.height * 0.556), rangeRatio: 0.078, degree: -27.0)]
            } else {
                let diffY: CGFloat = 0.07
                self.weatherScene.subGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.290, y: sceneSize.height * (0.572 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.237, y: sceneSize.height * (0.530 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.188, y: sceneSize.height * (0.484 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.101, y: sceneSize.height * (0.475 - diffY)), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.752, y: sceneSize.height * (0.748 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.829, y: sceneSize.height * (0.602 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.663, y: sceneSize.height * (0.556 + diffY)), rangeRatio: 0.078, degree: -27.0)]
            }
        case .rain:
            let sceneSize: CGSize = self.weatherScene.size
            if self.btnOne.isSelected {
                self.weatherScene.subGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.290, y: sceneSize.height * 0.572)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.237, y: sceneSize.height * 0.530)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.188, y: sceneSize.height * 0.484)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.101, y: sceneSize.height * 0.475), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.752, y: sceneSize.height * 0.748), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.829, y: sceneSize.height * 0.602), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.663, y: sceneSize.height * 0.556), rangeRatio: 0.078, degree: -27.0)]
            } else {
                let diffY: CGFloat = 0.07
                self.weatherScene.subGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.307, y: sceneSize.height * (0.590 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.261, y: sceneSize.height * (0.544 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.208, y: sceneSize.height * (0.497 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.122, y: sceneSize.height * (0.481 - diffY)), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.778, y: sceneSize.height * (0.761 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.855, y: sceneSize.height * (0.614 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.684, y: sceneSize.height * (0.565 + diffY)), rangeRatio: 0.078, degree: -27.0)]
            }
        default:
            break
        }
    }
}
