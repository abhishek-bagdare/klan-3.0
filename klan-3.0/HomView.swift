//
//  HomView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/27/23.
//

import SwiftUI

struct HomView: View {
    @State  var tabSelected = 1
    var body: some View {
        VStack {
            TabView(selection: $tabSelected) {
                      

                       FindApartmentsView()
                       .padding()
                       .tabItem {
                           Label("", systemImage: "magnifyingglass.circle.fill").foregroundColor(Color(hex: colors.klan_blue))
                       }
                       .tag(1)
                CreateApartmentView()
                 .padding()
                 .tabItem {
                     Label("", systemImage: "plus.app.fill").foregroundColor(Color(hex: colors.klan_blue))
                 }
                 .tag(2)
                MainMessageView()
                 .padding()
                 .tabItem {
                     Label("", systemImage: "character.bubble.fill").foregroundColor(Color(hex: colors.klan_blue))
                 }
                 .tag(3)
                MyAccountView()
                .padding()
                .tabItem {
                    Label("", systemImage: "person.circle.fill").foregroundColor(Color(hex: colors.klan_blue))
                }
                .tag(4)
                MyListingsView()
                .padding()
                .tabItem {
                    Label("", systemImage: "list.bullet.circle").foregroundColor(Color(hex: colors.klan_blue))
                }
                .tag(5)
                   }
                  }
                  
    }
}

struct HomView_Previews: PreviewProvider {
    static var previews: some View {
        HomView()
    }
}
