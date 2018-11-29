//
//  MainPageViewController.swift
//  EmojiInkMessaging
//
//  Created by Harrison Wideman on 12/15/16.
//  Copyright © 2016 Tight. All rights reserved.
// 
//  Source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
//

import UIKit

class MainPageViewController: UIPageViewController {

    private(set) lazy var setOfViewControllers: [UIViewController] = []
    var currentViewController:UIViewController?
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle,
                  navigationOrientation: UIPageViewControllerNavigationOrientation,
                  options: [String : Any]? = nil){
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CBColor.brand_green()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.frame = (self.parent?.view.frame)!
    }
    
    func insert( viewController:UIViewController ) {
        setOfViewControllers.append(viewController)
        currentViewController = viewController
        setViewControllers([currentViewController!],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    func setViewController(_ viewController:UIViewController){
        self.addChildViewController(viewController)
        self.insert(viewController: viewController)
        viewController.didMove(toParentViewController: self)
    }
    
    func goBack( by num:Int ){
        for _ in 1...num {
            (setOfViewControllers.popLast())
        }
        currentViewController = setOfViewControllers.last
        setViewControllers([currentViewController!],
                           direction: .reverse,
                           animated: true,
                           completion: nil)
    }
    
}
