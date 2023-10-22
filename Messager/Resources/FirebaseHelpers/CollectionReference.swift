//
//  CollectionReference.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-13.
//

import Foundation
import FirebaseFirestore

enum CollectionReferences: String {
    case User
    case Recent
}

func FirebaseReference(for collectionReference: CollectionReferences) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
