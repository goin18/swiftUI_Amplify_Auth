//
//  LoginView.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 30/04/2021.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            Button("Login", action: {
                sessionManager.login(username: username, password: password)
            })
            
            Spacer()
                
            Button("Forgot password", action: {
                sessionManager.showResetPassword()
            })
            .padding()
            
                
            Button("Don't have an account? Sign up.", action: {
                sessionManager.showSignUp()
            })
        }
        .alert(isPresented: $sessionManager.alertObject.showAlert ) {
            Alert(title: Text(sessionManager.alertObject.alertTitle),
                  message: Text(sessionManager.alertObject.alertMessage),
                  dismissButton: .default(Text("Ok"))
            )
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
