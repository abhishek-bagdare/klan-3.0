////
////  HomeView.swift
////  klan-3.0
////
////  Created by Abhishek Bagdare on 4/25/23.
////
//
//import SwiftUI
//
//struct HomeView: View {
//    var body: some View {
//        VStack{
//            Spacer()
//            Spacer()
//            HStack{
//                TabIcon(imageName: "house")
//                TabIcon(imageName: "person")
//                TabIcon(imageName: "house")
//                TabIcon(imageName: "house")
//                TabIcon(imageName: "house")
//                
//            }.frame(height: UIScreen.main.bounds.height/10)
//                .frame(width: UIScreen.main.bounds.w )
//                .background(Color.gray)
//        }.ignoresSafeArea()
//    }
//}
//
//struct TabIcon:View{
//    let imageName : String
//    var body:some View{
//        //home
//        Button{
//            print("c")
//        }label: {
//            Image(systemName: imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 20,height: 20)
//                .foregroundColor(.black)
//                .frame(width: .infinity)
//            
//        }
//        
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
//
//enum TabBarViewModel : Int,CaseIterable{
//    case home
//    case search
//    case messages
//    case account
//    
//    var imageName : String{
//        switch self{
//        case .home : return "house.fill"
//        case .search : return "house.fill"
//        case .messages : return "house.fill"
//        case .account : return "user.fill"
//        
//        }
//    }
//    
//    var view:some View{
//        switch self{
//        case .home : return Text("home")
//        case .search : return Text("home")
//        case .messages : return Text("home")
//        case .account : return Text("home")
//        }
//    }
//}
