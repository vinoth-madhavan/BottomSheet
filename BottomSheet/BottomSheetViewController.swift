//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Vinoth on 29/12/19.
//  Copyright © 2019 Vinoth. All rights reserved.
//

import UIKit

protocol BottomView {
    
    func addUIVisualEffectsView(visualEffectView: UIVisualEffectView)
}

class BottomSheetViewController: UIViewController {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var delegate: BottomView?

    @IBOutlet weak var gripperView: UIView!
    
    let cardHeight: CGFloat = 600
    let cardHandleArea: CGFloat = 150
    var parentView: UIView?
    var visualEffectView: UIVisualEffectView!
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationPrgressWhenInterrupted:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visualEffectView = UIVisualEffectView()
        
        self.delegate?.addUIVisualEffectsView(visualEffectView: visualEffectView)
        
        setupBottomSheetView()
        
        let tapGesterRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        let panGestureRecognizer =  UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        self.view.addGestureRecognizer(tapGesterRecognizer)
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    fileprivate func setupBottomSheetView() {

        // Gripper
        gripperView.layer.cornerRadius = 5
        
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowColor = UIColor.gray.cgColor
        self.view.layer.shadowOpacity = 10
        
    }
    
    
    @objc
    func handleCardTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionsIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
            
        case .began:
            //Start Transitions
            startInteractiveTransition(state: nextState, duration: 0.9)
            
        case .changed:
            //Update Transitions
            let translation = recognizer.translation(in: self.view)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
            
        case .ended:
            //Continue Transitions
            continueInteractionTransition()
            
        default:
            break
        }
    }
    
    func animateTransitionsIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations .isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.view.frame.origin.y = UIScreen.main.bounds.height - self.cardHeight
                case .collapsed:
                    self.view.frame.origin.y = UIScreen.main.bounds.height - self.cardHandleArea
                }
            }
            frameAnimator.addCompletion { (_) in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                 switch state {
                    case .expanded:
                        self.view.layer.cornerRadius = 12
                 case .collapsed:
                    self.view.layer.cornerRadius = 0
            }
        }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                default:
                    break
                    
                }
            }
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration:TimeInterval) {
        if runningAnimations .isEmpty {
            //run animations
            animateTransitionsIfNeeded(state: nextState, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationPrgressWhenInterrupted = animator.fractionComplete
        }
        
    }
    func updateInteractiveTransition(fractionCompleted:CGFloat)  {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationPrgressWhenInterrupted
        }
        
    }
    func continueInteractionTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
}
