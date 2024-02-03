//
//  SearchView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var suggestedUsers: [User] = []

    var filteredSuggestedUsers: [User] {
        if !searchText.isEmpty {
            return suggestedUsers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            return suggestedUsers
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section() {
                    ForEach(filteredSuggestedUsers, id: \.id) { user in
                        AccountView(user: user)
                    }
                }
            }
            .padding()
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search")
            .onAppear {
                // Dohvatanje predloženih korisnika kada se prikaže ekran
                fetchSuggestedUsers()
            }
        }
    }

    private func fetchSuggestedUsers() {
        guard let url = URL(string: "http://localhost:3000/api/users/suggested") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Obrada odgovora sa servera
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Dekodiranje podataka u niz User objekata
                let suggestedUsers = try JSONDecoder().decode([User].self, from: data)

                // Ažuriranje suggestedUsers na glavnom nitu
                DispatchQueue.main.async {
                    self.suggestedUsers = suggestedUsers
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        .resume()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

