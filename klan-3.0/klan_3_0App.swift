//
//  klan_3_0App.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/18/23.
//

import SwiftUI

@main
struct klan_3_0App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
           LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
         
          
        }
    }
}
//handle errors,avoi crashes, add updateuserscreen
