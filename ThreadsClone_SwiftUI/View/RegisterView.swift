import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var profilephoto = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo-black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top,150)
                
                TextField("Enter your full name", text: $fullname)
                    .modifier(ThreadsTextViewModifier())
                TextField("Enter the path to the profile photo", text:$profilephoto)
                    .modifier(ThreadsTextViewModifier())
                
                TextField("Enter your username", text: $username)
                    .modifier(ThreadsTextViewModifier())
                
                TextField("Enter your email", text: $email)
                    .modifier(ThreadsTextViewModifier())
                
                SecureField("Enter your password", text: $password)
                    .modifier(ThreadsTextViewModifier())
                    
                
                Button {
                    Task {
                        do {
                            try await viewModel.createUser(
                                name: fullname,
                                email: email,
                                username: username,
                                password: password,
                                registrationURL: "http://localhost:3000/api/users/signup"
                            )
                            
                            if viewModel.registrationSuccessful {
                                dismiss()
                            }
                        } catch {
                            print("Error registration: \(error)")
                        }
                    }
                } label: {
                    Text("Create Account ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 352, height: 38)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding()
                
                Spacer()
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing:3){
                        Text("You already have an account?")
                            .fontWeight(.semibold)
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.primary)
                    .font(.footnote)
                }
                .padding(.vertical,16)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Notification"),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text("OK"), action: {
                        if viewModel.registrationSuccessful {
                            dismiss() // Prebacivanje na ekran za prijavu
                        }
                    })
                )
                
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
