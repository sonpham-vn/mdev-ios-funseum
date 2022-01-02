//
//  AccountValidator.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import Foundation

struct apiResponse {
    var status: Int
    var message: String? = nil
}



class AccountValidator {
    static func signin(user: String, password: String, completionBlock: @escaping (apiResponse) -> Void) -> Void {

        let url = URL(string: "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/signin")!
        let session = URLSession.shared
        let parameterDictionary = ["UserName" : user, "Password" : password]
        var request = URLRequest(url: url)
        var signinResponse = apiResponse (status:0)
        
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
            let defaults = UserDefaults.standard
            
            
            signinResponse.status = signinJson["statusCode"] as! Int
            if (signinResponse.status == 200) {
                defaults.set(signinJson["UserId"], forKey: "userId")
            }
            completionBlock(signinResponse)
 
           } catch let error {
             print(error.localizedDescription)
           }
        })
        task.resume()
       
    }
    
    static func signup(user: String, password: String, completionBlock: @escaping (apiResponse) -> Void) -> Void {

        let url = URL(string: "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/signup")!
        let session = URLSession.shared
        let parameterDictionary = ["UserName" : user, "Password" : password]
        var request = URLRequest(url: url)
        var signupResponse = apiResponse (status:0)
        
        
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
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            
            guard let signupJson = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error when parse json")
                            return
                        }
            let defaults = UserDefaults.standard
            
            signupResponse.status = signupJson["statusCode"] as! Int
            if (signupResponse.status == 200) {
                defaults.set(signupJson["UserId"], forKey: "userId")
            }
            completionBlock(signupResponse)
           } catch let error {
             print(error.localizedDescription)
           }
        })
        task.resume()
      
    }
    
}
