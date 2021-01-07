//
//  Home.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct Home : View {
   var body : some View {
       VStack{
           Text("Welcome \(UserDefaults.standard.value(forKey: "userName") as! String)")
           Button(action: {
               try! Auth.auth().signOut()
               UserDefaults.standard.set(false, forKey: "status")
               NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
           }){
               Text("Logout")
           }
       }
   }
}
