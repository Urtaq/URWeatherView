//
//  PageViewController.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 8..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self

        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.5502320528, blue: 0, alpha: 1)

        let initialVC = self.viewControllers(at: 0)

        self.setViewControllers([initialVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }

    var backgroundColors: [UIColor] = [.red, .blue, .green, .yellow, .orange]

    func viewControllers(at index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pageContent") as! PageContentViewController
        vc.index = index
        vc.view.backgroundColor = self.backgroundColors[index]

        return vc
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 5
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        if index == 0 {
            return nil
        }

        index -= 1

        return self.viewControllers(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index

        index += 1

        if index == 5 {
            return nil
        }

        return self.viewControllers(at: index)
    }
}
