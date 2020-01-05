//
//  ViewController.swift
//  BottomSheet
//
//  Created by Vinoth on 4/1/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BottomView {
    
    lazy var bottomSheetViewController: BottomSheetViewController3States = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "BottomSheetViewController3States") as! BottomSheetViewController3States
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bottomSheetViewController.delegate = self

        self.addChild(bottomSheetViewController)
        self.view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.view.frame = CGRect(x: 0,
                                                      y: UIScreen.main.bounds.height - 100 ,
                                                      width: UIScreen.main.bounds.width,
                                                      height: UIScreen.main.bounds.height + 100 )
        bottomSheetViewController.view.clipsToBounds = false
    }
    
    func addUIVisualEffectsView(visualEffectView: UIVisualEffectView) {
        visualEffectView.frame = view.frame
          self.view.addSubview(visualEffectView)
      }
      

}

