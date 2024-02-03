//
//  ProfileDetailsView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct ProfileDetailsView: View {
    var user: User
    var showCount: Bool
    @State private var isFollowingListPresented = false
    var body: some View {
        if showCount {
            HStack {
                VStack (alignment: .leading, spacing: 5) {
                    Text(user.name)
                        .customFont(.title)
                    Text(user.username)
                        .customFont(.title3)
                    Text(user.bio)
                        .customFont(.title3)
                    
                    if showCount {
                        Text("\(user.followersCount) followers, \(user.followingCount) following")
                            .customFont(.title3)
                            .foregroundColor(Color("Gray"))
                            .padding(.top, 10)
                        }

                }
                .padding(.top, 10)
                .foregroundColor(Color("Text"))
                
                Spacer()
                
                AsyncImage(
                    url: URL(string: user.profilePic),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                    },
                    placeholder: {
                        Image("logo-black")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                    })
                               
            }
            .background(Color("Primary"))
            .navigationBarHidden(true)
        }
    }
}



struct ProfileDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailsView(user: UserList.Users[0], showCount: true)
    }
}
