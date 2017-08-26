//
//  Credentials.swift
//  FBCA2017
//
//  Created by Fitsyu on 25/08/2017.
//  Copyright © 2017 Yada Yada. All rights reserved.
//

import Foundation

final class Credentials
{
    class eWallet
    {
        class Company
        {
            static let Name = "PT Finhacks eWallet 88801"
            static let Code = "88801"
        }
        
        class Client
        {
            static let ID = "268b2069-b099-4fa2-8148-1f1c0327fe63"
            static let Secret = "b383c35d-3c11-4ce6-b631-8767f4c2084b"
        }
        
        class API
        {
            static let Key = "0dfb11cd-b140-40cd-b65a-220e9998a129"
            static let Secret = "199505e4-9d5f-4ba9-bb96-a3ea8b2f69c1"
        }
        
        static let OAuth = "MjY4YjIwNjktYjA5OS00ZmEyLTgxNDgtMWYxYzAzMjdmZTYzOmIzODNjMzVkLTNjMTEtNGNlNi1iNjMxLTg3NjdmNGMyMDg0Yg=="
    }
    
    class BussinessBanking
    {
        static let CorporateID = "finhacks01"
     
        struct Account {
            let No: String
            let Name: String
        }
        
        static let accounts: [Account] =
        [
            Account(No: "8220000011", Name: "finhacks01 A"),
            Account(No: "8220000118", Name: "finhacks01 B")
        ]
        
        class Client
        {
            static let ID = "00a2cecf-57a9-495d-b337-05379481cea2"
            static let Secret = "90f866f0-0bb1-419f-bfcc-abd3ce65d0e1"
        }
        
        class API
        {
            static let Key = "1b6e44be-df70-4013-8a75-3d7abd2a8046"
            static let Secret = "60766ed9-2480-4f47-ab3f-68a5a719b54d"
        }
        
        static let OAuth = "MDBhMmNlY2YtNTdhOS00OTVkLWIzMzctMDUzNzk0ODFjZWEyOjkwZjg2NmYwLTBiYjEtNDE5Zi1iZmNjLWFiZDNjZTY1ZDBlMQ=="
    }
    
    class FIRE
    {
        static let CorporateID = "FHK1ID"
        static let AccessCode  = "rqdJtRKxhEeOk9jsxJCx"
        static let BranchCode  = "FHK1ID01"
        
        static let UserID      = "FHK1OPR1"
        static let LocalID     = "0405"
        
        static let AccountNumber = "8220002200"
        static let AccountName   = "FINHACKS01 C"
    }
    
    class Server
    {
        static let IPAddress    = "182.16.165.106happyday"
        static let User         = ""
        static let Password     = "Fin-klik@individu"
    }
}
