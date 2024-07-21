//
//  SumchiveRecorderFirebase.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/19/24.
//

import Foundation
import FirebaseStorage

func uploadFile(url: URL) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("recordings/\(url.lastPathComponent)")
        let _ = fileRef.putFile(from: url, metadata: nil) { metadata, error in
            if let error = error {
                print("File upload error: \(error.localizedDescription)")
            } else {
                print("File uploaded successfully")
            }
        }
    }
