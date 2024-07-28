//
//  SoomStorageManager.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/20/24.
//

import Foundation
import FirebaseStorage

class StorageManager{
    let storage = Storage.storage()

    func upload(fileUrl: URL){
        let storageRef = storage.reference()
        let filenames = fileUrl.pathComponents.map { $0 }.filter{ $0.contains(".m4a") }
        print(filenames)
        let path = storageRef.child("Soom/\(fileUrl.lastPathComponent)")
        
        let uploadTask = path.putFile(from: fileUrl , metadata: nil) { metadata, error in
            print("file upload ")
            guard let metadata = metadata else {
                return
            }
            let size = metadata.size
            print("파일 이름: \(metadata.name!)" ?? "없어요")
            path.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
            }
            print("upload end")
            print(size)
        }
    }
}
