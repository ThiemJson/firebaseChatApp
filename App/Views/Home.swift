//
//  Home.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct Home : View {
    @State var myuid = UserDefaults.standard.value(forKey: "userName") as! String
    @EnvironmentObject var datas : MainObservable
    @State var show = false
    @State var chat = false
    @State var uid = ""
    @State var name = ""
    @State var pic = ""
    
    var body : some View {
        VStack{
            if self.datas.recents.count == 0 {
                Indicator()
            }
            else{
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 12){
                        ForEach(datas.recents){i in
                            Button(action: {
                                print("==> recent view click")
                            }, label: {
                                RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                            })
                        }
                    }.padding()
                }
            }
        }.navigationBarTitle("Home", displayMode:.inline)
        .navigationBarItems(leading:
                                Button(action: {
                                    do {
                                        try Auth.auth().signOut()
                                        print("==> \(String(describing: Auth.auth().currentUser?.uid))")
                                        UserDefaults.standard.set(false, forKey: "status")
                                        UserDefaults.standard.set(nil, forKey: "userName")
                                        UserDefaults.standard.set(nil, forKey: "UID")
                                        UserDefaults.standard.set(nil, forKey: "pic")
                                        NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                                    } catch let signOutError as NSError {
                                        print ("==> Error signing out", signOutError)
                                    }
                                    
                                }, label: {
                                    Text("Sign Out")
                                }),
                            trailing:
                                Button(
                                    action: {
                                        self.show.toggle()
                                    }, label: {
                                        Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                                    }
                                )
        )
        .sheet(isPresented: self.$show){
            newChatView()
        }
    }
}

struct RecentCellView : View {
    var url: String
    var name: String
    var time: String
    var date: String
    var lastmsg: String
    
    var body : some View {
        HStack{
            AnimatedImage(url: URL(string: url)).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 6){
                        Text(name).foregroundColor(.black)
                        Text(lastmsg).foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 6){
                        Text(date).foregroundColor(.gray)
                        Text(time).foregroundColor(.gray)
                    }
                }
                
                Divider()
            }
            
        }
    }
}

struct newChatView : View {
    @ObservedObject var datas = getAllUsers()
    var body: some View {
        VStack(alignment: .leading){
            if self.datas.users.count == 0 {
                Indicator()
            }
            else{
                Text("Select to chat").font(.title).foregroundColor(Color.black.opacity(0.5))
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 12){
                        ForEach(datas.users){i in
                            Button(action: {
                                print("==> new chat")
                            }, label: {
                                UserCellView(url: i.pic, name: i.name, about: i.about)
                            })
                        }
                    }
                }
            }
        }.padding()
    }
}

class getAllUsers : ObservableObject{
    @Published var users = [User]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments{
            (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents {
                let id = i.documentID
                let name = i.get("name") as! String
                let about = i.get("about") as! String
                let pic = i.get("pic") as! String
                
                self.users.append(User(id: id, name: name, pic: pic, about: about))
            }
            
        }
    }
}

struct User : Identifiable {
    var id : String
    var name: String
    var pic: String
    var about: String
}

struct UserCellView : View {
    var url: String
    var name: String
    var about: String
    
    var body : some View {
        HStack{
            AnimatedImage(url: URL(string: url)).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 6){
                        Text(name).foregroundColor(.black)
                        Text(about).foregroundColor(.gray)
                    }
                    Spacer()
                }
                Divider()
            }
            
        }
    }
}

struct ChatView : View {
    var name: String
    var pic: String
    var uid: String
    @Binding var chat : Bool
    var body: some View {
        VStack{
            Text("Hello").navigationBarTitle(name, displayMode: .inline)
        }
    }
}
