//
//  SigninView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct SigninView: View {
    // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn: Bool = false
    @State private var goingToSignUp: Bool = false
    
    
    // MARK: - View
    var body: some View {
        
        
        
        NavigationView{
            
            
            VStack() {
                
                NavigationLink(destination: ContentView()
                                .navigationBarBackButtonHidden(true)
                               , isActive: $isSignedIn){}
                
                NavigationLink(destination: SignupView().navigationBarBackButtonHidden(false)
                               , isActive: $goingToSignUp){}
                
                
                
                Image("app-logo-2")
                    .resizable()
                    .frame(width: 270, height: 130)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .padding(.bottom, 50)
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email", text: self.$email)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    
                    SecureField("Password", text: self.$password)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }.padding([.leading, .trailing], 27.5)
                
                Button(action: {
                    AccountValidator.signin(user:self.email,password:self.password) {
                        response in
                        if (response.status == 200) {self.isSignedIn = true}
                    }
                   
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.red)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }.padding(.top, 50)
                
                
                Button(action: {
                    self.goingToSignUp = true
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }.padding(.top, 30)
                
                Spacer()
       
            }
            .background(
                Image("main-background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}


