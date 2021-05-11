//
//  ConfirmResetPassword.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 05/05/2021.
//

import SwiftUI

struct ConfirmResetPassword: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var email: String
    @State var code = ""
    @State var newPassword = ""
    var body: some View {
        VStack {
            Spacer()
            Text(email)
                .padding()
            TextField("Code", text: $code)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            TextField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            Button("Confirm", action: {
                sessionManager.confirmResetPassword(username: email, newPassword: newPassword, confirmationCode: code)
            })
            
            Spacer()
            
        }
        .navigationBarTitle("Confirm password")
        .alert(isPresented: $sessionManager.alertObject.showAlert ) {
            Alert(title: Text(sessionManager.alertObject.alertTitle),
                  message: Text(sessionManager.alertObject.alertMessage),
                  dismissButton: .default(Text("Ok"))
            )
        }
    }
}

struct ConfirmResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmResetPassword(email: "Test")
            
    }
}
