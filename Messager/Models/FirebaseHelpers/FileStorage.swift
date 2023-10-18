//
//  FileStorage.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-17.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseStorage

let storage = Storage.storage()

class FireStorage: ObservableObject {
    @Published var uploadProgress: Int64 = 0
    @Published var isUploading: Bool = false
    
    // MARK: - UPLOAD IMAGE
    func uploadImage(_ image: Data, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        let storageRef = storage.reference(forURL: FILEREFERENCE).child(directory)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(image, metadata: nil, completion: { metadata, error in
            withAnimation(.linear) {
                self.isUploading = true
            }
            task.removeAllObservers()
            
            if error != nil {
                print("Error uploading image ", error?.localizedDescription ?? "")
            } else {
                storageRef.downloadURL { url, error in
                    guard let downloadUrl = url else {
                        completion(nil)
                        withAnimation(.linear){
                            self.isUploading = false
                        }
                        return
                    }
                    
                    completion(downloadUrl.absoluteString)
                    withAnimation(.linear){
                        self.isUploading = false
                    }
                }
            }
        })
        
        task.observe(.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            self.uploadProgress = progress
        }
    }
    
    // MARK: - DOWNLOAD IMAGE
    func downloadImage(imageUrl: String, completion: @escaping (_ image: Image?) -> Void) {
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        if fileExistsAtPath(path: imageFileName) {
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion(Image(uiImage: contentsOfFile))
            } else {
                print("Couldn't convert local image")
                completion(nil)
            }
        } else {
            if imageUrl != "" {
                guard let documentUrl = URL(string: imageUrl) else {
                    return
                }
                
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                
                downloadQueue.async {
                    do {
                        let data = try Data(contentsOf: documentUrl)
                        
                        self.saveFileLocally(fileData: data, fileName: imageFileName)
                        
                        if let uiImage = UIImage(data: data) {
                            completion(Image(uiImage: uiImage))
                        }
                    } catch {
                        print("Error downloading image")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // MARK: - SAVE LOCALLY
    func saveFileLocally(fileData: Data, fileName: String) {
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        do {
            try fileData.write(to: docUrl, options: .atomic)
        } catch {
            print("Couldn't save file locally ", error.localizedDescription)
        }
    }
}

// MARK: - HELPERS
func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDocumentsDirectory(fileName: String) -> String {
    return getDocumentsURL().appendingPathComponent(fileName).path()
}

func fileExistsAtPath(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}
