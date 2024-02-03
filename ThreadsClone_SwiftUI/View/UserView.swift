//
//  UserView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI
struct UserView: View {
    @State var tabIndex: Int = 0
    @State private var followed: Bool = false
    var selectedUser: User
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Button(action: {presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .customFont(.title)
                                    .foregroundColor(Color("Text"))
                            }
                            Spacer()
                            Image(systemName: "ellipsis.circle")
                                .customFont(.title)
                        }
                        .foregroundColor(Color("Text"))
                        
                        AsyncImage(
                            url: URL(string: selectedUser.profilePic),
                            content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(35)
                            }, placeholder: {
                                Circle()
                                    .foregroundColor(Color("Gray").opacity(0.2))
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(35)
                            }
                        )
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(selectedUser.username)
                                .customFont(.title3)
                            
                            Text(selectedUser.name)
                                .customFont(.headline)
                        }
                        
                        Button(action: {
                            followed.toggle()
                        }) {
                            Text(followed == false ? "Follow" : "Unfollow")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                        .customFont(.headline)
                        .background(Color(followed == false ? "Text" : "Primary"))
                        .foregroundColor(Color(followed == false ? "Primary" : "Text"))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                    }
                    .padding(20)
                    
                    HStack(spacing: 0) {
                        TabBarButtonView(text: "Threads", isSelected: .constant(tabIndex == 0))
                            .onTapGesture { onButtonTapped(index: 0) }
                        TabBarButtonView(text: "Replies", isSelected: .constant(tabIndex == 1))
                            .onTapGesture { onButtonTapped(index: 1) }
                    }
                    if tabIndex == 0 {
                        
                        Text("No threads to display.")
                            .foregroundColor(Color("Text"))
                            .padding()
                    }
                    if tabIndex == 1{
                        Text("No replies to display.")
                            .foregroundColor(Color("Text"))
                            .padding()
                    }
                    
                }
                .padding(20)
            }
        }
        .navigationBarHidden(true)  // Dodajte ovde
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
    }

    private func onButtonTapped(index: Int) {
        tabIndex = index
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(selectedUser: UserList.Users[0]) // Provide a user for preview
    }
}
