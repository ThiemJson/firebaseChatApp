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
    var body: some View {
        VStack(spacing: 20){
            Image("pic")
            Text ("Verify Your Phone Number")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Enter your phone number to verify your account")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            TextField("Number", text: $no)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action : {
                
            }){
                Text("Send")
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .foregroundColor(.white)
                    .background(Color.orange)
                
            }
        }
    }
}
