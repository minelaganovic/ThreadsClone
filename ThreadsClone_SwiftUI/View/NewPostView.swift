//
//  NewPostView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI
import UIKit

struct NewPostView: View {
    @State private var shouldNavigateToHome = false
    @State private var isPostCreated = false
    @State private var caption = ""
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
   // @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false
    @State private var alertMessage = ""


    private var currentUser: User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                selectedImages.append(selectedImage)
            }

            isImagePickerPresented = false
        }
    
    func createPost() {
        guard let currentUser = currentUser else { return }

        let url = URL(string: "http://localhost:3000/api/posts/create")! // Zamenite sa vašim stvarnim server URL-om
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let postBody: [String: Any] = [
            "postedBy": currentUser.id,
            "text": caption,
            "img": "/Users/User/Desktop/forest.jpg"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postBody)
        } catch {
            print("Error serializing postBody: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedPost = try JSONDecoder().decode(Post.self, from: data)
                    print("Successfully created post: \(decodedPost)")

                    // Post je uspešno kreiran, postavite isPostCreated na true
                    isPostCreated = true
                    
                    // Postavite showAlert na true i pripremite odgovarajuću poruku
                    showAlert = true
                    alertMessage = "Post successfully created!"

                    // Postavljanje caption na prazan string
                    caption = ""
                } catch {
                    print("Error decoding post: \(error)")
                }
            } else if let error = error {
                print("Error creating post: \(error)")
            }
        }.resume()    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    AsyncImage(
                        url: URL(string: currentUser?.profilePic ?? ""),
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                        }, placeholder: {
                            Circle()
                                .foregroundColor(Color("Gray").opacity(0.2))
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                        })

                    VStack(alignment: .leading) {
                        Text(currentUser?.username ?? "")
                            .fontWeight(.semibold)
                        TextField("Start a thread ...", text: $caption, onEditingChanged: { _ in
                            // Handle editing changed event if needed
                        })
                    }
                    .font(.footnote)
                    Spacer()

                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Image(systemName: "camera")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                    }
                    
                    if !caption.isEmpty {
                        Button(action: {
                            // Handle post button action
                        }) {
                            Image(systemName: "mark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                                           ForEach(selectedImages, id: \.self) { image in
                                               Image(uiImage: image)
                                                   .resizable()
                                                   .scaledToFit()
                                                   .frame(width: 300, height: 280)
                                                   .clipShape(Rectangle())
                                                   .padding()
                                           }
                                       }
                                   }
                if !selectedImages.isEmpty {
                    Button(action: {
                        // Postavite logiku za otkazivanje
                        selectedImages.removeAll()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Cancel")
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createPost()
                    }
                    .opacity(caption.isEmpty ? 0.5 : 1.0)
                    .disabled(caption.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
                
            }
            .sheet(isPresented: $isImagePickerPresented) {
                           ImagePicker(selectedImages: $selectedImages, isImagePickerPresented: $isImagePickerPresented)
                       }
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }


        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
