//
//  Common.swift
//  FBCA2017
//
//  Created by Fitsyu on 26/08/2017.
//  Copyright © 2017 Yada Yada. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PopupDialog
import BDatePicker

final class SafeDateFormatter: DateFormatter {
    
    override func string(from date: Date?) -> String {
        guard let date = date else {
            return "unspecified"
        }
        
        return super.string(from: date)
    }
}

final class SIPDateFormatter {
    
    static var HHmm: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }
    
    static var ddMMyyyy: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    
    static var ddMMMyyyy: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    static var EEEddMMMMyyyy: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter
    }
    
    static var yyyyMMdd: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static var yyyyMMddHHmmss: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    static var yyyyMMddHHmm: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    static var ddMMMMyyyy: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    static var ddMMMMyyyyHHmmss: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "dd MMMM yyyy, HH:mm:ss"
        return formatter
    }
    
    static var ddMMMMyyyyHHmm: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter
    }
    
    static var d: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "d"
        return formatter
    }
    
    static var MMMyyyyEEEE: SafeDateFormatter {
        let formatter = SafeDateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "MMM  yyyy EEEE"
        return formatter
    }
}

class ID {
    static let formatter: NumberFormatter = {
        
        let nf = NumberFormatter()
        nf.groupingSize = 3
        nf.groupingSeparator = "."
        nf.usesGroupingSeparator = true
        
        return nf
    }()
}
extension Int {
    
    /// Usage:
    /// 1_500_000.IDR
    var IDR: String {
        return "IDR " + self.noIDR
    }
    
    var noIDR: String {
        if let string =  ID.formatter.string(from: NSNumber(value: self)) {
            return string
        } else {
            print( "failed to convert \(self)" )
            return ""
        }
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor  {
        get {
            return tintColor
        }
        set {
            tintColor = newValue
            layer.borderColor = tintColor.cgColor
        }
    }
}


extension UIViewController
{
    /// shows message along with busy indicator
    /// floating on top of UIViewController
    func displayWaitingBox(message: String) -> PopupDialog {
        
        let waitingBox = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "WaitingBox")
            as! WaitingBox
        
        waitingBox.message = message
        
        let popup = PopupDialog(viewController: waitingBox,
                                buttonAlignment: .horizontal,
                                transitionStyle: .fadeIn,
                                gestureDismissal: false,
                                completion: nil)
        
        self.present(popup,
                     animated: true,
                     completion: nil)
        
        return popup
    }
    
    func displayMessageBox(title: String, message: String, then: (()->Void)? = nil ) {
        
        let msgBox = PopupDialog(title: title,
                                 message: message,
                                 image: nil,
                                 buttonAlignment: .horizontal,
                                 transitionStyle: .zoomIn,
                                 gestureDismissal: false,
                                 completion: nil)
        
        msgBox.addButton(PopupDialogButton(title: "OK"){
            
//            msgBox.dismiss(animated: true, completion: {
//                print("then")
                then?()
//            })
        })
        
        self.present(msgBox, animated: true)
    }

    
    /// shows a nice floating box
    /// along with error message
    func displayErrorBox(message: String) {
        let errorBox = PopupDialog(title: "Perhatian",
                                   message: message)
        
        errorBox.addButton(PopupDialogButton(title: "OK"){ /* do nothing */ })
        
        self.present(errorBox, animated: true)
    }

    
    func netCall(to url: String,
                 using method: HTTPMethod = .get,
                 with param: Parameters = [:],
                 
                 // Call Success Handler
        ifOKThen OKHandler: ((JSON)->Void)? = nil,
        butIfNot NotHandler: ((JSON)->Void)? = nil,
        
        // Call Error Handler
        ifError ErrorHandler: ((Error)->Void)? = nil)
    {
        
        // early diagnostic
        //        print(url)
        //        print(JSON(param))
        
        print(url)
        print( JSON(param) )
        
        
        
        // cover up existing UI
        let popup = displayWaitingBox(message: "mohon tunggu..")
        
        // get to work
        Alamofire
            
            .request(url,
                     method: method,
                     parameters: param)
            
            .responseJSON(completionHandler: { response in
                
                popup.dismiss() {
                    
                    
                    // network level check
                    switch response.result {
                        
                    case .success(let value):
                        
                        // response level check
                        let json = JSON(value)
                        
                        // diagnostic
                        print("========================")
                        print(json)
                        print("========================")
                        print()
                        
                        
                        
                        // done
                        
                        print("SUCCESS!")
                        
                        // call handler if it installed
                        OKHandler?(json)
                        
                       
                        
                        
                        
                    case .failure(let error):
                        
                        // call your error handler if provided
                        // else
                        // display error message in good manner by default
                        
                        if ErrorHandler != nil {
                            ErrorHandler?(error)
                        } else {
                            self.displayErrorBox(message: error.localizedDescription)
                        }
                        
                        print(error.localizedDescription)
                        
                    }
                }
                
                
            })
        
    }
    
    /// display calendar picker
    /// floating on top of UIViewController
    func openDatePicker(onDone handler: @escaping (_ date: Date?)->Void ) {
        _ = BDatePicker.show(on: self, handledBy: handler)
    }

}

extension UIToolbar {
    /// create simple toolbar with done button on the right
    /// assign what done button do with: defaultPickerToolbar().items.last.(target & action) property
    static func bar(title: String = "", rightButtonTitle: String = "Done") -> UIToolbar {
        let pickerToolbar = UIToolbar()
        
        pickerToolbar.items = []
        if !title.isEmpty{
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            titleLabel.text = title
            let title = UIBarButtonItem(customView: titleLabel)
            pickerToolbar.items = [title]
        }
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: rightButtonTitle, style: .done, target: nil, action:nil)
        
        pickerToolbar.items! += [space, doneButton]
        
        
        pickerToolbar.isUserInteractionEnabled = true
        pickerToolbar.sizeToFit()
        return pickerToolbar
    }
}

extension UIScrollView {
    
    func makeAwareOfKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyBoardDidShow(notification: Notification) {
        
        let info = notification.userInfo as NSDictionary?
        let rectValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let kbSize = rectValue.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
        
        
    }
    
    func keyBoardWillHide(notification: Notification) {
        
        // restore content inset to 0
        let contentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.contentInset = contentInsets
        
        self.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}


extension UITextField
{
    func spotted() {
        borderColor  = UIColor.red
        borderWidth  = 2
        cornerRadius = 6
    }
    
    func spotted(forWhile: TimeInterval) {
        let preSpottedColor = tintColor!
        spotted()
        Timer.scheduledTimer(withTimeInterval: forWhile, repeats: false) { _ in
            self.borderColor = preSpottedColor
            self.unspotted()
        }
    }
    
    func unspotted() {
        borderWidth  = 0
        cornerRadius = 0
    }
}

import NVActivityIndicatorView
final class WaitingBox: UIViewController {
    
    static let ID = "WaitingBox"
    
    // MARK: Settables
    var message: String = "Wait please!"
    
    // MARK: Outlets
    @IBOutlet weak var txMessage: UILabel!
    
    @IBOutlet weak var gear2: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txMessage.text = message
        
        gear2.startAnimating()
    }
    
}

