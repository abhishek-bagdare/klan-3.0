//
//  FirebaseManager.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//

import Foundation

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class FirebaseManager : NSObject{
    @State private var path = NavigationPath()
    let auth : Auth
    let firestore : Firestore
    let storage : Storage
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        super.init()
    }
}
