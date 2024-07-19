//
//  AudioRecorderFirebaseManager.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/19/24.
//

import Foundation
import FirebaseStorage

struct AudioRecorderFirebaseManager {
    let storageRef = Storage.storage().reference()
    let folder = "So0/"
    var recordedFiles = [URL]()
    
    func saveOnFirebaseStorage(_ fileUrl: URL) async {
        let _ = storageRef.child(folder.appending(fileUrl.lastPathComponent)).putFile(from: fileUrl, metadata: nil) { metadata, error in
                storageRef.child(fileUrl.lastPathComponent).downloadURL { (url, error) in
                    
            }
        }
    }
    
    func removeOnFirebaseStorage(_ fileUrl: URL) async {
        do {
            try await storageRef.child(folder.appending("\(fileUrl.lastPathComponent)")).delete()
        } catch {
            print("Error removing document: \(error)")
        }
    }
    
    mutating func getVoiceFilesOnFirebaseStorage() async {
        let storageRefWithPath = storageRef.storage.reference(withPath: folder)
        
        do {
            let listItems = try await storageRefWithPath.listAll()
            for item in listItems.items {
                self.recordedFiles.append(URL(string: "\(item)")!)
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
}
