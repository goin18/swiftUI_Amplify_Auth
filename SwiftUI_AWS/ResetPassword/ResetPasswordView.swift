//
//  ResetPasswordView.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 05/05/2021.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var emailReset = ""
    @State var confirmPassworfActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("", destination: ConfirmResetPassword(email: emailReset), isActive: $confirmPassworfActive)
                Spacer()
                TextField("Username", text: $emailReset)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                Button("Reset password", action: {
                    sessionManager.resetPassword(email: self.emailReset)
                })
                .padding()
                
                Spacer()
                Button("Back to Loin", action: {
                    sessionManager.showLogin()
                })
            }
            .padding()
            .navigationBarTitle("Reset password")
        }
        .alert(isPresented: $sessionManager.alertObject.showAlert ) {
            if sessionManager.alertObject.showAlertSucess {
               return Alert(title: Text(sessionManager.alertObject.alertTitle),
                      message: Text(sessionManager.alertObject.alertMessage),
                      dismissButton: Alert.Button.default(Text("Continue..."), action: {
                        print("Button continue press")
                        self.confirmPassworfActive = true
                      })
                )
            } else {
                return Alert(title: Text(sessionManager.alertObject.alertTitle),
                      message: Text(sessionManager.alertObject.alertMessage),
                      dismissButton: Alert.Button.default(Text("Ok"))
                )
            }
            
        }
        
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
