//
//  CheckUser.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

func checkUser(completion: @escaping  (Bool ,String)->Void){
    print("==> func checkout user")
    let db = Firestore.firestore()
    db.collection("users").getDocuments{
        (snap ,err) in
        
        if err != nil{
            print(err?.localizedDescription ?? nil!)
            return
        }
        
        for i in snap!.documents {
            if i.documentID == Auth.auth().currentUser?.uid{
                completion(true, i.get("name") as! String)
                return
            }
        }
        completion(false,"")
    }
}
