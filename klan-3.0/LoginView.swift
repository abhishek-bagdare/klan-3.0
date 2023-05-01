//
//  ContentView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/18/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

let dispatchQueue1 = DispatchQueue.init(label: "dispatchQueue")

struct loggedInUser{
    static var userName = ""
    static var userEmail = ""
    static var userContact = ""
    static var userID = ""
    static var uid = ""
    static var messages = [ChatMessage]()
    static var image = ""
}
struct LoginView: View {
   @State var isAuthDone = false
    @State var isLoginMode = false
    @State var email = ""
    @State var  userId = ""
    @State var password = ""
    @State var contact = ""
    @State var name = ""
    @State var loginStatusMsg = ""
    @State var showImagePicker: Bool = false
      @State var image: UIImage? = nil
    @State var storedImageUrl = ""

    init(){
  
        
    }
    var body: some View{
        NavigationView{
//            NavigationLink("",isActive: $isAuthDone){
//              //  ChatView(chatUser: .init(uid: "E2OiQ7zWN8Qou8OVoRrbonTyOrQ2", email: "c2@gmail.com"))
//           MainMessageView()
//            }
            ScrollView {
                HStack{
                    Spacer()
                    Image("klanlogo-final")
                        .resizable().frame(width: 120,height: 35).padding(.top,100).padding(.leading,50)
                    Spacer()
                }
                VStack (spacing:16){
                    Picker(selection: $isLoginMode, label: Text("Picker here")){
                        Text("Login")
                            .tag(true)
                        Text("Create account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if !isLoginMode{
                        Button{
                                                  self.showImagePicker.toggle()
                        }label: {
                            VStack{
                                if let image = self.image{  Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128,height: 128)
                                        .cornerRadius(64)
                                }
                                
                                else{
                                    Image(systemName: "person.crop.circle.fill.badge.plus")
                                        .font(.system(size: 64))
                                        .padding()
                                    
                                }
                                
                            }}  .sheet(isPresented: $showImagePicker) {
                                                  ImagePicker(sourceType: .photoLibrary) { image in
                                                      self.image = image
                                                  }
                                          }

                    }
                
                    Group{
                        TextField("Email",text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password",text: $password)
                        
                    }
                    .padding(12)
                    .background(Color(hex: "#F5F5F5"))
                      
                    if !isLoginMode{
                        Group{
                            TextField("Name",text: $name)
                             
                            
                            TextField("Contact",text: $contact).keyboardType(.numberPad)
                            
                        }
                        .padding(12)
                        .background(Color(hex: "#F5F5F5"))
                          
                    }
                
                    VStack{
                        Button{
                            handleAction()
                     
                        }label: {
                            HStack{
                                Spacer()
                                
                                Text(isLoginMode ? "Log In" :"Create account" ).foregroundColor(.white).padding(.vertical,20).font(.custom("LeagueSpartan-Bold",size: 16))
                                Spacer()
                            } 
                                .background(Color(hex: colors.klan_blue))
//                                .foregroundColor(Color(hex: colors.klan_pink))
//
                        }.fullScreenCover(isPresented: $isAuthDone, content: {HomView()})
                        Text(self.loginStatusMsg).foregroundColor(.gray)
                    }
                         
                   
                }.padding()
               
                }
              
//            .navigationTitle(isLoginMode ? "Log In" :"Create account" )
            .background(Color(hex: "#FFFFF").ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private func handleAction(){
        if isLoginMode{
           loginUser()
            print("Login")
        }
        else{
            print("SignUp")
            createNewUser()
        }
    }
    private func createNewUser(){
         userId = String(Int.random(in: 0..<60000))
       var url = ""
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result,err in
            if let err = err{
                self.loginStatusMsg = err.localizedDescription
                print("Failed to create")
                return
            }
            self.loginStatusMsg = "Created \(result?.user.uid ?? "")"
           
            print("Success create")
            DispatchQueue.main.async   {
                if let image = self.image{  Image(uiImage: image)
                    persistImage()
                }
                else{
                    saveUserInfo( )
                }
                
            }
            
          
   
            self.isAuthDone.toggle()
        }
    }
    func persistImage(){
        print("persistImage")
        let uid = FirebaseManager.shared.auth.currentUser?.uid
        let ref = FirebaseManager.shared.storage.reference(withPath: uid!)
        let imageData = self.image?.jpegData(compressionQuality: 0.5)
        ref.putData(imageData!,metadata: nil){metadata,err in
            if let err = err{
                return
            }
            ref.downloadURL { url,err in
                if let err = err{
                    print("")
                    return
                }
                let url1 = url?.absoluteString ?? ""
                let userData =   ["email":self.email,"uid":uid,"userId":self.userId,"name":self.name,"contact":self.contact ,"password":self.password,"pic":url1]
                FirebaseManager.shared.firestore.collection("users")
                    .document(uid!).setData(userData){err in
                        if let err = err{
                            print(err)
                            return
                        }
                        loggedInUser.userContact = self.contact
                        loggedInUser.userEmail =  self.email
                        loggedInUser.userName = self.name
                        loggedInUser.uid = uid!
                        loggedInUser.userID = userId
                        loggedInUser.image = url1
                        print("Success saving Image")
                        
                    }
            }
        
        }
    }
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result,err in
            if let err = err{
                self.loginStatusMsg = err.localizedDescription
                print("Failed to Login")
                return
            }
            self.loginStatusMsg = "Logged in \(result?.user.displayName ?? "")"
            print("Success Login")
            dispatchQueue1.sync {
                getUserData(uid:(result?.user.uid)!)
            }
            
            self.isAuthDone.toggle()
        }
    }
    
   
    
    func saveUserInfo( ){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
       
        let userData = ["email":self.email,"uid":uid,"userId":userId,"name":self.name,"contact":self.contact ,"password":self.password,"pic":""]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData){err in
                if let err = err{
                   print(err)
                    return
                }
                print("Success")
                loggedInUser.userContact = self.contact
                loggedInUser.userEmail =  self.email
                loggedInUser.userName = self.name
                loggedInUser.uid = uid
                loggedInUser.userID = userId
            }
    }
    func getUserData(uid:String){
     let ref = FirebaseManager.shared.firestore.collection("users").document(uid)
        ref.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("User does not exist")
                return
            }
            let userData = document.data()
            print("userData")
            loggedInUser.userContact = userData!["contact"] as! String
            loggedInUser.userEmail = userData!["email"] as! String
            loggedInUser.userName = userData!["name"] as! String
            loggedInUser.uid = userData!["uid"] as! String
            loggedInUser.userID = userData!["userId"] as! String
            loggedInUser.image = userData!["pic"] as! String
        }
    }
}
struct ContentView_Previews : PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}
