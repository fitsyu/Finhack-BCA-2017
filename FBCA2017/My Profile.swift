//
//  My Profile.swift
//  FBCA2017
//
//  Created by Fitsyu on 26/08/2017.
//  Copyright © 2017 Yada Yada. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyProfile_ViewController: UIViewController
{
    
    // MARK: OUtlets
    @IBOutlet weak var txDigitalID: UILabel!
    @IBOutlet weak var txBankAccount: UILabel!
    @IBOutlet weak var txBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: Properties
    var transactions: [TransactionEntry] = []
    
    override func viewDidLoad() {
        
        txDigitalID.text = User.DigitalID
        
        txBankAccount.text = User.BankAccountNumber.isEmpty ? "---" : User.BankAccountNumber
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        getUserBalance()
        
    }
    
    func getUserBalance()
    {
        
        let p = "user_id=\(User.DigitalID)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        netCall(to: "http://182.16.165.106/get_user_balance.php?\(p)",
                using: .get,
                with: [:],
                ifOKThen: {  json in
        
        
                    
                    let accountNumber = json["accountNumber"].stringValue
                    self.txBankAccount.text = accountNumber
                    
                    // save
                    User.BankAccountNumber = accountNumber
                    
                    let balance       = json["balance"].intValue
                    self.txBalance.text = balance.IDR
                    
                    self.getHistory()
        })
    }
    
    func getHistory()
    {
         let p = "user_id=\(User.DigitalID)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        
        
        netCall(to: "http://182.16.165.106/get_user_history.php?\(p)",
                using: .get,
                with: [:],
                ifOKThen: {  json in
       
                    self.reloadCells(source: json["data"])
                    
        })

    }
    
    func reloadCells(source: JSON)
    {
        guard !source.arrayValue.isEmpty else { return }
        
        // slowly and elegantly insert each one into the table view
        var i = 0
        Timer.scheduledTimer(withTimeInterval: TimeInterval(0.25),
                             repeats: true)
        {
            timer in
            
            // extraact
            let rawTrx = source[i]
            let tipe   = rawTrx["transactionType"].stringValue
            
            let amount = rawTrx["transactionAmount"].intValue
            
            
            let tgl    = rawTrx["transactionDate"].stringValue
            
            let dTgl = SIPDateFormatter.ddMMMMyyyy.date(from: tgl) ?? Date()
            
            let trx = TransactionEntry(tipe: tipe, tgl: dTgl, amount: amount)
            
            
            self.transactions.append( trx )

            
            
            let indexPath = IndexPath(row: i, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .right)
            
            i += 1
            if i >= source.arrayValue.count {
                timer.invalidate()
                
                guard !self.transactions.isEmpty else { return }
                
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
            }
        }
    }
}


extension MyProfile_ViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionEntryCell.ID, for: indexPath) as! TransactionEntryCell
        cell.data = transactions[indexPath.row]
        return cell
    }
}

struct TransactionEntry
{
    let tipe: String // K | D
    let tgl: Date
    let amount: Int
}

class TransactionEntryCell: UITableViewCell
{
    static let ID = "TransactionEntryCell"
    
    
    // OUTLET
    @IBOutlet weak var txTgl: UILabel!
    @IBOutlet weak var txTipeAndAmount: UILabel!
    
    var data: TransactionEntry!
    {
        didSet
        {
            let dts = SIPDateFormatter.ddMMMMyyyy.string(from: data.tgl)
            txTgl.text = dts
            
            txTipeAndAmount.text = "(\(data.tipe)) \(data.amount.IDR)"
            
        }
    }
}
