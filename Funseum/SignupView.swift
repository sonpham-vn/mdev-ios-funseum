//
//  SignupView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct SignupView: View {
    // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedUp: Bool = false
 
    
    var body: some View {
        VStack() {
            
            NavigationLink(destination: ContentView()
                            .navigationBarBackButtonHidden(true)
                           , isActive: $isSignedUp){}
            
        
            
            
      
            
            Image("iosapptemplate")
                .resizable()
                .frame(width: 250, height: 250)
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
                AccountValidator.signup(user:self.email,password:self.password) {
                    response in
                    if (response.status == 200) {self.isSignedUp = true}
                }
                
                //if (signUp.status == 200) { self.isSignedUp = true}
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.red)
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 50)
            
            Spacer()
            
        }
        .background(
            Image("sub-background")
                .resizable()
                .edgesIgnoringSafeArea(.all))
               
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
