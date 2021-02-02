//
//  AccountCreation.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI

struct AccountCreation : View {
   @Binding var show : Bool
   @State private var name = ""
   @State private var about = ""
   @State private var loading = false
   @State private var picker = false
   @State private var imageData : Data = .init(count: 0)
   @State private var alert = false
   
   var body : some View {
       VStack(alignment: .leading, spacing: 15) {
           Text("Awesome !! Create an Account")
               .font(.title)
           
           HStack{
               Spacer()
               Button(action: {
                   self.picker.toggle()
               }){
                   if self.imageData.count == 0 {
                       Image(systemName: "person.crop.circle.badge.plus")
                           .resizable()
                           .frame(width: 90, height: 70)
                           .foregroundColor(Color.gray)
                       
                   }
                   else {
                       Image(uiImage: UIImage(data: self.imageData)!)
                           .resizable()
                           .renderingMode(.original)
                           .frame(width: 90, height: 90)
                           .clipShape(Circle())
                   }
               }
               Spacer()
           }.padding(.vertical, 12)
           
           Text("Enter user name")
               .font(.body)
               .foregroundColor(.gray)
               .padding(.top, 12)
           TextField("Name", text: self.$name)
               .padding()
               .clipShape(RoundedRectangle(cornerRadius: 60))
               .background(Color("Color"))
               .keyboardType(UIKeyboardType.numberPad)
           
           Text("About you")
               .font(.body)
               .foregroundColor(.gray)
               .padding(.top, 12)
           TextField("About", text: self.$about)
               .padding()
               .clipShape(RoundedRectangle(cornerRadius: 60))
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
               Button(action: {
                   if self.name != "" && self.about != "" && self.imageData.count != 0{
                       self.loading.toggle()
                       CreateUser(name: self.name,  about: self.about, imageData: self.imageData){
                           (status) in
                           if status{
                               self.show.toggle()
                           }
                       }
                   }
                   else {
                       self.alert.toggle()
                   }
               }){
                   Text("Create")
                       .frame(width: UIScreen.main.bounds.width - 30, height: 50)
               }
               .foregroundColor(.white)
               .background(Color.orange)
               .clipShape(RoundedRectangle(cornerRadius: 20))
           }
       }
       .padding()
       .sheet(isPresented: self.$picker){
           ImagePicker(picker: self.$picker, imageData:   self.$imageData)
       }
       .alert(isPresented: self.$alert){
           Alert(title: Text("Error"), message: Text("Please fill the contents"), dismissButton: Alert.Button.default(Text("OK")))
       }
   }
}
