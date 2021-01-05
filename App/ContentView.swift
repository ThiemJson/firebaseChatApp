//
//  ContentView.swift
//  App
//
//  Created by Teneocto on 1/4/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import Firebase

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

struct FirstPage : View {
    @State private var no = ""
    @State private var ccode = ""
    @State private var show = false
    @State private var msg = ""
    @State private var alert = false
    @State private var ID = ""
    
    var body: some View {
        VStack(spacing: 20){
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
                    
                    
                    Button(action : {
                        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                        Auth.auth().signIn(with: credential){
                            (res, err) in
                            if err != nil {
                                self.msg = (err?.localizedDescription)!
                                self.alert.toggle()
                                return
                            }
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
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
            
            Button(action: {
                self.show.toggle()
            }){
                Image(systemName: "chevron.left")
                    .font(Font.title)
            }.foregroundColor(Color.orange)
        }
        .padding()
        .alert(isPresented: $alert){
            Alert(title: Text("Error"), message:  Text(self.msg), dismissButton: .default(Text("OK")))
        }
    }
}


struct Home : View {
    var body : some View {
        VStack{
            Text("Home")
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
