//
//  BottomSheetViewController3States.swift
//  BottomSheet
//
//  Created by Vinoth on 4/1/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class BottomSheetViewController3States: UIViewController {
    
    enum State {
        
        case collapsed
        case halfscreen
        case fullscreen
    }
    
    enum PanDirection {
        case up
        case down
    }
    
    var delegate: BottomView?
    var currentState, nextState: State?
    var runningAnimations = [UIViewPropertyAnimator]()
    var visualEffectView: UIVisualEffectView!
    
    
    let cardHeight: CGFloat = UIScreen.main.bounds.height - 150
    
    let collapsedHeight = UIScreen.main.bounds.height - 150
    let halfScreenHeight = UIScreen.main.bounds.height / 2
    let fullscreenHeight:CGFloat = 150
    var animationPrgressWhenInterrupted:CGFloat = 0
    
    @IBOutlet var gripperView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectView = UIVisualEffectView()
        
        
        setupBottomSheetView()
        currentState = .collapsed
        let panGestureRecognizer =  UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        self.delegate?.addUIVisualEffectsView(visualEffectView: visualEffectView)
    }
    fileprivate func setupBottomSheetView() {
        // Gripper
        self.gripperView.layer.cornerRadius = 3
        self.view.layer.shadowRadius = 5
        self.view.layer.shadowColor = UIColor.gray.cgColor
        self.view.layer.shadowOpacity = 0.9
        
    }
    
    fileprivate func setNextState(panDirection panDirection: BottomSheetViewController3States.PanDirection) {
        
        switch currentState  {
        case .collapsed:
            switch panDirection {
            case .up:
                nextState = .halfscreen
            case .down:
                nextState = nil
                
            }
        case .halfscreen:
            switch panDirection {
            case .up:
                nextState = .fullscreen
            case .down:
                nextState = .collapsed
                
            }
        case .fullscreen:
            switch panDirection {
            case .up:
                nextState = nil
            case .down:
                nextState = .halfscreen
            }
        default:
            break
        }
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let panDirection: PanDirection = (translation.y > 0) ? .down : .up
        setNextState(panDirection: panDirection)
        
        switch recognizer.state {
            
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            
            var fractionComplete = translation.y / cardHeight
            fractionComplete = (translation.y > 0) ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
            
        case .ended:
            continueInteractionTransition()
            
        default:
            break
        }
        
    }
    
    func startInteractiveTransition(state: State?, duration:TimeInterval) {
        
        if runningAnimations .isEmpty {
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
    func animateTransitionsIfNeeded(state: State?, duration: TimeInterval) {
        
        guard let state = state else {
                   return
               }
        if runningAnimations .isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                
                switch state {
                    
                case .halfscreen:
                    self.view.frame.origin.y = self.halfScreenHeight
                    self.currentState = .halfscreen
                    
                case .fullscreen:
                    self.view.frame.origin.y = self.fullscreenHeight
                    self.currentState = .fullscreen
                    
                    
                case .collapsed:
                    self.view.frame.origin.y = self.collapsedHeight
                    self.currentState = .collapsed
                    
                default:
                    break
                }
                
            }
            frameAnimator.addCompletion({ (_) in
                self.runningAnimations.removeAll()
            })
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .fullscreen, .halfscreen:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                default:
                    break
                    
                }
            }
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                 switch state {
                 case .fullscreen:
                        self.view.layer.cornerRadius = 12
                 case .halfscreen:
                    self.view.layer.cornerRadius = 6
                 case .collapsed:
                    self.view.layer.cornerRadius = 0
            }
        }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        
    }
    
    }
    
}
