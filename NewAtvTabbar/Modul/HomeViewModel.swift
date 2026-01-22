//
//  HomeViewModel.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var sections: [SectionData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
//    private let apiURL = "https://api.tmgrup.com.tr/v2/link/c8b4449a37"
    
    func fetchData() {
        self.isLoading = true
        self.errorMessage = nil
        
        guard let url = Bundle.main.url(forResource: "HomeData", withExtension: "json") else {
            self.errorMessage = "Local JSON file not found"
            self.isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            DispatchQueue.main.async {
                self.sections = response.data.filter { $0.isActiveIOS == true }
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Decoding error: \(error.localizedDescription)"
                self.isLoading = false
                print("Decoding Error: \(error)")
            }
        }
    }
}
