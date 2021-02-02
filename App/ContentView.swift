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
        print("==> Render main View")
        return NavigationView{
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

struct FirstPage : View {
    @State private var no = ""
    @State private var ccode = ""
    @State private var show = false
    @State private var msg = ""
    @State private var alert = false
    @State private var ID = ""
    
    var body: some View {
        print("==> child View on appear")
        return VStack(spacing: 20){
            Text ("Verify Your Phone Number")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Please enter your phone number")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            HStack{
                TextField("+1", text: $ccode)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .background(Color("Color"))
                    .keyboardType(UIKeyboardType.numberPad)
                
                TextField("Number", text: $no)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .background(Color("Color"))
                    .keyboardType(UIKeyboardType.numberPad)
            }
            NavigationLink(destination: SecondPage(show: $show, ID: $ID), isActive: $show){
                Button(action : {
                    Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate: nil){
                        (ID, err) in
                        if err != nil {
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                        }
                        
                        print("==> \(String(describing: ID))")
                        self.ID = ID!
                        self.show.toggle()
                    }
                }){
                    Text("Send")
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        .foregroundColor(.white)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
        .padding()
        .alert(isPresented: $alert){
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("OK")))
        }
    }
}

struct SecondPage : View {
    @State private var code = ""
    @Binding var show : Bool
    @Binding var ID : String
    @State private var msg = ""
    @State private var alert = false
    @State private var creation = false
    @State private var loading = false
    
    var body: some View {
        ZStack(alignment: .topLeading){
            GeometryReader{_ in
                VStack(spacing: 20){
                    Text("Verification code")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Text("Please enter your vertification code")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                    TextField("Code", text: self.$code)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .background(Color("Color"))
                        .keyboardType(UIKeyboardType.numberPad)
                    
                    if self.loading {
                        HStack{
                            Spacer()
                            Indicator()
                            Spacer()
                        }
                    }
                    else {
                        Button(action : {
                            self.loading.toggle()
                            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                            Auth.auth().signIn(with: credential){
                                (res, err) in
                                if err != nil {
                                    self.msg = (err?.localizedDescription)!
                                    self.alert.toggle()
                                    self.loading.toggle()
                                    return
                                }
                                
                                checkUser{
                                    (exits, user) in
                                    if exits {
                                        UserDefaults.standard.set(true, forKey: "status")
                                        UserDefaults.standard.set(user, forKey: "userName")
                                        NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                                    }
                                    else {
                                        self.loading.toggle()
                                        self.creation.toggle()
                                    }
                                }
                            }
                            
                        }){
                            Text("Verify")
                                .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                                .foregroundColor(.white)
                                .background(Color.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
            
            Button(action: {
                self.show.toggle()
            }){
                Image(systemName: "chevron.left")
                    .font(Font.title)
            }.foregroundColor(Color.orange)
        }
        .padding()
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $alert){
            Alert(title: Text("Error"), message:  Text(self.msg), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: self.$creation){
            AccountCreation(show: self.$creation)
        }
    }
}


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

func checkUser(completion: @escaping (Bool ,String)->Void){
    let db = Firestore.firestore()
    db.collection("user").getDocuments{
        (snap ,err) in
        
        if err != nil{
            print(err?.localizedDescription ?? "")
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

struct AccountCreation : View {
    @Binding var show : Bool
    var body : some View {
        Text("Creation")
    }
}

struct Indicator : UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        // TODO
    }
}
