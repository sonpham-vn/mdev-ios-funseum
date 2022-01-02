//
//  BookingView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct BookingView: View {
    
    // MARK: - Propertiers
    @State private var goingToPayment: Bool = false
    @State private var quantity = "1"
    @State private var time = Date()
    @State var currentEvent = eventInfo()
    @State var currentBooking = bookingInfo()
    @Binding var rootIsActive : Bool

    
    // MARK: - View
    var body: some View {
            
            
            
            VStack() {
                
                
                NavigationLink(destination: PaymentView(currentEvent: currentEvent, currentBooking: currentBooking, time: time, shouldPopToRootView:$rootIsActive)
                               , isActive: $goingToPayment){}
                    .isDetailLink(false)
                
                CustomImageView(urlString:currentEvent.eventBanner!)
                    .frame(height:200)
                    .padding(.bottom, 20)
                
                Text(currentEvent.eventName!)
                    .font(.largeTitle).foregroundColor(Color.black)
                    .padding([.top], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                Text("Price: " + String(currentEvent.price!) + " (Tax not included)")
                    .font(.title).foregroundColor(Color.black)
                    .padding([.bottom], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Quantity")
                    TextField("Quantiy", text: self.$quantity)
                        .padding()
                        .keyboardType(.numberPad)
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    DatePicker("Time", selection: self.$time)
                        
                    
                }.padding([.leading, .trailing], 27.5)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Button(action: {
                        currentBooking = BookingInfo.priceCalculator(quantity: Int(self.quantity)!, price: currentEvent.price!)
                        self.goingToPayment = true
                    }) {
                        Text("Book Ticket")
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
            .background(
                Image("ticket_background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all))
    }
    
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingViewContainer()
    }
}

struct BookingViewContainer : View {
     @State
     private var value = false
    @State private var value2 = eventInfo()

     var body: some View {
        BookingView(currentEvent: value2, rootIsActive: $value)
     }
}

