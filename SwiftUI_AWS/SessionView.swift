//
//  SessionView.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 30/04/2021.
//

import SwiftUI
import Amplify

struct SessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    let user: AuthUser
    
    var body: some View {
        VStack {
            Spacer()
            Text("You signed in using Amplify!!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Sign Out", action: {
                sessionManager.signout()  
            })
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    
    static var previews: some View {
        SessionView(user: DummyUser())
    }
}
