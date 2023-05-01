//
//  MainMessageView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/24/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct RecentMessages : Identifiable{
    var id: String{documentId}
    let documentId : String
    let message,email,fromId,toId,toUserName,toUserId,toUserEmail : String
    let timeStamp : Timestamp
    init(documentId:String,data:[String:Any]){
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.email = data["mail"] as? String ?? ""
        self.toUserId = data["toUserId"] as? String ?? ""
        self.toUserName = data["toUserName"] as? String ?? ""
        self.toUserEmail =  data["mail"] as? String ?? ""
        self.timeStamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
struct ChatUser : Identifiable{
    var id: String{uid}
    
    var uid ,email,userName,userId : String
}

class MainMessageViewModel : ObservableObject{
var isFirstTime = true
    @Published var chatUser : ChatUser?
    @Published var isLoggedIn = false
    @Published var errorMsg = ""
    init(){
      
//            self.fetchCurrentUser()
//            self.fetchRecentMessages()
        
   
    }
  
    
     func handleSignOut()->Bool{
        isLoggedIn.toggle()
         do{
             try? FirebaseManager.shared.auth.signOut()
             return true
         }
         catch{}
         return false
       
        
         
    }
    
    @Published var recentMessagesList = [RecentMessages]()
   //here
    
    
    func  fetchRecentMessages(){
       let uid = loggedInUser.userID


       FirebaseManager.shared.firestore.collection("recent_messages").document(uid).collection("messages")
           .addSnapshotListener{QuerySnapshot,errorMsg in
           if let errorMsg = errorMsg{
               print(errorMsg.localizedDescription)
               return
           }


           QuerySnapshot?.documentChanges.forEach({change in
               if change.type == .added{
                   let docId=change.document.documentID
               if let index = self.recentMessagesList.firstIndex(where: {rm in
                   return rm.documentId == docId
               }){
                   self.recentMessagesList.remove(at: index)
               }
                   print("navin msg fetching")
               print(change.document.data())
                   if(change.document.data()["toUserName"] as! String == loggedInUser.userName){}else{
                       self.recentMessagesList.insert((.init(documentId: docId, data: change.document.data())), at: 0)
                   }
                
               }
           })
       }
    }

 
    
    
     func fetchCurrentUser(){
    }
}

struct MainMessageView: View {
    @State var name = ""
    @State var photo = ""
    @State var isSignOutClicked = false
    @State   var chatLogView = false
    @State   var C3 = false
    @State   var C2 = false
    @State var touch = false
    @State var selectedCh: ChatUser?
   // @State var selectedUserFinal = ChatUser(uid: "", email: "", userName: "", userId: "")
    @ObservedObject var vm = MainMessageViewModel()
    var body: some View {
        NavigationView{
            VStack{
                 
                HStack{
                    WebImage(url: URL(string: photo))
                            .resizable() // Resizable like SwiftUI.Image
                            .placeholder(Image(systemName: "photo")) // Placeholder Image
                            // Supports ViewBuilder as well
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .scaledToFit()
                            .cornerRadius(16)
                            .frame(width: 32, height: 32, alignment: .center)
                            .padding()
                    VStack(alignment: .leading,spacing: 4){
                        Text(name).font(.system(size: 20))
                        HStack{
                            Circle().foregroundColor(.green).frame(width: 10,height: 10)
                            Text("Online").font(.system(size: 16)).foregroundColor(.gray)
                        }
                    }
                    Spacer()
//                    Image(systemName: "gear")
                }.padding()
           
                ScrollView{
                  
                    ForEach (vm.recentMessagesList){recentMessage in
                       
                     
                        Button{
                           
                                selectedCh = ChatUser(uid: recentMessage.toId, email: recentMessage.email, userName: recentMessage.toUserName, userId: recentMessage.toUserId)
                       
                      
//                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//                                touch.toggle()
//                            })
                               
                            
                        }label: {
                            VStack{
                                HStack(spacing:16){
                                    Image(systemName: "person.fill").font(.system(size: 32))
                                        .padding(8)
                                        .overlay(RoundedRectangle(cornerRadius:  44).stroke( .black,lineWidth:2))
                                    
                                    VStack(alignment: .leading){
                                        Text(recentMessage.toUserName)
                                        Text(recentMessage.message)
                                    }
                                    Spacer()

                                }
                                
                        }
                       
                            Divider().padding(.vertical,8)
                        }.padding(.horizontal)
                            .sheet(item: $selectedCh){ item in
                                ChatView(chatUser: item)
                            }

 //}
                        
                         
                    }
                 
                }
//                Button{
//                    self.C2.toggle()
//                }label: {
//                    Text("+C2")
//
//                }.sheet(isPresented: $C2, content: {
//
//                })
//                Button{
//                    self.C3.toggle()
//                }label: {
//                    Text("+C3")
//
//                }.sheet(isPresented: $C3, content: {
//
//                })
               
                    
               
              
            }.navigationBarHidden(true).onAppear{ vm.fetchCurrentUser()
                vm.fetchRecentMessages()}
         
        }.onAppear(){
            name = loggedInUser.userName
            photo = loggedInUser.image
        }
    }
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageView()
    }
}
