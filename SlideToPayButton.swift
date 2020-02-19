//
//  SlideToPayButton.swift
//  SlideToPayButton
//
//  Created by Kunal Gupta on 16/02/20.
//  Copyright © 2020 Kunal Gupta. All rights reserved.
//

import Foundation
import UIKit

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
    var dragPointButtonLabel = UILabel()
    var imageView            = UIImageView() // to set the image on the dragPoint
    var unlocked             = false // just to keep track
    var layoutSet            = false // to set the gradient on the button
    var viewCut              = UIView() //used for showingbackground behind the slider on left
    var viewTitle            = UIView() //used for showingbackground behind the slider on left
    
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
    
    @IBInspectable var dragPointColor: UIColor = UIColor.clear {
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
    
    @IBInspectable var imageName: UIImage = UIImage() {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonTextColor: UIColor = UIColor.black {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var dragPointTextColor: UIColor = UIColor.clear {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonUnlockedTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = 32 {
        didSet{
            setStyle()
        }
    }
    @IBInspectable var buttonUnlockedText: String   = ""
    @IBInspectable var buttonUnlockedColor: UIColor = UIColor.clear
    
    override func layoutSubviews() {
        if !layoutSet {
            addGradient()
            addBackgroundTitle()
            setUpButton()
            layoutSet = true
        }
    }
    
    func setStyle(){
        self.buttonLabel.text               = self.buttonText
        self.dragPointButtonLabel.text      = self.buttonText
        self.dragPoint.frame.size.width     = self.frame.height
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.backgroundColor                = self.buttonColor
        self.imageView.image                = imageName
        self.buttonLabel.textColor          = self.buttonTextColor
        self.dragPointButtonLabel.textColor = self.dragPointTextColor
        self.dragPoint.layer.cornerRadius   = buttonCornerRadius
        self.layer.cornerRadius             = buttonCornerRadius
    }
    
    func addGradient() {
        let color1 =  UIColor(red: 14/255.0, green: 179/255.0, blue: 146/255.0, alpha: 1.0)
        let color2 =  UIColor(red: 44/255.0, green: 213/255.0, blue: 138/255.0, alpha: 1.0)

        viewCut = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        viewCut.backgroundColor = UIColor.clear
        let colorTop = color1.cgColor
        let colorBottom = color2.cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        viewCut.layer.insertSublayer(gradient, at: 0)
        self.addSubview(viewCut)
        viewTitle = UIView(frame: viewCut.frame)
    }
    
    func addBackgroundTitle() {
        let labelTitle = UILabel(frame: viewTitle.frame)
        labelTitle.text = buttonText
        labelTitle.textAlignment = .center
        labelTitle.textColor = UIColor.white
        viewTitle.addSubview(labelTitle)
        self.addSubview(viewTitle)
    }
    
    func setUpButton() {
        self.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
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
            
            self.dragPointButtonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.dragPointButtonLabel.textAlignment = .center
            self.dragPointButtonLabel.text          = buttonText
            self.dragPointButtonLabel.textColor     = UIColor.white
            self.dragPointButtonLabel.textColor     = self.dragPointTextColor
            self.dragPoint.addSubview(self.dragPointButtonLabel)
        }
        self.bringSubviewToFront(self.dragPoint)
        
        self.imageView = UIImageView(frame: CGRect(x: self.frame.size.width - dragPointWidth, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        self.imageView.contentMode = .center
        self.imageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
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
           // reset the animation at this stage
            return
        } else if finalPoint2.x > self.frame.width {
            // call unlock here
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
                unlock()
            }
            
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIView.AnimationOptions.curveEaseOut, animations: {
            }, completion: { (status) in
                if status{
                    self.animationCompleted()
                }
            })
        }
    }
    
    func animationCompleted(){
        if !unlocked {
            reset()
        }
    }
    
    func reset(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.dragPointWidth - self.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
            self.viewCut.frame = CGRect(x: 0, y: 0, width: 0, height: self.viewCut.frame.size.height)
            self.viewTitle.frame = self.viewCut.frame
        }) { (status) in
            if status {
                self.dragPointButtonLabel.text      = self.buttonText
                self.dragPoint.backgroundColor      = self.dragPointColor
                self.dragPointButtonLabel.textColor = self.dragPointTextColor
                self.unlocked                       = false
            }
        }
    }
    
    func unlock() {
        if unlocked == false {
            unlocked = true
            UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
                self.dragPoint.frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
                self.viewCut.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.viewCut.frame.size.height)
                self.viewTitle.frame = self.viewCut.frame
            }) { (status) in
                if status {
//                    self.dragPointButtonLabel.text      = self.buttonUnlockedText
//                    self.dragPoint.backgroundColor      = self.buttonUnlockedColor
                    self.dragPointButtonLabel.textColor = self.buttonUnlockedTextColor
                }
            }
        }
    }
}
