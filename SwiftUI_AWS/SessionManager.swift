//
//  SessionManager.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 02/05/2021.
//

import Amplify
import AWSMobileClient

enum AuthState {
    case signUp
    case login
    case resetPassword
    case confirmCode(username: String)
    case session(user: AuthUser)
}

struct AlertObject {
    var showAlert: Bool = false
    var showAlertSucess: Bool = false
    var alertMessage: String = ""
    var alertTitle: String = ""
    
    mutating func hideAlert() {
        self.showAlert = false
    }
    
    mutating func showAlert(title: String, message: String) {
        self.showAlertSucess = false
        self.showAlert = true
        self.alertMessage = message
        self.alertTitle = title
    }
    
    mutating func showAlertSucess(title: String, message: String) {
        self.showAlertSucess = true
        self.showAlert = true
        self.alertMessage = message
        self.alertTitle = title
    }
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var alertObject: AlertObject = AlertObject()
    
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .session(user: user)
        } else {
            authState = .login
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func showResetPassword() {
        authState = .resetPassword
    }
    
    func signUp(username: String, email: String, password: String) {
        let attributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.preferredUsername, value: username),
        ]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) { [weak self] result in
            
            switch result {
            case .success( let signUpResult):
                print("Sign up result: ", signUpResult)
                switch signUpResult.nextStep {
                case .done:
                    print("Finish sign up")
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: username)
                    }
                
                }
            case .failure(let error):
                print("-----")
                
                print(error)
                DispatchQueue.main.async {
                    self?.alertObject.showAlert(title: "Error SignUp", message: error.recoverySuggestion)
                }
            }
        }
    }
    
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code) {
            [weak self] result in
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.alertObject.showAlert(title: "Error Confirm", message: error.debugDescription)
                }
            }
        }
    }
    
    func login(username: String, password: String) {
        _ = Amplify.Auth.signIn(username: username, password: password) {
           [weak self] result in
            switch result {
            case .success(let signInResult):
                switch signInResult.nextStep {
                case .done:
                    print("Done")
                case .confirmSignUp(let additionalInfo):
                    print("confirmSignUp")
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: username)
                    }
                default:
                    print("All")
                    
                }
                
                if signInResult.isSignedIn {
                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.alertObject.showAlert(title: "Error Login", message: error.recoverySuggestion)
                }
            }
        }
    }
    
    func signout() {
        _ = Amplify.Auth.signOut() {
            [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.alertObject.showAlert(title: "Error Signout", message: error.debugDescription)
                }
            }
        }
    }
    
    func resetPassword(email: String) {
       _ = Amplify.Auth.resetPassword(for: email) { [weak self] result in
            switch result {
                case .success(let resetPasswordResult):
                    switch resetPasswordResult.nextStep {
                    case .confirmResetPasswordWithCode(let _, let _):
                        DispatchQueue.main.async {
                            self?.alertObject.showAlertSucess(title: "Confirm reset password", message: "Check the email for the confirm code.")
                        }
                    case .done:
                        print("Reset completed")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.alertObject.showAlert(title: "Reset password Error", message: error.recoverySuggestion)
                    }
            }
        }
    }
    
    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) {
        Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { [weak self] result in
            switch result {
            case .success:
                print("Password reset confirmed")
                DispatchQueue.main.async {
                    self?.showLogin()
                }
            case .failure(let error):
                print("Reset password failed with error \(error)")
                DispatchQueue.main.async {
                    self?.alertObject.showAlert(title: "Confirm New Password Error", message: error.errorDescription)
                }
            }
        }
    }
    
    func resendConfermationCode(username: String) {
        AWSMobileClient.default().resendSignUpCode(username: username, completionHandler: { (result, error) in
            if let signUpResult = result {
                print("A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)")
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        })
    }
    
}

