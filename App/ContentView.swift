//
//  ContentView.swift
//  App
//
//  Created by Teneocto on 1/4/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View {
        NavigationView{
            VStack{
                if status {
                    Home()
                }
                else{
                    FirstPage()
                }
            }.onAppear{
                NotificationCenter.default.addObserver(forName: Notification.Name("statusChange"), object: nil, queue: .main){
                    (_) in
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    self.status = status
                }
            }
            
        }
    }
 }