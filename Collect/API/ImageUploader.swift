//
//  ImageUploader.swift
//  Collect
//
//  Created by Patrick Ortell on 1/25/21.
//

import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images\(filename)")
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print ("DEBUG: failed")
                return
            }
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }
        }
    }
}
