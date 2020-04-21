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
    
    private var drawerHeight: CGFloat = 0
    private var drawerHandleHeight: CGFloat = 50
    private var bottomInset: CGFloat = 0
    private var drawerVisible: Bool = false
    private var nextState: DrawerState {
        return drawerVisible ? .collapsed : .expanded
    }
    private var runningAnimations = [UIViewPropertyAnimator]()
    private let animationDuration: TimeInterval = 1
    private var animationProgressWhenInterrupted: CGFloat = 0
    private var reverse = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewSafeAreaInsetsDidChange() {
        setUpViews()
    }
    
    private func setUpViews() {
        bottomInset = self.view.safeAreaInsets.bottom
        drawerHeight = self.view.frame.height - 100
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        guard let drawerViewController = self.storyboard?.instantiateViewController(identifier: DrawerViewController.controllerId) as? DrawerViewController else {
            return
        }
        self.addChild(drawerViewController)
        self.view.addSubview(drawerViewController.view)
        drawerViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - drawerHandleHeight - bottomInset, width: self.view.frame.width, height: drawerHeight + bottomInset)
        
        drawerViewController.view.clipsToBounds = true
        self.drawerViewController = drawerViewController
        
        addGestures()
    }
    
    
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDrawerTap(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrawerPan(recognizer:)))
        
        drawerViewController?.handleView.addGestureRecognizer(tapGesture)
        drawerViewController?.handleView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleDrawerTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: animationDuration)
        default:
            break
        }
    }
    
    @objc private func handleDrawerPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveAnimation(state: nextState, duration: animationDuration)
        case .changed:
            let translation = recognizer.translation(in: self.drawerViewController?.handleView)
            var fractionComplete = translation.y / drawerHeight
            setReverseFlag(panGesture: recognizer)
            fractionComplete = drawerVisible ? fractionComplete : -fractionComplete
            updateInteractiveAnimation(fractionCompleted: fractionComplete)
        case .ended:
            if reverse {
                reverseRunningAnimations()
                self.drawerVisible = !self.drawerVisible
                continueInteractiveAnimation()
            } else {
                continueInteractiveAnimation()
            }
            
       default:
            break
        }
    }
    
    private func setReverseFlag(panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: self.view).y
        if velocity.absolute() >= 50 {
            if (velocity > 0 &&  drawerVisible) || (velocity < 0 && !drawerVisible) {
                reverse = false
            } else {
                reverse = true
            }
        }
    }
    
    private func animateTransitionIfNeeded(state: DrawerState, duration: TimeInterval) {
        addDrawerAnimation(state: state, duration: duration)
        addCornerRadiusAnimation(state: state, duration: duration)
        addBackGroundBlurAnimation(state: state, duration: duration)
        addCommentFontChangeAnimation(state: state, duration: duration)
    }
    
    private func addDrawerAnimation(state: DrawerState, duration: TimeInterval) {
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.drawerViewController?.view.frame.origin.y = self.view.frame.height - self.drawerHeight
            case .collapsed:
                self.drawerViewController?.view.frame.origin.y = self.view.frame.height - self.drawerHandleHeight - self.bottomInset
            }
        }
        frameAnimator.addCompletion { (_) in
            self.drawerVisible = !self.drawerVisible
            self.runningAnimations.removeAll()
        }
        
        frameAnimator.startAnimation()
        runningAnimations.append(frameAnimator)
    }
    
    private func addCornerRadiusAnimation(state: DrawerState, duration: TimeInterval) {
        let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            switch state {
            case .collapsed:
                self.drawerViewController?.view.layer.cornerRadius = 0
            case .expanded:
                self.drawerViewController?.view.layer.cornerRadius = 10
            }
        }
        cornerRadiusAnimator.startAnimation()
        runningAnimations.append(cornerRadiusAnimator)
    }
    
    private func addBackGroundBlurAnimation(state: DrawerState, duration: TimeInterval) {
        let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .collapsed:
                self.visualEffectView?.effect = nil
            case .expanded:
                self.visualEffectView.effect = UIBlurEffect(style: .dark)
            }
        }
        blurAnimator.startAnimation()
        runningAnimations.append(blurAnimator)
    }
    
    private func addCommentFontChangeAnimation(state: DrawerState, duration: TimeInterval) {
        let fontChangeAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .collapsed:
                self.drawerViewController?.lblBlue.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.drawerViewController?.lblBlack.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.drawerViewController?.lblBlue.alpha = 1
                self.drawerViewController?.lblBlack.alpha = 0
            case .expanded:
                self.drawerViewController?.lblBlue.transform = CGAffineTransform.identity
                self.drawerViewController?.lblBlack.transform = CGAffineTransform.identity
                self.drawerViewController?.lblBlue.alpha = 0
                self.drawerViewController?.lblBlack.alpha = 1
            }
        }
        fontChangeAnimation.startAnimation()
        runningAnimations.append(fontChangeAnimation)
    }
    
    private func removeAlreadyRunningAnimations() {
        for animator in runningAnimations {
            animator.finishAnimation(at: .current)
        }
    }
    
    private func startInteractiveAnimation(state: DrawerState, duration: TimeInterval) {
        removeAlreadyRunningAnimations()
        animateTransitionIfNeeded(state: state, duration: duration)
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
    
    private func reverseRunningAnimations() {
        for animator in runningAnimations {
            animator.isReversed = true
        }
    }
    
    private func continueInteractiveAnimation() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.6)
        }
    }


}

extension CGFloat {
    func absolute() -> CGFloat {
        if self < 0 {
            return -self
        } else {
            return self
        }
    }
}

