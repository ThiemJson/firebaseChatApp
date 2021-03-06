//
//  ImagePicker.swift
//  App
//
//  Created by Teneocto on 1/7/21.
//  Copyright © 2021 NguyenCaoThiem. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
   @Binding var picker : Bool
   @Binding var imageData: Data
   
   func makeCoordinator() -> ImagePicker.Coordinator {
       return ImagePicker.Coordinator(parent1: self)
   }
   
   func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
       let picker = UIImagePickerController()
       picker.sourceType = UIImagePickerController.SourceType.photoLibrary
       picker.delegate = context.coordinator
       return picker
   }
   
   func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
       // TODO
   }
   
   class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
       var parent: ImagePicker
       init(parent1: ImagePicker){
           parent = parent1
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           self.parent.picker.toggle()
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           let image = info[.originalImage] as! UIImage
           let data = image.jpegData(compressionQuality: 0.45)
           self.parent.imageData = data!
           self.parent.picker.toggle()
       }
   }
}
