//
//  LoginView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//
import Combine
import SwiftUI


struct LoginView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var wrongemail: CGFloat = 0
    @State private var wrongPassword: CGFloat = 0
    @State private var showingLoginScreen=false
    @State private var loginMessage = ""
    @State private var isLoginViewPresented = false
    @State private var cancellables: Set<AnyCancellable> = Set()

    @State private var user: User?
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Image("logo-black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top,180)
                VStack{
                    TextField("Enter your username", text: $username)
                        .autocapitalization(.none)
                        .modifier(ThreadsTextViewModifier())
                        .border(.red, width: wrongemail)
                    
                    SecureField("Enter your password", text: $password)
                        .modifier(ThreadsTextViewModifier())
                        .border(.red, width: wrongPassword)
                }
                HStack {
                    Spacer()
                    Text("Forgot password?")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.trailing,18)
                }
                Button{
                    authenticateUser(username: username, password: password)
                    
                } label: {
                     Text("Login")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 352,height: 38)
                    .background(Color.black)
                    .cornerRadius(8)
                    
                    }
                Spacer()
                Divider()
                NavigationLink{
                    RegisterView()
                        .navigationBarBackButtonHidden(true)
                }label:{
                    HStack(spacing:3){
                        Text("Dont have an account!")
                            .fontWeight(.semibold)
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.primary)
                    .font(.footnote)
                }
                .padding(.vertical,16)
                
                Text(loginMessage)
                    .foregroundColor(.red)
                    .padding()
                NavigationLink(
                    destination: ThreadsRootView()
                        .navigationBarBackButtonHidden(true),
                    isActive: $showingLoginScreen) {
                        
                    }
                
                
            }
        }
        
    }
    func authenticateUser(username: String, password: String) {
        YourAPIManager.loginUser(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    loginMessage = "Failed to authenticate user"
                }
            }, receiveValue: { user in
                do {
                    let userData = try JSONEncoder().encode(user)
                    if let jsonString = String(data: userData, encoding: .utf8) {
                        print("Received JSON: \(jsonString)")
                    }

                    // Continue processing the user data

                    // Check if the password is correct (replace this condition with your logic)
                    let isPasswordCorrect = true

                    if isPasswordCorrect {
                        // Save user data to UserDefaults
                        UserDefaults.standard.set(userData, forKey: "currentUser")

                        // Perform navigation to the next view
                        showingLoginScreen = true
                    } else {
                        loginMessage = "Incorrect password"
                    }
                } catch {
                    print("Error encoding user data: \(error)")
                }
            })
            .store(in: &cancellables)
    }

    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
