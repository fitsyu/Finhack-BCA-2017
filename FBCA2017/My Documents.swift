//
//  My Documents.swift
//  FBCA2017
//
//  Created by Fitsyu on 26/08/2017.
//  Copyright © 2017 Yada Yada. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyDocuments_ViewController: UIViewController
{
    
    // MARK: Object Life Cycle
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // set
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "blue logo"))
        
        txDigitalID.text = User.DigitalID
        
        
        if User.DigitalID == "8893-2322"
        {
            imgUser.setImage(#imageLiteral(resourceName: "U1"), for: .normal)
        }
        else
        {
            imgUser.setImage(#imageLiteral(resourceName: "U2"), for: .normal)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

          getDocs()
        
//        if documents.isEmpty {
//            getDocs()
//        }
        
    }

    
    func getDocs()
    {
        let params = "owner_id=\(User.DigitalID)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        netCall(to: "http://182.16.165.106/list_submit_doc.php?\(params)",
            using: .get,
            with: [:],
            ifOKThen: { json in
                
                
                
                self.refreshTableView(source: json)
                
        })
        
    }
    
    func refreshTableView(source: JSON)
    {
        // reset the currently displayed
        self.documents.removeAll()
        self.tableView.reloadData()
        
        guard !source.arrayValue.isEmpty else { return }
        
        // slowly and elegantly insert each one into the table view
        var i = 0
        Timer.scheduledTimer(withTimeInterval: TimeInterval(0.25),
                             repeats: true)
        {
            timer in
            
            // extraact
            let dj = source[i]
            
            let type   = dj["type"].stringValue
            let amount = dj["amount"].intValue
            
            let exeOn = dj["executed_on"].stringValue
            let opID  = dj["other_party_id"].stringValue
            
            let ownID = dj["owner_id"].stringValue
            let sha   = dj["sha256"].stringValue
            
            let dExeOn = SIPDateFormatter.ddMMMMyyyy.date(from: exeOn) ?? Date()
            
            let nDoc = Document(type: type, amount: amount, executedOn: dExeOn, otherID: opID, ownerID: ownID, sha: sha)
            
            self.documents.append( nDoc )
            
            
            let indexPath = IndexPath(row: i, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .right)
            
            i += 1
            if i >= source.arrayValue.count {
                timer.invalidate()
                
                guard !self.documents.isEmpty else { return }
                
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
            }
        }
        
        
        
    }
    
    
    // MARK: Actions
    @IBAction func afterSubmitNewDoc(segue: UIStoryboardSegue)
    {
        getDocs()
    }
    
    // MARK: Outlets
    @IBOutlet weak var txDigitalID: UILabel!

    @IBOutlet weak var imgUser: UIButton!
    
    @IBOutlet weak var vrfIcon: UIImageView!
    @IBOutlet weak var vrfLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    var documents: [ Document ] = [ ]
}

extension MyDocuments_ViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.ID, for: indexPath) as! DocumentCell
        
        cell.data = documents[indexPath.row]
        
        return cell
    }
}

extension   MyDocuments_ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


struct Document
{
    let type: String
    let amount: Int
    
    let executedOn: Date
    let otherID: String
    
    let ownerID: String
    let sha: String
}

class DocumentCell: UITableViewCell
{
    static let ID = "DocumentCell"
    
    var data: Document? {
        didSet{
            
            txType.text = data?.type
            
            txAmount.text = data?.amount.IDR
            
            txExecutedOn.text = SIPDateFormatter.ddMMMyyyy.string(from: data?.executedOn)
            
            //txOtherID.text = data?.otherID
            
            if data!.ownerID == User.DigitalID {
                lbOwnerType.text = "Lender ID"
                txOtherID.text = data?.otherID
                
            } else {
                lbOwnerType.text = "Owner ID"
                txOtherID.text = data?.ownerID
                
            }
            
            txSha.text = data?.sha
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var txType :UILabel!
    @IBOutlet weak var txAmount :UILabel!
    @IBOutlet weak var txExecutedOn :UILabel!
    @IBOutlet weak var txOtherID :UILabel!
    
    @IBOutlet weak var lbOwnerType: UILabel!
    @IBOutlet weak var txSha: UILabel!
}
