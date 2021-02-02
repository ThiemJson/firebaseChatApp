//
//  CreateUser.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

func CreateUser(name: String, about: String, imageData : Data , completion: @escaping (Bool) -> Void ){
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let uid = Auth.auth().currentUser?.uid
    
    storage.child("profilepic").child(uid!).putData(imageData, metadata: nil){
        (_,err) in
        
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }
        
        storage.child("profilepic").child(uid!).downloadURL{
            (url, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            db.collection("users").document(uid!).setData(["name":name, "about":about, "pic":"\(url!))","uid":uid!]){
                (err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                
                completion(true)
                
                UserDefaults.standard.set(true, forKey: "status")
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.set(uid, forKey: "UID")
                UserDefaults.standard.set("\(url!)", forKey: "pic")
                NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
            }
        }
    }
}
