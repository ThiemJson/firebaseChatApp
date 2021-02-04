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
        ZStack{
            NavigationLink(
                destination: ChatView(name: name, pic: pic, uid: uid, chat: $chat),
                isActive: $chat){
                Text("")
            }
            VStack{
                if self.datas.recents.count == 0 {
                    if self.datas.norecents{
                        Text("No Chat History")
                    }
                    else{
                        Indicator()
                    }
                }
                else{
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing: 12){
                            ForEach(datas.recents){i in
                                Button(action: {
                                    self.uid = i.id
                                    self.name = i.name
                                    self.pic = i.pic
                                    self.chat.toggle()
                                }, label: {
                                    RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                })
                            }
                        }.padding()
                    }
                }
            }
        }
        .navigationBarTitle("Home", displayMode:.inline)
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
            newChatView(name: $name, pic: $pic, uid: $uid, show: $show, chat: $chat)
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
    @Binding var name : String
    @Binding var pic : String
    @Binding var uid : String
    @Binding var show : Bool
    @Binding var chat : Bool
    
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
                                self.uid = i.id
                                self.name = i.name
                                self.pic = i.pic
                                self.chat.toggle()
                                self.show.toggle()
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
    @State var msgs = [Msg]()
    @State var txt = ""
    @State var nomsgs = false
    
    var body: some View {
        VStack{
            if self.msgs.count == 0 {
                if self.nomsgs {
                    Text("Start new conversation !!").foregroundColor(Color.black.opacity(0.5)).padding(.top)
                    Spacer()
                }
                else {
                    Spacer()
                    Indicator()
                    Spacer()
                }
            }
            else{
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(self.msgs){
                        i in
                        HStack{
                            if i.user == UserDefaults.standard.value(forKey: "UID") as! String {
                                Spacer()
                                Text(i.msg).padding().foregroundColor(.white).background(Color.blue).clipShape(ChatBubble(mymsg: true))
                            }else{
                                Text(i.msg).padding().foregroundColor(.white).background(Color.green)
                                    .clipShape(ChatBubble(mymsg: false))
                                Spacer()
                            }
                            
                        }
                    }
                }
            }
            HStack{
                TextField("Enter message", text: self.$txt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    // Send todo actions
                }){
                    Text("Send ")
                }
            }
            .navigationBarTitle(Text("\(name)"), displayMode: .inline)
            //            .navigationBarItems(leading:
            //                                    Button(action: {
            //
            //                                    }){
            //                                        Image(systemName: "arrow.left").resizable().frame(width: 25, height: 25)
            //                                    }
            //            )
        }.padding()
        .onAppear{
            self.getMsgs()
        }
    }
    
    func getMsgs(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("msgs").document(uid!).collection(self.uid).order(by: "date", descending: false).getDocuments{
            (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                self.nomsgs = true
                return
            }
            
            if snap!.isEmpty {
                self.nomsgs = true
            }
            
            for i in snap!.documents{
                let id = i.documentID
                let msg = i.get("msg") as! String
                let user = i.get("user") as! String
                self.msgs.append(Msg(id: id, msg: msg, user: user))
            }
        }
    }
}

struct Msg : Identifiable {
    var id : String
    var msg: String
    var user: String
}

struct ChatBubble : Shape {
    var mymsg: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}
