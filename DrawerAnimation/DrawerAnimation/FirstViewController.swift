//
//  FirstViewController.swift
//  DrawerAnimation
//
//  Created by vinsol on 09/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    private enum DrawerState {
        case expanded, collapsed
    }
    
    private var drawerViewController: DrawerViewController!
    private var visualEffectView: UIVisualEffectView!
    
    private var drawerHeight: CGFloat!
    private var drawerHandleHeight: CGFloat = 50
    
    private var drawerVisible: Bool = false
    private var nextState: DrawerState {
        return drawerVisible ? .collapsed : .expanded
    }
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawerHeight = self.view.frame.height - 100
        setUpViews()
    }
    
    private func setUpViews() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        drawerViewController = self.storyboard?.instantiateViewController(identifier: DrawerViewController.controllerId) as! DrawerViewController
        self.addChild(drawerViewController)
        self.view.addSubview(drawerViewController.view)
        drawerViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - drawerHandleHeight, width: self.view.frame.width, height: drawerHeight)
        
        drawerViewController.view.clipsToBounds = true
    }
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDrawerTap(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrawerPan(recognizer:)))
        
        drawerViewController.handleView.addGestureRecognizer(tapGesture)
        drawerViewController.handleView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleDrawerTap(recognizer: UITapGestureRecognizer) {
        
    }
    
    @objc private func handleDrawerPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveAnimation(state: nextState, duration: 1)
        case .changed:
            updateInteractiveAnimation(fractionCompleted: 0)
        case .ended:
            continueInteractiveAnimation()
       default:
            break
        }
    }
    
    private func animateTransitionIfNeeded(state: DrawerState, duration: TimeInterval) {
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.drawerViewController.view.frame.origin.y = self.view.frame.height - self.drawerHeight
            case .collapsed:
                self.drawerViewController.view.frame.origin.y = self.view.frame.height - self.drawerHandleHeight
            }
        }
        frameAnimator.addCompletion { (_) in
            self.drawerVisible = !self.drawerVisible
            self.runningAnimations.removeAll()
        }
        
        frameAnimator.startAnimation()
        runningAnimations.append(frameAnimator)
    }
    
    private func startInteractiveAnimation(state: DrawerState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateInteractiveAnimation(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractiveAnimation() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }


}

