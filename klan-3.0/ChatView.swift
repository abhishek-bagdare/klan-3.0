//
//  ChatView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/24/23.
//

import SwiftUI
import Firebase

struct FirebaseConstants{
    static let fromId = "fromId"
    static let toId = "toId"
    static let message = "message"
    
}
struct ChatMessage : Identifiable{
    var id: String {
        documentId
    }
    let documentId : String
    let fromId,toId,message:String
    let timeStamp : Timestamp
    
    init(documentId:String, data:[String : Any]){
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.timeStamp =  data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
class ChatViewModel:ObservableObject{
    
    @Published var count = 0
    
    @Published var chatMessageList = [ChatMessage]()
    @Published var chatText = ""
    let chatUser : ChatUser?
    init(chatUser : ChatUser?){
        self.chatUser = chatUser
     
       
    }
    
    func  createChat(){
        do {
            handleSend()
        } catch {
            print("Entered catch, creating chat")
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid
        else{return}
        guard let toId = chatUser?.uid else{return}
        print("creating Chat")
        print("From" + fromId)
        print("To" + toId)
        let messageData = ["baatcheet": [[
            "fromId" : fromId,
            "toId" : toId ,
            "message" : "Test" ,
            "timestamp" : Timestamp()
            
        ]]
        ] as [String : Any]
        
        
        let array = ["messages":{}]
        let senderDocument =  FirebaseManager.shared.firestore
            .collection("messages")
            .document(loggedInUser.userID)
            .collection(chatUser!.userId)
            .document("OurChat")
        
        
        senderDocument.setData(messageData){
            err in
            if let err = err{return}
            
        }
        
        
        let recipientDocument =  FirebaseManager.shared.firestore
            .collection("messages")
            .document(chatUser!.userId)
            .collection(loggedInUser.userID)
            .document("OurChat")
        recipientDocument.setData(messageData){
            err in
            if let err = err{return}
            
        }}
    }
    func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.userId else{return}
     
    
        
      
        
        FirebaseManager.shared.firestore.collection("messages").document(loggedInUser.userID).collection(toId)
           .addSnapshotListener{QuerySnapshot,errorMsg in
           if let errorMsg = errorMsg{
               print(errorMsg.localizedDescription)
               return
           }
             
           QuerySnapshot?.documentChanges.forEach({change in
             //  if change.type == .modified{
                   let docId=change.document.documentID
                   let arr = change.document.data()["baatcheet"] as? NSArray
                   
                   arr?.forEach {m in
                       
                       let chatMessage = ChatMessage(documentId: String(Int.random(in: 0..<60000)),  data: m as! [String : Any])
                       if(self.chatMessageList.contains(where: {$0.timeStamp==chatMessage.timeStamp})){
                           
                       }
                       else{
                           if(chatMessage.message == "" || chatMessage.message == "Test"){}else{
                               self.chatMessageList.append(chatMessage)
                           }
                        
                       }
                  
                    }
                   print("chatMessageList")
                   self.chatMessageList.forEach{m in
                       print(m.message)
                   }
                 // }
           })
       }
            
            
            //here
//            .document("OurChat")
//            .addSnapshotListener{
//                QuerySnapshot,error in
//                if let error = error{
//                    print("couldnt fetch recent messages")
//                    return
//
//                }
//                let docId2 = QuerySnapshot?.documentID
//
//                let arr = QuerySnapshot?.data()!["baatcheet"] as? NSArray
//                self.chatMessageList.removeAll()
//                arr?.forEach {m in
//                    let chatMessage = ChatMessage(documentId: docId2!,  data: m as! [String : Any])
//                    self.chatMessageList.append( chatMessage)
//                }
//
//
//
//            }
        //here
        //
    
//                DocumentSnapshot?.documentChanges.forEach({
//                    change in
//                    if change.type == .added {
//                        let data = change.document.data()
//                        self.chatMessageList.append(.init(documentId: change.document.documentID, data: data))
//                    }
//                })
                
                DispatchQueue.main.async {
                    self.count+=1
                }
              
//                QuerySnapshot?.documents.forEach({QueryDocumentSnapshot in
//                    let data  = QueryDocumentSnapshot.data()
//                    let docId = QueryDocumentSnapshot.documentID
//                    let chatMessage = ChatMessage(documentId: docId,  data: data)
//                    self.chatMessageList.append(chatMessage)
//                })
            
    }
    var iFT = true
    
    
    func handleSend( ){
   
        
            print("handleSend")
            guard let fromId = FirebaseManager.shared.auth.currentUser?.uid
            else{return}
        guard let toId = chatUser?.userId else{return}
        print("toID"+toId)
        print("from"+loggedInUser.userID)
            let messageData = [
                "fromId" : fromId,
                "toId" : chatUser?.uid ,
                "message" : self.chatText ,
                "timestamp" : Timestamp()
            ] as [String : Any]
                
            
            let array = ["messages":{}]
           let senderDocument =  FirebaseManager.shared.firestore
                .collection("messages")
                .document(loggedInUser.userID)
                .collection(toId)
                .document("OurChat")
        dispatchQueue1.sync {
            senderDocument.updateData([
                "baatcheet": FieldValue.arrayUnion([messageData])
            ]){
                err in
                if let err = err{
                    guard let fromId = FirebaseManager.shared.auth.currentUser?.uid
                    else{return}
                    
                    print("creating Chat")
                    print("From" + fromId)
                    print("To" + toId)
                    let messageData = ["baatcheet": [[
                        "fromId" : fromId,
                        "toId" : toId ,
                        "message" : "Test" ,
                        "timestamp" : Timestamp()
                        
                    ]]
                    ] as [String : Any]
                    
                    
                    let array = ["messages":{}]
                    let senderDocument =  FirebaseManager.shared.firestore
                        .collection("messages")
                        .document(loggedInUser.userID)
                        .collection(toId)
                        .document("OurChat")
                    
                    
                    senderDocument.setData(messageData){
                        err in
                        if let err = err{return}
                        
                    }
                    
                    
                    let recipientDocument =  FirebaseManager.shared.firestore
                        .collection("messages")
                        .document(toId)
                        .collection(loggedInUser.userID)
                        .document("OurChat")
                    recipientDocument.setData(messageData){
                        err in
                        if let err = err{return}
                        
                    }
                    return}
                
            }
            
        }
        dispatchQueue1.sync {
            let recipientDocument =  FirebaseManager.shared.firestore
                .collection("messages")
                .document(toId)
                .collection(loggedInUser.userID)
                .document("OurChat")
            recipientDocument.updateData([
                "baatcheet": FieldValue.arrayUnion([messageData])
            ]){
                err in
                if let err = err{return}
                
            }
        }
        dispatchQueue1.sync {
            self.persistMsg()
            self.chatText = ""
        }
       
    }
    func  persistMsg(){
       print( "persistMsg  se bheja hua ID" + loggedInUser.userID)
         let uid = loggedInUser.userID
        guard let toId = chatUser?.userId else {return}
        let senderDocument = FirebaseManager.shared.firestore.collection("recent_messages").document(uid).collection("messages").document(toId)
        let receiverDocument = FirebaseManager.shared.firestore.collection("recent_messages").document(toId).collection("messages").document(uid)
        let data = ["timestamp" : Timestamp(),
                    "fromId":toId,
                    "toId":loggedInUser.uid,
                    "toUserId": loggedInUser.userID ,
                    "toUserName" : loggedInUser.userName,
                    "toUserEmail" : loggedInUser.userEmail,
                    "message":self.chatText] as [String : Any]
        
        senderDocument.setData(data){error in
            if  let error = error{
                print("Error")
                return
            }
        }
        receiverDocument.setData(data){error in
            if  let error = error{
                print("Error")
                return
            }
        }
    }
    
   
}

struct ChatView: View {
    @ObservedObject var vm : ChatViewModel
    let chatUser : ChatUser?
    init(chatUser: ChatUser?) {
        print("ChatView ka init me ka data"+chatUser!.userId)
        self.chatUser = chatUser
       // self.vm = .init(chatUser: .init(uid: "E2OiQ7zWN8Qou8OVoRrbonTyOrQ2", email: "c2@gmail.com"))
        self.vm = .init(chatUser: chatUser)
       
    }

