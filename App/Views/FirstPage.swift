//
//  FirstPage.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct FirstPage : View {
   @State private var no = ""
   @State private var ccode = ""
   @State private var show = false
   @State private var msg = ""
   @State private var alert = false
   @State private var ID = ""
   
   var body: some View {
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
