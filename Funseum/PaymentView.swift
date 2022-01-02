//
//  PaymentView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct PaymentView: View {
    @State private var goingToHome: Bool = false
    @State var currentEvent = eventInfo()
    @State var currentBooking = bookingInfo()
    @State var time = Date ()
    @Binding var shouldPopToRootView : Bool
    
   
    var body: some View {
    
            
            
            
            
            VStack() {
                
                
                
                
                Text("Booking details")
                    .font(.largeTitle).foregroundColor(Color.black)
                    .padding([.top, .bottom], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                VStack {
                    VStack {
                    Text("\nEvent: "+currentEvent.eventName!)
                    Text("Quantity: "+String(currentBooking.quantity!))
                    Text("Total price: " + String(currentBooking.totalPrice!))
                    Text("Tax: "+String(currentBooking.totalTax!))
                    Text("Total charge: "+String(currentBooking.totalCharge!)+"\n\n")
                    }.padding()
                    }
                .border(Color.black, width: 1)
                .padding()
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Button(action: {
                        NotificationGenerator.generateNotification(title: "We're looking forward to see you", description: "You got a booking to our museum soon!")
                        BookingInfo.booking(currentEvent:currentEvent, currentBooking: currentBooking, time: time ) {
                            response in
                            if (response.status == 200) {self.shouldPopToRootView = false}
                        }
                        
                    }) {
                        Text("Pay Now")
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

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentViewContainer()
    }
}

struct PaymentViewContainer : View {
     @State
     private var value = false

     var body: some View {
        PaymentView(shouldPopToRootView: $value)
     }
}
