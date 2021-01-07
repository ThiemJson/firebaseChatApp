//
//  SecondPage.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import Firebase

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
                                    print("==> func compleion user")
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
