//
//  ContentView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true))
                {
                    
                    Image("logo-black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230, height: 550)
                        .padding(.top, 10)
                    }

                Text("Welcome to Threads!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
