//
//  FindApartmentsView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase


struct motherList{
    static var motherList = [Apartment]()
}
struct selectedChatUser {
    static var email = ""
    static var uid = ""
    static var userId = ""
    static var name = ""
}
class FindApartmentsViewModel : ObservableObject{
    init(){
        
        fetchAllApartmentPosts()
    }
    
    @Published var chatUser = ChatUser(uid: "", email: "",userName: "",userId: "")
    @Published var postList = [Apartment]()
   @Published  var filteredList = [Apartment]()
    func fetchAllApartmentPosts()
    {
        postList.removeAll()
        motherList.motherList.removeAll()
        FirebaseManager.shared.firestore.collection("postsnew1")
            .addSnapshotListener{QuerySnapshot,errorMsg in
                if let errorMsg = errorMsg{
                    print(errorMsg.localizedDescription)
                    return
                }
                QuerySnapshot?.documentChanges.forEach({change in
                    let docId=change.document.documentID
                    let dictionary = change.document.data()
                    print("getting apartment ID for")
                    print(dictionary["addressLine1"] as! String)
                  print( String( dictionary["apartmentID"] as! Int ?? 0))
                        let apartment = self.resolveIntoApartment(dictionary: dictionary)
                        if(self.postList.contains(where: {$0._timeStamp == apartment._timeStamp})){
                        }
                        else{
                            print("adding")
                            
                            self.postList.append(apartment)
                            motherList.motherList.append(apartment)
                        }
                   
                })
               
            }
        
       
             
    }
    func filterByRent(amount:Int){
        var i = 0
        var toRemoveIndex = [Int]()
        postList.forEach(){apt in
            if(apt.rent>amount){
                toRemoveIndex.append(i)
            }
            i+=1
        }
        postList.remove(at: toRemoveIndex)
    }
    func clearFilter(){
    postList.removeAll()
        motherList.motherList.forEach(){ m in
            postList.append(m)
        }
    }
    
    func resolveIntoApartment(dictionary:[String:Any])->Apartment{
        let address = Address(
            addressLine1: dictionary["addressLine1"] as! String,
            addressLine2: dictionary["addressLine2"] as! String,
            apartmentNumber: dictionary["apartmentNumber"] as! String,
            city: dictionary["city"] as! String,
            state: dictionary["state"] as! String,
            zipcode: Int(dictionary["zipcode"] as! String) ?? 0 ,
            country: dictionary["country"] as! String)
        
        let amenities = Amenities(
            isHeatIncluded:  (dictionary["isHeatIncluded"] as! Int) == 0 ? true :false,
            isGasIncluded:(dictionary["isGasIncluded"] as! Int) == 0 ? true :false,
            isElectricityIncluded: (dictionary["isElectricityIncluded"] as! Int) == 0 ? true :false,
            isWifiIncluded: (dictionary["isWifiIncluded"] as! Int) == 0 ? true :false,
            arePetsAllowed: (dictionary["arePetsAllowed"] as! Int) == 0 ? true :false,
            isParkingIncluded: (dictionary["isParkingIncluded"] as! Int) == 0 ? true :false)
        
        let user = User(userID: Int(dictionary["postedByUserId"] as! String) ?? 0 ,
                        userName: dictionary["postedbyUserName"] as! String,
                        passWord: dictionary["postedByUserUid"] as! String,
                        email: dictionary["postedByUserEmail"] as! String,
                        contact: dictionary["postedByUserContact"] as! String,
                        isActive: true,pic: dictionary["postedByUserPhoto"] as! String)
        
        let apartment = Apartment(
           apartmentID: dictionary["apartmentID"] as! Int ?? 0 ,
           // apartmentID:0,
                                //  availableDate: dictionary["availableDate"] as! Date,
            availableDate: Date(),
                                  isOnMarket: (dictionary["isOnMarket"] as! String) == "true" ? true :false,
                                  rent: Int(dictionary["rent"] as! String)!,
                                  apartmentAmenities: amenities,
            apartmentAddress: address,
            postedBy: user,
            image: dictionary["imageUrl"] as! String,
            timestamp: dictionary["timestamp"] as! Timestamp)
        
        return apartment
    }
}

struct FindApartmentsView: View {
   
