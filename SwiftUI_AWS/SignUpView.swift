//
//  SignUpView.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 30/04/2021.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            Button("Sign Up", action: {
                sessionManager.signUp(username: username, email: email, password: password)
            })
            .padding()
            
            Spacer()
            Button("Alredy have an account? Log in.", action: {
                sessionManager.showLogin()
            })
        }
        .padding()
        .alert(isPresented: $sessionManager.alertObject.showAlert ) {
            Alert(title: Text(sessionManager.alertObject.alertTitle),
                  message: Text(sessionManager.alertObject.alertMessage),
                  dismissButton: .default(Text("Ok"))
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
