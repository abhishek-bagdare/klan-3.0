//
//  MyAccountView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/28/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyAccountView: View {
    @State var name = ""
    @State var id = ""
    @State var photo = ""
    @State var contact = ""
    @State var email = ""
    @State var isSignOutClicked = false
    @State var isEditClicked = false
    var body: some View {
        VStack{
             
            VStack(alignment:.leading){
                    HStack{
                        WebImage(url: URL(string: photo))
                                .resizable() // Resizable like SwiftUI.Image
                                .placeholder(Image(systemName: "photo")) // Placeholder Image
                                // Supports ViewBuilder as well
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .scaledToFit()
                                .cornerRadius(100)
                                .frame(width: 200, height: 200, alignment: .center)
                                .padding()
                    }
                    VStack(alignment: .leading){
                        Text("Name: " + name).padding()
                        Text("User ID: " + id).padding()
                        Text("E-mail : " + email).padding()
                        Text("Contact : " + contact).padding()
                    }.padding()
                    
                }
            Button{
                if(handleSignOut()){
                    isEditClicked.toggle()
                }else{}
                
            }
        label:
            {
                Text("EDIT PROFILE").bold().font(.custom("LeagueSpartan-Bold",size: 16))
            }
            .padding(.vertical,16)
            .frame(width: UIScreen.main.bounds.width-20)
            .cornerRadius(12)
            .background(Color(hex: colors.klan_pink))
            .foregroundColor(Color(hex: colors.klan_blue))
            .sheet(isPresented: $isEditClicked, content: {EditUserView(uid: loggedInUser.userID, email: loggedInUser.userEmail, contact: loggedInUser.userContact, name: loggedInUser.userName, image: loggedInUser.image)})
            Button{
                if(handleSignOut()){
                    isSignOutClicked.toggle()
                }else{}
                
            }
        label:
            {
                Text("SIGN OUT").bold().font(.custom("LeagueSpartan-Bold",size: 16))
            }
            .padding(.vertical,16)
            .frame(width: UIScreen.main.bounds.width-20)
            .cornerRadius(12)
            .background(Color(hex: colors.klan_blue))
            .foregroundColor(Color(hex: colors.klan_pink))
            .fullScreenCover(isPresented: $isSignOutClicked, content: {LoginView()})
            
           
            
        }.onAppear(){
            self.id = loggedInUser.userID
            self.contact = loggedInUser.userContact
            self.photo = loggedInUser.image
            self.email = loggedInUser.userEmail
            self.name = loggedInUser.userName
        }
            
    }
    }
func fetchInfo(){
    
}
func handleSignOut()->Bool{
 
    do{
        try? FirebaseManager.shared.auth.signOut()
        return true
    }
    catch{}
    return false
  
   
    
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
