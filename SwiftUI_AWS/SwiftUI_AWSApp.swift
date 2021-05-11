//
//  SwiftUI_AWSApp.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 30/04/2021.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct SwiftUI_AWSApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
    }
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
            case .resetPassword:
                ResetPasswordView()
                    .environmentObject(sessionManager)
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
            case .confirmCode(let username):
                ConformationView(username: username)
                    .environmentObject(sessionManager)
            case .session(let user):
                SessionView(user: user)
                    .environmentObject(sessionManager)
           
            }
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured sucessfully")
        } catch {
            print("Could not intstall Amplify", error)
        }
    }
}
