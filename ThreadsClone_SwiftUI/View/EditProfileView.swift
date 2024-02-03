//
//  EditProfileView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct EditProfileView: View {
        @State private var bio = ""
        @State private var isPrivateProfile = false
        @Environment(\.presentationMode) var presentationMode
        @State private var selectedImage: UIImage? = nil
        @State private var showImagePicker: Bool = false
    
    private var currentUser: User? {
            if let userData = UserDefaults.standard.data(forKey: "currentUser"),
               let user = try? JSONDecoder().decode(User.self, from: userData) {
                return user
            }
            return nil
        }
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                    .navigationBarBackButtonHidden(true)
                
                VStack{
                    HStack {
                        
                        VStack (alignment: .leading ) {
                            //Text(currentUser?.id ?? "")
                              //  .fontWeight(.semibold)
                            Text(currentUser?.username ?? "")
                                .fontWeight(.semibold)
                            Text(currentUser?.name ?? "")
                                .fontWeight(.semibold)

                        }
                        .font(.footnote)
                        Spacer()
                        AsyncImage(
                            url: URL(string: currentUser?.profilePic ?? ""),
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40,height: 50)
                                    .clipShape(Circle())                            },
                            placeholder: {
                                Image("logo-black")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40,height: 50)
                                    .clipShape(Circle())
                            })
                    }
                    Divider()
                    
                    VStack (alignment: .leading ) {
                        Text("Bio:")
                        .fontWeight(.semibold)
                        TextField("Enter bio...", text: $bio)
                                .onAppear {
                                    bio = currentUser?.bio ?? ""
                                }
                    }
                    .font(.footnote)
                    
                    Divider()
                    
                    Toggle("Private profile", isOn: $isPrivateProfile)
                    
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
               .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: . navigationBarLeading) {
                    Button("Cancel"){
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                ToolbarItem(placement: . navigationBarTrailing) {
                    
                    Button("Done") {
                        let apiUrl = URL(string: "http://localhost:3000/api/users/update/\(currentUser?.id ?? "")")!
                                        // Korišćenje username umesto id-a u URL-u

                                        var request = URLRequest(url: apiUrl)
                                        request.httpMethod = "PUT"

                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                                        let requestBody = [
                                            "bio": bio
                                            // Dodajte druge polja po potrebi
                                        ]

                                        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                                            print("Error converting request body to JSON")
                                            return
                                        }

                                        request.httpBody = jsonData

                                        URLSession.shared.dataTask(with: request) { data, response, error in
                                            if let error = error {
                                                print("Error: \(error.localizedDescription)")
                                            } else if let data = data {
                                                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                                                    print("Response JSON: \(json)")
                                                }
                                            }

                                            DispatchQueue.main.async {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        }.resume()

                                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
                
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
            EditProfileView()
        }
 
}
