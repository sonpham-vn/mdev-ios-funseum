//
//  ContentView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    @State private var goingToBooking: Bool = false
    @State private var goingToTicket: Bool = false
    @State private var goingToQR: Bool = false
    @State private var goingToGallery: Bool = false
    @ObservedObject var eventInfo = EventInfo ()
    
    // MARK: - View
    var body: some View {
       
            
            
        NavigationView {
            ZStack{
            VStack() {
                
                
                NavigationLink(destination: BookingView(currentEvent:eventInfo.currentEvent, rootIsActive: self.$goingToBooking)
                               , isActive: $goingToBooking){}
                    .isDetailLink(false)
                    
                
                NavigationLink(destination: TicketView().navigationBarBackButtonHidden(false)
                               , isActive: $goingToTicket){}
                
                NavigationLink(destination: QRScanView().navigationBarBackButtonHidden(false)
                               , isActive: $goingToQR){}
                
                NavigationLink(destination: GalleryView().navigationBarBackButtonHidden(false)
                               , isActive: $goingToGallery){}
                
                
                Text("")
                    .font(.largeTitle).foregroundColor(Color.white)
                    .padding([.top, .bottom], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                /*Image("iosapptemplate")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .padding(.bottom, 50)*/
                
                CustomImageView(urlString:eventInfo.currentEvent.eventBanner!)
                    .frame(height:200)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Button(action: {
                        self.goingToBooking = true
                    }) {
                        Text("Booking")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    
                    Button(action: {
                        
                        self.goingToTicket = true
                    }) {
                        Text("Ticket")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    
                    Button(action: {
                        self.goingToQR = true
                    }) {
                        Text("QR Scan")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    
                    
                    Button(action: {
                        self.goingToGallery = true
                    }) {
                        Text("Gallery")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    
                }.padding([.leading, .trailing], 27.5)
                
                
            }
     
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("main-background-4")
                    .resizable()
                    .edgesIgnoringSafeArea(.all))
        
        
  
        }
        .navigationBarHidden(true)
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
