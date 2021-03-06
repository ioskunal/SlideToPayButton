//
//  SlideToPayButton.swift
//  SlideToPayButton
//
//  Created by Kunal Gupta on 16/02/20.
//  Copyright © 2020 Kunal Gupta. All rights reserved.
//

import Foundation
import UIKit

protocol SwipeToPayDelegate: class {
    func buttonStatus(status:String, sender: SlideToPayButton)
}

class SlideToPayButton: UIView {
    
    //MARK:- INITIALIZERS
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    //MARK:- VARIABLES
    
    var dragPoint            = UIView()
    var buttonLabel          = UILabel()
    var imageView            = UIImageView() // to set the image on the dragPoint
    var unlocked             = false // just to keep track
    var layoutSet            = false // to set the gradient on the button
    var viewCut              = UIView() //used for showingbackground behind the slider on left
    var viewTitle            = UIView() //used for showingbackground title behind the slider on left
    var delegate             : SwipeToPayDelegate?

    @IBInspectable var dragPointWidth: CGFloat = 56 {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1) {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var dragPointColor: UIColor = UIColor.clear { // sets the background color of the view before the drag point button
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonColor: UIColor = UIColor.clear {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonText: String = "SLIDE TO TRANSFER".capitalized {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var imageName: UIImage = UIImage(named: "icRocket")! {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonTextColor: UIColor = UIColor.black {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = 32 {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var gradientColor1: UIColor = UIColor(red: 14/255.0, green: 179/255.0, blue: 146/255.0, alpha: 1.0) {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var gradientColor2: UIColor = UIColor(red: 44/255.0, green: 213/255.0, blue: 138/255.0, alpha: 1.0) {
        didSet{
            setStyle()
        }
    }
    
    override func layoutSubviews() {
        if !layoutSet {
            addGradient()
            addBackgroundTitle()
            setUpButton()
            layoutSet = true
        }
    }
    
    private func setStyle() {
        self.buttonLabel.text               = self.buttonText
        self.dragPoint.frame.size.width     = self.frame.height
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.backgroundColor                = self.buttonColor
        self.imageView.image                = imageName
        self.buttonLabel.textColor          = self.buttonTextColor
        self.dragPoint.layer.cornerRadius   = buttonCornerRadius
        self.layer.cornerRadius             = buttonCornerRadius
    }
    
    private func addGradient() {
        
        viewCut = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        viewCut.backgroundColor = UIColor.yellow
        let colorTop = gradientColor1.cgColor
        let colorBottom = gradientColor2.cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        viewCut.layer.insertSublayer(gradient, at: 0)
        self.addSubview(viewCut)
        viewTitle = UIView(frame: viewCut.frame)
    }
    
    private func addBackgroundTitle() {
        let labelTitle = UILabel(frame: viewTitle.frame)
        labelTitle.text = buttonText
        labelTitle.textAlignment = .center
        labelTitle.textColor = UIColor.white
        viewTitle.addSubview(labelTitle)
        self.addSubview(viewTitle)
    }
    
    private func setUpButton() {
        self.layer.borderColor            = borderColor.cgColor
        self.layer.borderWidth            = 1
        self.backgroundColor              = self.buttonColor
        
        self.dragPoint                    = UIView(frame: CGRect(x: dragPointWidth - self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.dragPoint.backgroundColor    = dragPointColor
        self.dragPoint.layer.cornerRadius = buttonCornerRadius
        self.addSubview(self.dragPoint)
        self.layer.cornerRadius = self.frame.height/2
        if !self.buttonText.isEmpty {
            
            self.buttonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.buttonLabel.textAlignment = .center
            self.buttonLabel.text          = buttonText
            self.buttonLabel.textColor     = UIColor.white
            self.buttonLabel.textColor     = self.buttonTextColor
            self.addSubview(self.buttonLabel)
            self.bringSubviewToFront(self.viewTitle)
        }
        self.bringSubviewToFront(self.dragPoint)
        
        self.imageView = UIImageView(frame: CGRect(x: self.frame.size.width - dragPointWidth, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        self.imageView.contentMode = .center
        self.imageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        self.imageView.image = imageName
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
        self.imageView.clipsToBounds = true
        self.dragPoint.addSubview(self.imageView)
        self.layer.masksToBounds = true
        
        // start detecting pan gesture
        let panGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
        self.viewCut.frame = CGRect(x: 0, y: 0, width: 0, height: viewCut.frame.size.height)
        viewCut.clipsToBounds = true
        self.viewTitle.frame = viewCut.frame
        viewTitle.clipsToBounds = true
    }
    
    @objc func panDetected(sender: UIPanGestureRecognizer) {
        var translatedPoint = sender.translation(in: self)
        translatedPoint = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        
        let finalPoint1 = CGPoint(x: translatedPoint.x, y: translatedPoint.y) // left point of the dragPoint/slider
        let finalPoint2 = CGPoint(x: translatedPoint.x + dragPointWidth, y: translatedPoint.y) // right point of the dragPoint/slider
        print("Point 1 \(finalPoint1)")
        print("Point 2 \(finalPoint2)")
        
        if finalPoint1.x < 0 {
            self.reset()
            return
        } else if finalPoint2.x > self.frame.width {
            self.unlock()
            return
        }
        
        sender.view?.frame.origin.x = (dragPointWidth - self.frame.size.width) + translatedPoint.x // view is dragPoint
        self.viewCut.frame = CGRect(x: 0, y: 0, width: translatedPoint.x + imageView.frame.size.width/2, height: viewCut.frame.size.height)
        self.viewTitle.frame = self.viewCut.frame
        
        if sender.state == .ended {
            
            let velocityX = sender.velocity(in: self).x * 0.2
            var finalX = translatedPoint.x + velocityX
            if finalX < 0 {
                finalX = 0
            } else if finalX + self.dragPointWidth  >  (self.frame.size.width - 40) { // checking if the point is 40 points near the end point then consider it at done.
                self.unlock()
            }
            
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIView.AnimationOptions.curveEaseOut, animations: {
            }, completion: { (Status) in
                if Status{
                    self.animationCompleted()
                }
            })
        }
    }
    
    private func animationCompleted(){
        if !unlocked {
            reset()
        }
    }
    
    internal func reset(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.dragPointWidth - self.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
            self.viewCut.frame = CGRect(x: 0, y: 0, width: 0, height: self.viewCut.frame.size.height)
            self.viewTitle.frame = self.viewCut.frame
        }) { (status) in
            if status {
                self.dragPoint.backgroundColor      = self.dragPointColor
                self.unlocked                       = false
            }
        }
    }
    
    private func unlock() {
        if unlocked == false {
            unlocked = true
            UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
                self.dragPoint.frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
                self.viewCut.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.viewCut.frame.size.height)
                self.viewTitle.frame = self.viewCut.frame
            }) { (status) in
                if status {
                    // call delegate here
                    self.delegate?.buttonStatus(status: "Unlocked", sender: self)
                }
            }
        }
    }
}
