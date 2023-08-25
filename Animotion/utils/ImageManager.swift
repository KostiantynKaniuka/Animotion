//
//  ImageManager.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.08.2023.
//

import UIKit
import FirebaseAuth

final class ImageManager {
    
    func saveImageToApp(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
    
        let imageURL = documentsDirectory.appendingPathComponent("\(id)userImage.jpg")
        
        do {
            try imageData.write(to: imageURL)
            print("Image saved successfully: \(imageURL.absoluteString)")
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    func loadImageFromApp() -> UIImage? {
        guard let id = Auth.auth().currentUser?.uid else {
            return nil
        }
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let imageURL = documentsDirectory.appendingPathComponent("\(id)userImage.jpg")
        
        if let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            return image
        }
        
        return nil 
    }
}
