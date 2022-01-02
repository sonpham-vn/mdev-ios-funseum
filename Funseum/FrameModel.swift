//
//  FrameModel.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import Foundation
import Combine

struct frameStatus:  Identifiable {
    var id = UUID()
    var frameId: String? = nil
    var frameName: String? = nil
    var frameFile: String? = nil
    var active: Bool? = false
    var icon: String? = nil
}

struct frameInfo {
    var userId: String? = nil
    var point: Int? = nil
    var currentStatus: [frameStatus]? = nil
}

struct originalFrameStatus: Encodable {
    var frameId: String? = nil
    var frameName: String? = nil
    var frameFile: String? = nil
    var Active: Bool? = false
    var icon: String? = nil
}




class FrameInfo : ObservableObject {
    @Published var currentFrameInfo = frameInfo()
    @Published var originalFrameInfo = [originalFrameStatus]()
    
    var pub: AnyPublisher<(data: Data, response: URLResponse), URLError>? = nil
    var sub: Cancellable? = nil
    
    
    
    
    init () {fetchFrame()}
    func fetchFrame () {
        let defaults = UserDefaults.standard
        let userId = defaults.string(forKey: "userId")
        let API_URL = "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/frameinfo?UserId=" + userId!
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
                case .failure(let error): fatalError(error.localizedDescription)
                }
            },
            receiveValue: {
                print (String(data: $0.data, encoding: .utf8))
                
                //let jsonString = String(data: $0.data, encoding: .utf8)
                //print (jsonString)
                
                do {
                    let json = try JSON(data: $0.data)
                    
                    print (json)
                    self.currentFrameInfo = frameInfo()
                    self.originalFrameInfo = [originalFrameStatus]()
                    self.currentFrameInfo.userId = json["UserId"].stringValue
                    self.currentFrameInfo.point = json["Point"].intValue
                    var frameArray = [frameStatus]()
                    for i in 0..<json["Frame"].count{
                        var icon = "lock"
                        print("ICON")
                        if (json["Frame"][i]["Active"].boolValue) {
                            icon = ""
                        }
                        frameArray.append(frameStatus(
                            frameId:json["Frame"][i]["frameId"].stringValue,
                                            frameName:json["Frame"][i]["frameName"].stringValue,
                                            frameFile:json["Frame"][i]["frameFile"].stringValue,
                                            active:json["Frame"][i]["Active"].boolValue,
                            icon:icon
                                            
                        ))
                        self.originalFrameInfo.append(originalFrameStatus(
                            frameId:json["Frame"][i]["frameId"].stringValue,
                                            frameName:json["Frame"][i]["frameName"].stringValue,
                                            frameFile:json["Frame"][i]["frameFile"].stringValue,
                                            Active:json["Frame"][i]["Active"].boolValue
                        ))
                    }
                    self.currentFrameInfo.currentStatus = frameArray
                    print("FRAME STATUSES")
                    print(self.currentFrameInfo)
                    
             
                } catch {
                    print ("Error when parse json")
                }
            }
        )
    }
    
    

}

class FrameUnlock {
    
   

    static func unlock(newFrameInfo: [originalFrameStatus], completionBlock: @escaping (apiResponse) -> Void) -> Void {
        
        let defaults = UserDefaults.standard
        let userId = defaults.string(forKey: "userId")
        let url = URL(string: "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/unlockframe")!
        let session = URLSession.shared
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        guard let jsonData = try? jsonEncoder.encode(newFrameInfo) else {return}
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        let parameterDictionary = [
            "UserId" : userId,
            "FrameArray" : jsonString,
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
