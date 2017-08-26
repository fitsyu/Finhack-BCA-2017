//
//  Login.swift
//  FBCA2017
//
//  Created by Fitsyu on 26/08/2017.
//  Copyright © 2017 Yada Yada. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController
{
    
    @IBOutlet weak var txDigitalID: UITextField!
    @IBOutlet weak var txPassword: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        scrollView.makeAwareOfKeyboard()
     
        setupTextfields()
        
        txDigitalID.text = "8893-2322"
    }
    
    var textFields: [UITextField] = []
    
    
    @IBAction func btLogin_Pressed(_ sender: UIButton)
    {
        
        for tf in [txDigitalID, txPassword] {
            if tf!.text!.isEmpty {
                tf?.spotted(forWhile: 1)
                return
            }
        }
        
        
        User.DigitalID = txDigitalID.text!
        User.Password  = txPassword.text!
        
        
        
        let box = displayWaitingBox(message: "Mohon tunggu")
        
        Timer.scheduledTimer(withTimeInterval: 1.0,
                             repeats: false,
                             block: { _ in
                                
                                
                                
                                
                                
                                box.dismiss(animated: true, completion: {
                                
                                    if User.Password == "secret"
                                    {
                                        self.performSegue(withIdentifier: "afterLogin", sender: self)
                                    } else {
                                        self.displayErrorBox(message: "Wrong Username || Password")
                                    }
                                    
                                
                                })
                                    

        })
        
        
    }
}

extension Login_ViewController: UITextFieldDelegate
{
    func setupTextfields() {
        textFields = [ txDigitalID, txPassword]
        
        textFields.forEach() {
            textField in
            textField.delegate = self
        }
    }
    
  
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close the text field
        textField.resignFirstResponder()
        
        // get index of this text field
        if let index = textFields.index(of: textField) {
            
            // get next text field if any
            let next = textFields.index(after: index)
            
            if next < textFields.count {
                
                // open next text field
                let nextField = textFields[next]
                nextField.becomeFirstResponder()
            }
        }
        
        return true
    }
}
