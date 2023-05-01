//
//  CreateApartment.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//
import Firebase
import SwiftUI
struct colors{
    static var klan_blue = "#494E68"
    static var klan_pink = "#DD8199"
}
struct CreateApartmentView: View {
    @State    var apartmentID = 0
    @State    var availableDate = Date()
    @State    var isOnMarket = false
    @State    var rent = ""
    @State var showingAlert = false
    @State  var isHeatIncluded = false
    @State  var isGasIncluded = false
    @State  var isElectricityIncluded = false
    @State  var isWifiIncluded = false
    @State  var arePetsAllowed = false
    @State  var isParkingIncluded  = false
    @State var downloadUrl = ""
    @State    var addressLine1 = ""
    @State    var addressLine2 = ""
    @State    var apartmentNumber = ""
    @State    var city = ""
    @State    var state = ""
    @State    var zipcode = ""
    @State    var country = ""
    
    @State var showImagePicker: Bool = false
      @State var image: UIImage? = nil
    
    var backgroundColor = "#F8F8F8"
    var body: some View {
      
        ScrollView{
            VStack{
                VStack{
                    Text("Create New Apartment Post").foregroundColor(.black).padding(.vertical,20).font(.custom("LeagueSpartan-Bold",size: 16))
                
                }
                VStack(alignment: .leading, spacing: 6){  Text("Address")
                    TextField("Address Line 1",text: $addressLine1)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color.white)
                       
                      
                    TextField("Address Line 2",text: $addressLine2)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color.white)
                    TextField("Apartment Number",text: $apartmentNumber)
                        .keyboardType(.numberPad)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color.white)
                    TextField("City",text: $city)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color.white)
                    TextField("State",text: $state)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color.white)
                    TextField("Zipcode",text: $zipcode)
                        .keyboardType(.numberPad)
                        .padding(14)
                        .background(Color.white)
                    TextField("Country",text: $country)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color.white)
                }
                VStack(alignment: .leading, spacing: 6){
                    Text("Amenities")
                    Toggle(isOn: $isHeatIncluded, label:{
                        Text("Is Heat Included in Rent? ")
                    })      .padding(14)
                        .background(Color.white)
                    Toggle(isOn: $isGasIncluded, label:{
                        Text("Is Gas Included in Rent? ")
                    })    .padding(14)
                        .background(Color.white)
                    Toggle(isOn: $isElectricityIncluded, label:{
                        Text("Is Electricity Included in Rent? ")
                    })     .padding(14)
                        .background(Color.white)
                    Toggle(isOn: $isWifiIncluded, label:{
                        Text("Is Wifi Included in Rent? ")
                    })      .padding(14)
                        .background(Color.white)
                    Toggle(isOn: $isParkingIncluded, label:{
                        Text("Is Parking Included in Rent? ")
                    })       .padding(14)
                        .background(Color.white)
                    Toggle(isOn: $arePetsAllowed, label:{
                        Text("Are Pets Allowed in Apartment? ")
                    })
                    .padding(14)
                    .background(Color.white)
                }
                VStack(alignment: .leading, spacing: 6){
                    Text("Apartment Info")    .padding()
                    TextField("Rent ($)",text: $rent)
                        .keyboardType(.numberPad)      .padding(14)
                        .background(Color.white)
                    Text("Available from")    .padding()
                    DatePicker("",selection: $availableDate,displayedComponents: .date).datePickerStyle(.wheel)      .padding(14)
                        .background(Color.white)
                    Text("Add Image :")    .padding()
                    Button{
                        self.showImagePicker.toggle()
                    }label: {
                        VStack{
                            if let image = self.image{Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64,height: 64)
                                    .cornerRadius(10)
                                    .padding()
                            }
                            
                            else{
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 32))
                                    .padding()
                                
                            }
                            
                        }}  .sheet(isPresented: $showImagePicker) {
                                              ImagePicker(sourceType: .photoLibrary) { image in
                                                  self.image = image
                                              }
                                      }
                    Button{
                        
                        if let image = self.image{  Image(uiImage: image)
                            showingAlert.toggle()
                            if(persistAptImage()){
                                showingAlert.toggle()
                            }
                        }
                        else{
                            if(addNewListing()){
                                showingAlert.toggle()
                            }
                        }
                        
                           
                        
                        
                        
                    }
                label:
                    {
                        Text("ADD POST").bold().font(.custom("LeagueSpartan-Bold",size: 16))
                    }
                    .padding(.vertical,16)
                    .frame(width: UIScreen.main.bounds.width-20)
                    .cornerRadius(12)
                    .background(Color(hex: colors.klan_blue))
                    .foregroundColor(Color(hex: colors.klan_pink))
                    .alert("Post Added!", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }}
             
            }.padding().background(Color(hex: backgroundColor))
        }
      
    }
    func persistAptImage()->Bool{
        let apartmentId = Int.random(in: 0..<60000)
       var result = ""
        var didSend = false
        let uid = FirebaseManager.shared.auth.currentUser?.uid
        let ref = FirebaseManager.shared.storage.reference(withPath: String(apartmentId))
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
                 result = url?.absoluteString ?? ""
              
                print("addNewListing")
               
              
                let apartmentData = [
                    "apartmentID":apartmentId,
                    "availableDate":self.availableDate,
                    "isOnMarket":"true",
                    "rent":self.rent,
                    "isHeatIncluded":self.isHeatIncluded,
                    "isGasIncluded":self.isGasIncluded ,
                    "isElectricityIncluded":self.isElectricityIncluded,
                    "arePetsAllowed":self.arePetsAllowed,
                    "isWifiIncluded":self.isWifiIncluded,
                    "isParkingIncluded":self.isParkingIncluded,
                    "addressLine1":self.addressLine1,
                    "addressLine2":self.addressLine2,
                    "apartmentNumber":self.apartmentNumber,
                    "city":self.city,
                    "state":self.state,
                    "zipcode":self.zipcode,
                    "country":self.country,
                    "postedbyUserName" : loggedInUser.userName,
                    "postedByUserId" : loggedInUser.userID,
                    "postedByUserContact" :loggedInUser.userContact,
                    "postedByUserEmail": loggedInUser.userEmail,
                    "postedByUserUid" :loggedInUser.uid,
                    "postedByUserPhoto" : loggedInUser.image,
                    "imageUrl":result,
                    "timestamp": Timestamp()
                ] as [String : Any]
                FirebaseManager.shared.firestore.collection("postsnew1")
                    .document(String(apartmentId)).setData(apartmentData){err in
                        if let err = err{
                           print(err)
                            didSend = false
                            return
                        }
                        didSend = true
                        print("Success")
                    }
                
            
            
            }
        
        }
    return didSend
    }
    func addNewListing()->Bool{
        var didSend = false
        print("addNewListing")
         let uid = FirebaseManager.shared.auth.currentUser?.uid
       let apartmentId = Int.random(in: 0..<60000)
        let apartmentData = [
            "apartmentID":apartmentId,
            "availableDate":self.availableDate,
            "isOnMarket":"true",
            "rent":self.rent,
            "isHeatIncluded":self.isHeatIncluded,
            "isGasIncluded":self.isGasIncluded ,
            "isElectricityIncluded":self.isElectricityIncluded,
            "arePetsAllowed":self.arePetsAllowed,
            "isWifiIncluded":self.isWifiIncluded,
            "isParkingIncluded":self.isParkingIncluded,
            "addressLine1":self.addressLine1,
            "addressLine2":self.addressLine2,
            "apartmentNumber":self.apartmentNumber,
            "city":self.city,
            "state":self.state,
            "zipcode":self.zipcode,
            "country":self.country,
            "postedbyUserName" : loggedInUser.userName,
            "postedByUserId" : loggedInUser.userID,
            "postedByUserContact" :loggedInUser.userContact,
            "postedByUserEmail": loggedInUser.userEmail,
            "postedByUserUid" :loggedInUser.uid,
            "postedByUserPhoto" : loggedInUser.image,
            "imageUrl":"",
            "timestamp": Timestamp()
        ] as [String : Any]
        FirebaseManager.shared.firestore.collection("postsnew1")
            .document(String(apartmentId)).setData(apartmentData){err in
                if let err = err{
                   print(err)
                    didSend = false
                    return
                }
                didSend = true
                print("Success")
            }
        return didSend
    }
    
}
 
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
