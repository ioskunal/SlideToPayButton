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
    
    override func layoutSubviews() {
        if !layoutSet {
            self.setUpButton()
            self.layoutSet = true
        }
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
    
    @IBInspectable var dragPointColor: UIColor = UIColor.red {
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
    
    func setUpButton() {
        self.layer.borderColor = borderColor.cgColor
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
            self.dragPointButtonLabel.text          = "sdadfasd"
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
        self.viewCut.frame = CGRect(x: 0, y: 0, width: 0, height: viewCut.frame.size.height)
        viewCut.clipsToBounds = true
        self.viewTitle.frame = viewCut.frame
        viewTitle.clipsToBounds = true
    }
}
