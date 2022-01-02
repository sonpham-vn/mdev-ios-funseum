//
//  TicketModel.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import Foundation
import Combine

struct eventInfo {
    var eventId: String? = nil
    var eventName: String? = nil
    var eventBanner: String? = ""
    var price: Int? = nil
}

struct bookingInfo {
    var quantity: Int? = nil
    var totalPrice: Int? = nil
    var totalTax: Float? = nil
    var totalCharge: Float? = nil
}

struct ticketInfo {
    var ticketId: String? = nil
    var userId: String? = nil
    var eventId: String? = nil
    var eventName: String? = nil
    var quantity: Int? = nil
    var time: String? = nil
    var createdDate: String? = nil
}




class EventInfo : ObservableObject {
    @Published var currentEvent = eventInfo()
    
    var pub: AnyPublisher<(data: Data, response: URLResponse), URLError>? = nil
    var sub: Cancellable? = nil
    
    let API_URL = "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/event"
    
    init () {
        // network call
        guard let url = URL(string: API_URL) else {
            return
        }
        
        pub = URLSession.shared.dataTaskPublisher(for: url)
            .print("Call API")
            .eraseToAnyPublisher()
        
        sub = pub?.receive(on: DispatchQueue.main).sink(
            receiveCompletion:{
                completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    //fatalError(error.localizedDescription)
                break
                }
            },
            receiveValue: {
                print (String(data: $0.data, encoding: .utf8))
                
                //let jsonString = String(data: $0.data, encoding: .utf8)
                //print (jsonString)
                
                do {
                    let json = try JSON(data: $0.data)
                    
                    print (json)
                    self.currentEvent.eventBanner = json["eventBanner"].stringValue
                    self.currentEvent.eventId = json["eventId"].stringValue
                    self.currentEvent.eventName = json["eventName"].stringValue
                    self.currentEvent.price = json["price"].intValue
             
                } catch {
                    print ("Error when parse json")
                }
            }
        )
    }
    
    

}

class BookingInfo {
    
   
    
    static func priceCalculator(quantity: Int, price: Int) ->  bookingInfo {
        var currentBooking = bookingInfo ()
        currentBooking.quantity = quantity
        currentBooking.totalPrice = quantity * price
        currentBooking.totalTax = Float(currentBooking.totalPrice!) * 0.15
        currentBooking.totalCharge = Float(currentBooking.totalPrice!) + currentBooking.totalTax!
        return currentBooking
    }
    
    static func booking(currentEvent: eventInfo, currentBooking: bookingInfo, time: Date, completionBlock: @escaping (apiResponse) -> Void) -> Void {
        
        let defaults = UserDefaults.standard
        let userId = defaults.string(forKey: "userId")

        let url = URL(string: "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/booking")!
        let session = URLSession.shared
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let parameterDictionary = [
            "UserId" : userId,
            "EventId" : currentEvent.eventId!,
            "EventName" : currentEvent.eventName!,
            "Time": formatter.string(from:time),
            "Quantity": currentBooking.quantity!
        ] as [String : Any]
        var request = URLRequest(url: url)
        var bookingResponse = apiResponse (status:0)
        
        request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
            request.httpBody = httpBody
        
        //fetch data
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

           do {
            print("call api done")
            guard let signinJson = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error when parse json")
                            return
                        }
    
            print("finish json")
            
            bookingResponse.status = signinJson["statusCode"] as! Int
            completionBlock(bookingResponse)
 
           } catch let error {
             print(error.localizedDescription)
           }
        })
        task.resume()
       
    }
    
}

class TicketInfo : ObservableObject {
    @Published var ticketList = [ticketInfo]()
    
    var pub: AnyPublisher<(data: Data, response: URLResponse), URLError>? = nil
    var sub: Cancellable? = nil
    var dbHandler = DatabaseHandler()
    
    
    
    init () {
        //fetchTicket()
    }
    func fetchTicket () {
        let defaults = UserDefaults.standard
        let userId = defaults.string(forKey: "userId")
        let API_URL = "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/ticket?UserId=" + userId!
        // fetch from db first
        self.ticketList = dbHandler.getTicketList(userId: userId!)
        
        // network call
        guard let url = URL(string: API_URL) else {
            return
        }
        
        pub = URLSession.shared.dataTaskPublisher(for: url)
            .print("Call API")
            .eraseToAnyPublisher()
        
        sub = pub?.receive(on: DispatchQueue.main).sink(
            receiveCompletion:{ [self]
                completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    //fatalError(error.localizedDescription)
                    break
                }
            },
            receiveValue: { [self] in
                print (String(data: $0.data, encoding: .utf8))
                
                //let jsonString = String(data: $0.data, encoding: .utf8)
                //print (jsonString)
                
                do {
                    let json = try JSON(data: $0.data)
                    print ("GETTICKET")
                    //print (json)
                    self.ticketList = [ticketInfo]()
                    dbHandler.createTicketTable()
                    dbHandler.deleteTicketList(userId: userId!)
                    
                    if let httpResponse = $0.response as? HTTPURLResponse{
                        if httpResponse.statusCode == 200 {
                    for i in 0..<json.count{
                        //print("TICKET INFO")
                        //print(json[i])
                        self.ticketList.append(ticketInfo(
                            ticketId: json[i]["TicketId"].stringValue,
                            userId: json[i]["UserId"].stringValue,
                            eventId: json[i]["EventId"].stringValue,
                            eventName: json[i]["EventName"].stringValue,
                            quantity: json[i]["Quantity"].intValue,
                            time: json[i]["BookingTime"].stringValue,
                            createdDate: json[i]["CreatedDate"].stringValue
                        ))
                        
                        dbHandler.insertData(TicketId: json[i]["TicketId"].stringValue,
                                             UserId: json[i]["UserId"].stringValue,
                                             EventId: json[i]["EventId"].stringValue,
                                             EventName: json[i]["EventName"].stringValue,
                                             Quantiy: json[i]["Quantity"].intValue,
                                             Time: json[i]["BookingTime"].stringValue,
                                             CreatedDate: json[i]["CreatedDate"].stringValue)
                        objectWillChange.send()
                    }
                        }
                    }
                    //print(self.ticketList)
             
                } catch {
                    print ("Error when parse json")
                }
            }
        )
    }
    
    

}