    @ObservedObject var vmOdel = FindApartmentsViewModel()
     @State var amount = ""
    var body: some View {
        VStack{
            VStack{
                VStack(alignment: .leading){
                    HStack{
                        Text("Search Apartments").bold().font(.custom("LeagueSpartan-Bold",size: 16))
                    }
                  
                }
                
                HStack{
                    Spacer()
                    Button{
                        vmOdel.filterByRent(amount: Int(amount)!)
                                   }label: {
                                       HStack{
                                           Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                                                      .font(.system(size: 22))
                                          
                                                                      .foregroundColor(Color(hex: colors.klan_blue))
                                       }
                   
                                   }
                    TextField("Filter By Max Rent",text: $amount).keyboardType(.numberPad).padding() .background(Color(hex: "#F5F5F5")).frame(width: 200)
                        .padding()
                    Button{
                                       vmOdel.clearFilter()
                    }label: {
                        HStack{
                            Image(systemName: "xmark.circle.fill")
                                                       .font(.system(size: 22))
                           
                                                       .foregroundColor(Color(hex: colors.klan_blue))
                        }.padding()
                    }
                              
                   
                    Spacer()
                }
//                Spacer()
//                Text("Search Apartments" ).foregroundColor(.white).font(.custom("LeagueSpartan-Bold",size: 18))
//                Button{
//                    vmOdel.filterByRent(amount: Int(amount)!)
//                }label: {
//                    HStack{
//                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
//                            .font(.system(size: 18))
//
//                            .foregroundColor(.white)
//                    }.background(Color(hex: colors.klan_blue))
//
//                }.frame(width: 200,height: 100)
//                Button{
//                    vmOdel.clearFilter()
//                }label: {
//                    HStack{
//                        Text("Clear" ).foregroundColor(.white).padding(.vertical,20).font(.custom("LeagueSpartan-Bold",size: 16))
//                    }.background(Color(hex: colors.klan_blue))
//
//                }.frame(width: 200,height: 100).padding()
//                TextField("Filter By Amount",text: $amount).keyboardType(.numberPad).padding()
//                Spacer()
            }.padding(.top,20).frame(width: UIScreen.main.bounds.width,height: 100).foregroundColor(.black)
            ScrollView{
                VStack{
                    ForEach(vmOdel.postList){apt in
                   
                            Card(apt: apt,vmOdel:vmOdel)
                  
                    }
                   
                }
            }
        }
     
    }
  
}


struct Card: View {
    @State var ismessageClicked = false
    @State var selectedCh: ChatUser?
    let apt : Apartment
    let vmOdel : FindApartmentsViewModel
    var body: some View {
        VStack(alignment: .leading){
           
                HStack(){
                    VStack(alignment: .leading){
                        Text(apt.apartmentAddress.addressLine1).padding(.top, 15).bold().font(.custom("LeagueSpartan-Bold",size: 14))
                        Text(apt.apartmentAddress.addressLine2).font(.system(size: 8))
                        HStack{
                            Text(apt.apartmentAddress.city).font(.system(size: 8))
                           // Text(",").font(.system(size: 8))
                            Text(String(apt.apartmentAddress.zipcode)).font(.system(size: 8))
                        }
                    }
                    
                 
                }.padding()
            HStack{
                Spacer()
                WebImage(url: URL(string: apt.image))
                        .resizable() // Resizable like SwiftUI.Image
                        .placeholder(Image(systemName: "photo")) // Placeholder Image
                        // Supports ViewBuilder as well
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 350, height: 300, alignment: .center)
                        .padding(.top,-30)
                Spacer()
            }
            HStack(alignment: .lastTextBaseline){
                VStack(alignment: .leading){
                    HStack{
                        Text(String(apt.rent)+" $/month").padding(.top, 15).bold().font(.custom("LeagueSpartan-Bold",size: 16))
                    }.padding()
                    
                }
            } .padding(.top,-30)
            HStack(alignment: .lastTextBaseline){
                VStack(alignment: .leading){
                    HStack{
//                    Text("Amenities").padding(.top, 15).bold().font(.custom("LeagueSpartan-Bold",size: 16))
                }.padding()
                    HStack{
                        Spacer()
                       // HStack{
                            Spacer()
                        if apt.apartmentAmenities.arePetsAllowed {
                            VStack{
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 14))
                                    .padding()
                                    .foregroundColor(Color(hex:colors.klan_pink))
                                Text("Allowed").font(.system(size: 8))
                            }
                            
                        } else
                        {
                            VStack{
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 14))
                                    .padding()
                                    .foregroundColor(.gray)
                                Text("Not Allowed").font(.system(size: 8)).padding(.top,1)
                            }
                        }
                        if apt.apartmentAmenities.isHeatIncluded {
                            VStack{
                                Image(systemName: "heater.vertical.fill")
                                    .font(.system(size: 14))
                                    .padding()
                                    .foregroundColor(Color(hex:colors.klan_pink))
                                Text("Included").font(.system(size: 8))
                            }
                            
                        } else {
                            VStack{
                                Image(systemName: "heater.vertical.fill")
                                    .font(.system(size: 14))
                                    .padding()
                                    .foregroundColor(.gray)
                                Text("Not Included").font(.system(size: 8))
                            }
                        }
                        
                        if apt.apartmentAmenities.isElectricityIncluded {
                            VStack{
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 14))
                                    .padding()
                                    .foregroundColor(Color(hex:colors.klan_pink))
                                Text("Included").font(.system(size: 8))
                            }
                        } else {
                            VStack{
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 14))
                                    .padding()
                                    .foregroundColor(.gray)
                                Text("Not Included").font(.system(size: 8))
                            }
                        }
                        
                           
                  //  }
                     //   HStack{
                            
                            if apt.apartmentAmenities.isParkingIncluded {
                                VStack{
                                    Image(systemName: "parkingsign.circle.fill")
                                        .font(.system(size: 15))
                                        .padding()
                                        .foregroundColor(Color(hex:colors.klan_pink))
                                    Text("Included").font(.system(size: 8))
                                }
                            } else {
                                VStack{
                                    Image(systemName: "parkingsign.circle.fill")
                                        .font(.system(size: 15))
                                        .padding()
                                        .foregroundColor(.gray)
                                    Text("Not Included").font(.system(size: 8))
                                }
                            }
