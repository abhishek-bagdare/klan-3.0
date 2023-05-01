//
//  EditUserView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/28/23.
//

import SwiftUI



struct EditUserView: View {
    
    init(uid:String,email:String,contact:String,name:String,image:String){
        self.email = email
        self.contact = contact
        self.name = name
        self.pic = image
        self.userId = uid
    }
    @State var toy = false
    @State var email : String
    @State var  userId  : String
    @State var password = ""
    @State var contact  : String
    @State var name  : String
    @State var pic  : String
    @State var loginStatusMsg = ""
    @State var showImagePicker: Bool = false
    @State var image: UIImage? = nil
    @State var storedImageUrl = ""
    var body: some View {
        Group{
            
            VStack{
                
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
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                            
                        }
                        
                    }}  .sheet(isPresented: $showImagePicker) {
                        ImagePicker(sourceType: .photoLibrary) { image in
                            self.image = image
                        }
                    }
            }

            
            TextField("Name",text: $name).padding()
            
            
            TextField("Contact",text: $contact).keyboardType(.numberPad).padding()
            
            TextField("Email",text: $email).keyboardType(.emailAddress).padding()
            
            TextField("User ID",text: $userId).keyboardType(.emailAddress).padding().disabled(true)
            
            Button{
            editUser()
            }
        label:
            {
                Text("SAVE").bold().font(.custom("LeagueSpartan-Bold",size: 16))
            }
            .padding(.vertical,16)
            .frame(width: UIScreen.main.bounds.width-20)
            .cornerRadius(12)
            .background(Color(hex: colors.klan_blue))
            .foregroundColor(Color(hex: colors.klan_pink))
            .fullScreenCover(isPresented: $toy, content: {HomView()})
            
        }
        
    }
    func editUser(){
        let uid = loggedInUser.uid
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
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
                    .document(uid).setData(userData){err in
                        if let err = err{
                            print(err)
                            return
                        }
                        
                        print("Success Editing User")
                        loggedInUser.userContact = self.contact
                        loggedInUser.userEmail =  self.email
                        loggedInUser.userName = self.name
                     
                        loggedInUser.userID = userId
                        loggedInUser.image = url1
                        toy.toggle()
                    }
            }
        }
    }}
    
