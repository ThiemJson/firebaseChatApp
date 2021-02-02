//
//  Indicator.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI

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
