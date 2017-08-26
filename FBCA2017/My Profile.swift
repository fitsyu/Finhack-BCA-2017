//
//  My Profile.swift
//  FBCA2017
//
//  Created by Fitsyu on 26/08/2017.
//  Copyright © 2017 Yada Yada. All rights reserved.
//

import UIKit

class MyProfile_ViewController: UIViewController
{
    
    // MARK: OUtlets
    @IBOutlet weak var txDigitalID: UILabel!
    @IBOutlet weak var txBankAccount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    var transactions: [TransactionEntry] = []
    
    override func viewDidLoad() {
        
        transactions = [
        
//            TransactionEntry(tipe: "D", tgl: Date(), amount: 10000),
//            TransactionEntry(tipe: "D", tgl: Date(), amount: 100400),
//            TransactionEntry(tipe: "K", tgl: Date(), amount: 12000),
//            TransactionEntry(tipe: "K", tgl: Date(), amount: 100300),
//            TransactionEntry(tipe: "D", tgl: Date(), amount: 100010),

        ]
        
        
        txDigitalID.text = User.DigitalID
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
                    //let balance       = json["balance"].intValue
                    
                    self.txBankAccount.text = accountNumber
                    
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
                    
          
                    for rawTrx in json["data"].arrayValue
                    {
                        let tipe   = rawTrx["transactionType"].stringValue
                        
                        let amount = rawTrx["transactionAmount"].intValue
                        
                        
                        let tgl    = rawTrx["transactionDate"].stringValue
                        
                        let dTgl = SIPDateFormatter.ddMMMMyyyy.date(from: tgl) ?? Date()
                        
                        let trx = TransactionEntry(tipe: tipe, tgl: dTgl, amount: amount)
                        
                        
                        self.transactions.append( trx )
                        
                    }
                    
                    self.tableView.reloadData()
                    
        })

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
