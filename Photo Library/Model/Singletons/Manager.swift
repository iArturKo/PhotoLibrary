//
//  Manager.swift
//  Photo Library
//
//  Created by Артур Кононович on 6.05.21.
//

import Foundation
import UIKit
import SwiftyKeychainKit

class Manager {
    
    static let shared = Manager()
    var photoCardArray = [PhotoCard]()
    let keychain = Keychain(service: "com.swifty.keychain")
    let passwordKey = KeychainKey<String>(key: "password")

    private init() {  }
    
    func checkPassword(password: String, confirmPassword: String, completion: @escaping (Bool, LoginErrors?) -> Void) {
        if UserDefaults.wasAppLaunched() {
            if let correctPassword = try? keychain.get(passwordKey),
               password == correctPassword {
                self.loadPhotoCardArray()
                completion(true, nil)
            } else {
                completion(false, .incorrectPassword)
            }
        } else if password == confirmPassword {
            try? keychain.set(password, for : passwordKey)
            self.savePhotoCardArray()
            UserDefaults.setAppWasLaunched()
            completion(true, nil)
        } else {
            completion(false, .passwordsNotEqual)
        }
    }
    
    func savePhotoCardArray() {
        UserDefaults.standard.set(encodable: self.photoCardArray, forKey: "photo")
    }
    
    func loadPhotoCardArray() {
        if let photoCardArray = UserDefaults.standard.value([PhotoCard].self, forKey: "photo") {
            self.photoCardArray = photoCardArray
        }
    }
    
    func addPhotoCard(image: UIImage) {
        if let nameImage = self.saveImage(image: image) {
            self.photoCardArray.append(PhotoCard(imageName: nameImage))
        }
        self.savePhotoCardArray()
    }
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}
