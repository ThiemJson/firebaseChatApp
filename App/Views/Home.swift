//
//  Home.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct Home : View {
    @State var myuid = UserDefaults.standard.value(forKey: "userName") as! String
    @EnvironmentObject var datas : MainObservable
    var body : some View {
        VStack{
            if self.datas.recents.count == 0 {
                Indicator()
            }
            else{
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 12){
                        ForEach(datas.recents){i in
                            RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                        }
                    }.padding()
                }
            }
        }.navigationBarTitle("Home", displayMode:.inline)
        .navigationBarItems(leading:
                                Button(action: {
                                    
                                }, label: {
                                    Text("Sign Out")
                                }),
                            trailing:
                                Button(
                                    action: {
                                        
                                    }, label: {
                                        Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                                    }
                                )
        )
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
                        Text(name)
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