//                            if apt.apartmentAmenities.isGasIncluded {
//                                VStack{
//                                    Image(systemName: "microbe.circle.fill")
//                                        .font(.system(size: 14))
//                                        .padding()
//                                        .foregroundColor(Color(hex:colors.klan_pink))
//                                    Text("Gas Included")  .font(.system(size: 8))
//                                }
//                            } else {
//                                VStack{
//                                    Image(systemName: "microbe.circle.fill")
//                                        .font(.system(size: 14))
//                                        .padding()
//                                        .foregroundColor(.gray)
//                                    Text("Gas Not Included")
//                                        .font(.system(size: 8))
//                                }
//                            }
                            if apt.apartmentAmenities.isWifiIncluded {
                                VStack{
                                    Image(systemName: "wifi")
                                        .font(.system(size: 15))
                                        .padding()
                                        .foregroundColor(Color(hex:colors.klan_pink))
                                    Text(" Included").font(.system(size: 8)).padding(.top,1)
                                }
                            } else {
                                VStack{
                                    Image(systemName: "wifi")
                                        .font(.system(size: 15))
                                        .padding()
                                        .foregroundColor(.gray)
                                    Text("Not Included").font(.system(size: 8)).padding(.top,1)
                                }
                            }
                          
                        //}
                       // Spacer()
                        Spacer()
                    }.padding(.top,-20)
                   
                }.padding(.top,-40).padding(.trailing,30)
              
            }
            HStack{
                Text("Posted By").padding(.top, 15).bold().font(.custom("LeagueSpartan-Bold",size: 16))
            }.padding()
           
            HStack{
                WebImage(url: URL(string: apt.postedBy.pic))
                        .resizable() // Resizable like SwiftUI.Image
                        .placeholder(Image(systemName: "photo")) // Placeholder Image
                        // Supports ViewBuilder as well
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32,height: 32)
                        .cornerRadius(16)
                        .padding(.top,14)
                Text(apt.postedBy.userName).padding(.top, 15).bold().font(.body)
            }.padding(.leading,20).padding(.bottom,0)  .padding(.top,-20)
           
//            Text(apt.apartmentAddress.apartmentNumber).padding()
//            Text(apt.apartmentAddress.city).padding()
//            Text(String(apt.apartmentAddress.zipcode)).padding()
//            Text(String(apt.apartmentAddress.country)).padding()
//            Text(String(apt.rent)).padding()
            let dateFormatter = DateFormatter()

            // Convert Date to String
           

            HStack{
                
                Button{
              
                    vmOdel.chatUser.uid = apt.postedBy.passWord
                    vmOdel.chatUser.email = apt.postedBy.email
                    selectedCh = ChatUser(uid: apt.postedBy.passWord, email: apt.postedBy.email, userName: apt.postedBy.userName, userId: String(apt.postedBy.userID))
                    
                    ismessageClicked.toggle()
                }
                label:
                {
                    Text("Send Message").bold().font(.custom("LeagueSpartan-Bold",size: 16))
                }
                
                .padding(.vertical,16)
                .frame(width: UIScreen.main.bounds.width-20)
                .cornerRadius(12)
                .background(Color(hex: colors.klan_blue))
                .foregroundColor(Color(hex: colors.klan_pink))
                .sheet(item: $selectedCh){ item in
                    ChatView(chatUser: item)
                }
//                .sheet(isPresented: $ismessageClicked, content: {ChatView(chatUser: .init(uid: apt.postedBy.passWord, email: apt.postedBy.email,userName: apt.postedBy.userName,userId: String(apt.postedBy.userID)))})
            }.padding(.top,0)
         
        }.background( RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(Color(hex: "#F0F0F0"))
            .frame(width: UIScreen.main.bounds.width-20))
        .padding(10)
       
    }
    
}
struct FindApartmentsView_Previews: PreviewProvider {
    static var previews: some View {
        FindApartmentsView()
    }
}
//
//func fetchAllApartmentPosts()
//{
//    postList.removeAll()
//    let ref = FirebaseManager.shared.firestore.collection("postsnew1").getDocuments { (snapshot, error) in
//        snapshot?.documents.forEach({ (document) in
//            let dictionary = document.data()
//            let poop = (dictionary["isOnMarket"] as! String) == "true" ? true :false
//            let apartment =  self.resolveIntoApartment(dictionary: dictionary)
//            self.postList.append(apartment)
//            print("apt")
//
//        })
//    }
//}
extension Array {
  mutating func remove(at indexes: [Int]) {
    for index in indexes.sorted(by: >) {
      remove(at: index)
    }
  }
}
