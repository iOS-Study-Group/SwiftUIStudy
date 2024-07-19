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
    var recordedFiles = [String]()
    var recordedData = [Data]()
    
    func saveOnFirebaseStorage(_ fileName: String, _ fileUrl: URL) async {
        let _ = storageRef.child(folder.appending(fileName)).putFile(from: fileUrl, metadata: nil) { metadata, error in
                storageRef.child(fileName).downloadURL { (url, error) in
                    
            }
        }
    }
    
    func removeOnFirebaseStorage(_ fileName: String) async {
        do {
            try await storageRef.child(folder.appending("/\(fileName)")).delete()
        } catch {
            print("Error removing document: \(error)")
        }
    }
    
    mutating func getVoiceFilesOnFirebaseStorage() async {
        let storageRefWithPath = storageRef.storage.reference(withPath: "So0/")
        
        do {
            let listItems = try await storageRefWithPath.listAll()
            for item in listItems.items {
                let routes = "\(item)".components(separatedBy: "/")
                self.recordedFiles.append(routes.last!)
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
}
