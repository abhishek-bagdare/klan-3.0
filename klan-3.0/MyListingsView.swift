//
//  MyListingsView.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/28/23.
//

import SwiftUI
import SDWebImageSwiftUI

class MyListingsViewModel : ObservableObject{
    @Published var myPostList = [Apartment]()
    init(){
//        myPostList.removeAll()
//        motherList.motherList.forEach(){ apt in
//            if(apt.postedBy.userID == Int(loggedInUser.userID)){
//                myPostList.append(apt)
//            }
//            
//        }
    }
    func getMyList(){
        myPostList.removeAll()
        motherList.motherList.forEach(){ apt in
   
            if(apt.postedBy.userID == Int(loggedInUser.userID)){
                print("mylist"+String(apt.apartmentAddress.addressLine1))
                myPostList.append(apt)
            }
        }
    }
}
struct MyListingsView: View {
    @ObservedObject var myVm = MyListingsViewModel()
   
    var body: some View {
        VStack{
            HStack{
                Text("My Listings").bold().font(.custom("LeagueSpartan-Bold",size: 16))
            }
            ScrollView{
                VStack{
                    ForEach(myVm.myPostList){apt in
                        
                        MyCard(apt: apt,vmOdel:myVm)
                        
                    }
                    
                }
            }
        }.onAppear(){
            myVm.getMyList()
           
             
        }
    }
    
    func deleteListing(){
        
    }
    struct MyCard: View {
        @State var isEditClicked = false
        @State var isDeleteClicked = false
        @State var selectedListing: Apartment?
        let apt : Apartment
        let vmOdel : MyListingsViewModel
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
             
                let dateFormatter = DateFormatter()
        
                HStack{
                    
                    Button{
                        isDeleteClicked.toggle()
                        print("Clicked")
                        print(apt.apartmentID)
                        print("deleting"+String(apt.apartmentID))
                        FirebaseManager.shared.firestore
                        .collection("postsnew1").document(String(apt.apartmentID)).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                label:
                    {
                        Text("Delete").bold().font(.custom("LeagueSpartan-Bold",size: 16))
                    }
                    
                    .padding(.vertical,16)
                    .frame(width: UIScreen.main.bounds.width-20)
                    .cornerRadius(12)
                    .background(Color(hex: colors.klan_pink))
                    .foregroundColor(Color(hex: colors.klan_blue))
                    .alert("Post Removed!", isPresented: $isDeleteClicked) {
                        Button("OK", role: .cancel) { }
                    }
                
                }.padding(.top,0)
                
            }.background( RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(hex: "#F0F0F0"))
                .frame(width: UIScreen.main.bounds.width-20))
            .padding(10)
            
        }
        
    }
    struct MyListingsView_Previews: PreviewProvider {
        static var previews: some View {
            MyListingsView()
        }
    }
}
