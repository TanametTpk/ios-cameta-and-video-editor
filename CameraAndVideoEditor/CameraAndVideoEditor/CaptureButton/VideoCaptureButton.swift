//
//  VideoCaptureButton.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 14/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit

class VideoCaptureButton: UIView {
    
    var container:UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        return view
        
    }()
    
    var redDot:UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8584103576, green: 0.1771459721, blue: 0.3682487971, alpha: 1)
        view.layer.shadowColor = #colorLiteral(red: 0.8584103576, green: 0.1771459721, blue: 0.3682487971, alpha: 1).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        return view
        
    }()
    
    var stopDot:UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.alpha = 0
        
        return view
        
    }()
    
    var recordAnimator:UIViewPropertyAnimator?
    var stopRecordAnimator:UIViewPropertyAnimator?
    var showStopDotAnimator:UIViewPropertyAnimator?
    var backToIdentityAnimator:UIViewPropertyAnimator?
    var isRec:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.layer.cornerRadius = container.bounds.height / 2
        redDot.layer.cornerRadius = redDot.bounds.height / 2
        stopDot.layer.cornerRadius = stopDot.bounds.height / 4
        
    }
    
    private func setup(){
        
        setupContainer()
        setupRedDot()
        setupStopDot()
        
    }
    
    private func setupContainer(){
        
        addSubview(container)
        container.frame = frame
        
    }
    
    private func setupRedDot(){
        
        addSubview(redDot)
        redDot.frame = CGRect(x: 0, y: 0, width: frame.width / 3.5, height: frame.height / 3.5)
        redDot.center = container.center
        
    }
    
    private func setupStopDot(){
        
        addSubview(stopDot)
        stopDot.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        stopDot.center = container.center
        
    }
    
    public func startRecord(){
        
        isRec = true
        let scaleSize = container.frame.height / redDot.frame.height
        let stopDotScaleSize = redDot.frame.height
        
        self.recordAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
            
            // red dot resize to same as container
            self.redDot.transform = CGAffineTransform(scaleX: scaleSize, y: scaleSize)
            self.container.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        })
        
        self.showStopDotAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeOut, animations: {
            
            // hide container
            self.container.isHidden = true
            
            // show stopDot
            self.stopDot.alpha = 1
            
            self.stopDot.transform = CGAffineTransform(scaleX: stopDotScaleSize, y: stopDotScaleSize)
            
        })
        
        stopAnimation()
        self.recordAnimator?.startAnimation()
        self.showStopDotAnimator?.startAnimation(afterDelay: 0.3)
        
    }
    
    public func stopRecord(){
        
        isRec = false
        
        self.stopRecordAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeOut, animations: {
            
            // show container
            self.container.isHidden = false
            
            // resize stopDot
            self.stopDot.transform = CGAffineTransform.identity
            
        })
        
        self.backToIdentityAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
            
            self.stopDot.alpha = 0
            
            // red dot resize to identity
            self.redDot.transform = CGAffineTransform.identity
            self.container.transform = CGAffineTransform.identity
            
        })
        
        stopAnimation()
        self.stopRecordAnimator?.startAnimation()
        self.backToIdentityAnimator?.startAnimation(afterDelay: 0.1)
        
    }
    
    public func stopAnimation(){
        
        let animators = [
            recordAnimator,
            showStopDotAnimator,
            stopRecordAnimator,
            backToIdentityAnimator
        ]
        
        for animator in animators{
            
            guard let isRunning = animator?.isRunning else {continue}
            if isRunning {
                
                animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                
            }
            
        }
        
    }
    
}