    struct  messageBubble:View{
        let message : ChatMessage
        var body: some View{
            VStack{
                if message.fromId == FirebaseManager.shared.auth.currentUser?.uid{
                    HStack{
                        Spacer()
                        HStack{
                            Text(message.message).foregroundColor(Color(hex: colors.klan_blue))
                        }.padding().background(Color(hex: colors.klan_pink)).cornerRadius(12)
                      
                    }.padding(.horizontal).padding(.top,8)
                   
                }
                else{
                    HStack{
                       
                        HStack{
                            Text(message.message).foregroundColor(Color(hex: colors.klan_pink))
                        }.padding().background(Color(hex: colors.klan_blue)).cornerRadius(12)
                        Spacer()
                    }.padding(.horizontal).padding(.top,8)
                   
                }
                
            }
        }
      
    }
    @State var chatMessage = ""
    var body: some View {
        VStack{
            ScrollView{
               
                    ScrollViewReader{
                        ScrollViewProxy in
                        
                        VStack{
                            ForEach(vm.chatMessageList){message in
                                messageBubble(message:message)
                            }
                            HStack{Spacer()}.id("empty")
                        }.onReceive(vm.$count){ _ in
                            withAnimation(.easeOut(duration: 0.5)){
                                ScrollViewProxy.scrollTo("empty",anchor: .bottom)
                            }
                           
                        }
                     
                    }
            }
            HStack{
                Image(systemName: "photo.on.rectangle").font(.system(size: 24))
             
                ZStack{
                    TextEditor(text: $vm.chatText).background(Color.white).padding(5).cornerRadius(8)
                }.frame(height: 40)
             
                Button{
                    vm.handleSend()
                }label:{Text("Send")}
                
            }.padding().background(Color.white)
      
        }.navigationTitle("meow").onAppear{
            
            vm.createChat()
            vm.fetchMessages()
        }
    }
}
 
