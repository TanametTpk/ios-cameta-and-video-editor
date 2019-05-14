//
//  CameraCaptureButton.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 14/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit

class CameraCaptureButton:UIView{
    
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
    
    var currentAnimator:UIViewPropertyAnimator?
    
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
        
    }
    
    private func setup(){
        
        setupContainer()
        
    }
    
    private func setupContainer(){
        
        addSubview(container)
        container.frame = frame
        
    }

    public func startHoldAnimation(){
        
        let animator = UIViewPropertyAnimator(duration: 0.15, curve: .easeOut, animations: {
            
            self.container.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        })
        currentAnimator = animator
        
        animator.startAnimation()
        
    }
    
    public func startUnHoldAnimation(){
        
        let animator = UIViewPropertyAnimator(duration: 0.15, curve: .easeOut, animations: {
            
            self.container.transform = CGAffineTransform.identity
            
        })
        currentAnimator = animator
        
        animator.startAnimation()
        
    }
    
    public func stopAnimation(){
        
        currentAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        
    }
    
}
