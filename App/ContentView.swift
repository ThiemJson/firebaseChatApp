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
        VStack{
            if status {
                NavigationView{
                    Home().environmentObject(MainObservable())
                }
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

class MainObservable : ObservableObject {
    @Published var recents = [Recent]()
    
    init(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).collection("recents").order(by: "date", descending: true).addSnapshotListener{
            (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges {
                let id = i.document.documentID
                let name = i.document.get("name") as! String
                let pic = i.document.get("pic") as! String
                let lastmsg = i.document.get("lastmsg") as! String
                let stamp = i.document.get("date") as! Timestamp
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/YY"
                let date = formatter.string(from: stamp.dateValue())
                
                formatter.dateFormat = "hh:mm a"
                let time = formatter.string(from: stamp.dateValue())
                
                self.recents.append(Recent(id: id, name: name, pic: pic, lastmsg: lastmsg, time: time, date: date, stamp: stamp.dateValue( )))
            }
        }
    }
}
struct Recent : Identifiable {
    var id : String
    var name: String
    var pic: String
    var lastmsg: String
    var time: String
    var date: String
    var stamp : Date
}
