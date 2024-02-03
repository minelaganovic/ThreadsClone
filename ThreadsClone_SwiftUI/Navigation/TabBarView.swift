//
//  TabBarView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI


struct TabBarButton: View {
    @Binding var selectedTab: Tabs
    @Binding var currentTab: Tabs
    
    var filled: String {
        switch selectedTab {
        case .home, .notifications, .profile:
            return ".fill"
        default:
            return ""
        }
    }
    
    var body: some View {
        GeometryReader{geo in
            Button {
                selectedTab = currentTab
            } label: {
                Image(systemName: {
                    switch currentTab {
                    case .home:
                        return "house"
                    case .search:
                        return "magnifyingglass"
                    case .add_post:
                        return "square.and.pencil"
                    case .notifications:
                        return "heart"
                    case .profile:
                        return "person"
                    }
                }())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
                    //.padding(.vertical,5)
            }
            .tint(selectedTab == currentTab ? Color("Text") : Color("Gray"))
            //ovo po nekad treba da se iskljuci po nekad ne...
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Tabs
    @State private var tabButtons: [Tabs] = [.home, .search, .add_post, .notifications, .profile]

    var body: some View {
        HStack(spacing: 0) {
            ForEach($tabButtons, id: \.self) { $tab in
                TabBarButton(selectedTab: $selectedTab, currentTab: $tab)
                Spacer()
            }
        }
        .padding()
        .background(Color("Primary"))
        .frame(maxWidth: 390, maxHeight: 50)
        Spacer() 
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.home))
    }
}
