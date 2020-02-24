//
//  ViewController.swift
//  SlideToPayButton
//
//  Created by Kunal Gupta on 16/02/20.
//  Copyright © 2020 Kunal Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- OUTLETS

    @IBOutlet weak var viewSlideToTransfer: SlideToPayButton!
    
    //MARK:- PREDEFINED
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSlideToTransfer.delegate = self
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Completed", message: "Swipe action has been completed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.viewSlideToTransfer.reset()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: SwipeToPayDelegate {
    
    func buttonStatus(status: String, sender: SlideToPayButton) {
        showAlert()
    }

}
