//
//  ConformationView.swift
//  SwiftUI_AWS
//
//  Created by Marko Budal on 30/04/2021.
//

import SwiftUI

struct ConformationView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var conformationCode = ""
    
    let username: String
    
    var body: some View {
        VStack {
            Button("Resend confirm code", action:{
                sessionManager.resendConfermationCode(username: username)
            })
            .padding()
            Text("Username: \(username)")
            TextField("Confirmation code", text: $conformationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            Button("Confirm", action:{
                sessionManager.confirm(username: username, code: conformationCode)
            })
            .padding()
        }
        .padding()
    }
}

struct ConformationView_Previews: PreviewProvider {
    static var previews: some View {
        ConformationView(username: "markob")
    }
}
