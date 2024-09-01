//
//  Submit Document.swift
//  FBCA2017
//
//  Created by Fitsyu on 26/08/2017.
//  Copyright © 2017 Yada Yada. All rights reserved.
//

import UIKit

class SubmitDocument_ViewController: UIViewController
{
    
    // MARK: Outlets
    @IBOutlet weak var txType: UITextField!
    @IBOutlet weak var txExecutedOn: UITextField!
    @IBOutlet weak var txAmount: UITextField!
    @IBOutlet weak var txOtherPartyID: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Actions
    @IBAction func btSave_Pressed(_ sender: UIBarButtonItem)
    {
        print("saving...")
        
        for tf in textFields {
            if tf.text!.isEmpty {
                tf.spotted(forWhile: 1.2)
                return
            }
        }
        
        let type = txType.text!
        let exeon = txExecutedOn.text!
        let amount = rawNominalInput.isEmpty ? "" : rawNominalInput
        let otherID = txOtherPartyID.text!
        
        let ownerID = User.DigitalID
        
        let par = "type=\(type)&executed_on=\(exeon)&amount=\(amount)&other_party_id=\(otherID)&owner_id=\(ownerID)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        netCall(to:    "http://182.16.165.106/add_submit_doc.php?\(par)",
            using: .get,
            with: [:],
            ifOKThen: { json in
                
                
                var msg = json.arrayValue.first?.stringValue ?? "nothing"
                
                if msg.lowercased() == "success"
                {
                    msg = "Dokumen berhasil disimpan"
                }
                
                self.displayMessageBox(title: "Status",
                                       message: msg,
                                       then: {
                                        
                                        self.navigationController?.popViewController(animated: true)
                })
                
//                self.performSegue(withIdentifier: "afterSubmitNewDoc", sender: self)
                
                
        })
        
    }
    
    override func viewDidLoad() {
        setupTextfields()
        
        scrollView.makeAwareOfKeyboard()
        
        
    }
    
    // MARK: Properties
    var textFields: [UITextField] = []
    
    var rawNominalInput: String = ""
    
    let typeOptions: [String] = ["P2P Lending", "Purchase Order"]
}


extension SubmitDocument_ViewController: UITextFieldDelegate
{
    func setupTextfields() {
        textFields = [ txType, txExecutedOn, txAmount, txOtherPartyID ]
        
        textFields.forEach() {
            textField in
            textField.delegate = self
        }
        
        // txType
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate   = self
        txType.inputView = picker
        let tb = UIToolbar.bar(title: "Type", rightButtonTitle: "Next")
        txType.inputAccessoryView = tb
        tb.items?.last?.action = #selector(self.closeTxType)
        txType.text = typeOptions.first
        
        // tx Amount
        let toolbar = UIToolbar.bar(title: "Amount", rightButtonTitle: "Next")
        txAmount.inputAccessoryView = toolbar
        toolbar.items?.last?.action = #selector(self.closeTxAmount)
        

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        switch textField
        {
        case txExecutedOn:
        
            openDatePicker(onDone: { date in
                
                let dts = SIPDateFormatter.ddMMyyyy.string(from: date)
                
                self.txExecutedOn.text = dts
                
            })
            return false

            
        default:
            return true
        }
    }
    
    @objc func closeTxAmount() {
        _ = textFieldShouldReturn(txAmount)
    }
    
    @objc func closeTxType()
    {
         _ = textFieldShouldReturn(txType)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // only for txNominal
        if textField == txAmount {
            
            
            // 'x' clear button pressed
            if string.isEmpty {
                
                if !rawNominalInput.isEmpty {
                    let preLast = rawNominalInput.index(before: rawNominalInput.endIndex)
                    rawNominalInput = rawNominalInput.substring(to: preLast)
                    
                }
                
            }
                // a number | char is pressed
            else {
                
                // only add if it is a number
                if let _ = Int(string) {
                    rawNominalInput += string
                }
                
            }
            
            
            // only update if it is IDRable
            if let n = Int(rawNominalInput) {
                txAmount.text = n.IDR
                //print(n.IDR)
            } else {
                txAmount.text = ""
                //print("not number \(rawNominalInput)")
            }
            
            // don't let user input mess with the hardwork above
            return false
        }
        
        
        return true
    }
}


extension SubmitDocument_ViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOptions.count
    }
}

extension SubmitDocument_ViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txType.text = typeOptions[row]
    }
}


