//
//  ContentView.swift
//  App
//
//  Created by Teneocto on 1/4/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FirstPage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FirstPage : View {
    @State private var no = ""
    @State private var ccode = ""
    var body: some View {
        VStack(spacing: 20){
            //            Image("pic")
            Text ("Verify Your Phone Number")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Enter your phone number to verify your account")
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
            
            Button(action : {
                
            }){
                Text("Send")
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .foregroundColor(.white)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
        }
    }
}
