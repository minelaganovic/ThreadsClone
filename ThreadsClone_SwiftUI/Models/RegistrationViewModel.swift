//
//  RegistrationViewModel.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 2.1.24..
//


import Foundation
struct RegistrationData: Codable {
    let name: String
    let email: String
    let username: String
    let password: String
} 

class RegistrationViewModel: ObservableObject {
    @Published var registrationSuccessful = false
    @Published var alertMessage: String?
    @Published var showAlert = false
    
    // ...
    
    func createUser(name: String, email: String, username: String, password: String, registrationURL: String) async throws {
        let registrationData = RegistrationData(name: name, email: email, username: username, password: password)
        let registrationURL = URL(string: registrationURL)!
        var request = URLRequest(url: registrationURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(registrationData)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            registrationSuccessful = true
            showAlert = true
            alertMessage = "Uspešno kreiran nalog!"
            
        } catch {
            showAlert = true
            alertMessage = "Greška prilikom registracije: \(error.localizedDescription)"
        }
    }
}
