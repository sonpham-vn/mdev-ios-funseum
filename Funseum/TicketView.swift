//
//  TicketView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct TicketView: View {
    @State private var goingToPayment: Bool = false
    @State private var quantity = "1"
    @State private var time = Date()
    @ObservedObject var ticketInfo = TicketInfo ()
    
    
    var body: some View {
        NavigationView{
            ZStack {
            List (ticketInfo.ticketList, id: \.createdDate) {
                ticket in
                HStack (alignment: .center) {
                    Spacer()
                    VStack {
                    Text (ticket.eventName!)
                    Text ("Time: " + ticket.time!)
                    Text ("Number of people: " + String(ticket.quantity!))
                    Text ("Code: "+ticket.ticketId!.prefix(8).uppercased())
                    }.padding()
                    Spacer()
                   
                }.background(
                    Image("ticket_background")
                        .resizable()
                        .edgesIgnoringSafeArea(.all))
                .border(Color.black, width: 1)
                
                
                
            }
            }
        }
        .onAppear (perform: {
            
            self.ticketInfo.fetchTicket()
        })
        .navigationBarBackButtonHidden(false)
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView()
    }
}
