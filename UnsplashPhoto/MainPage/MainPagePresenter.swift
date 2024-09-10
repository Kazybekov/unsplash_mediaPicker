//
//  MainPagePresenter.swift
//  UnsplashPhoto
//
//  Created by Yersin Kazybekov on 07.09.2024.
//

import UIKit

final class MainPagePresenter {
    
    init () {
        setSuggestions()
        loadHistory()
    }
    private let network = NetworkService()
    var suggestions: [String] = []
    var allSuggestions: [String] = []
    var history: [String] = []
    var images: [PhotoWithInfo?] = []
    
    var shouldShowHistory: Bool {
            return history.count > 0 && suggestions.isEmpty
    }
    
    func handleInput(input: String, dataReload: @escaping () -> Void) {
        addToHistory(searchTerm: input)
        network.fetchPhotos(for: input) { images in
            if let images = images {
                self.images = images
                dataReload()
            } else {
                print("Failed to download images")
            }
        }
    }
    private func setSuggestions() {
        if let url = Bundle.main.url(forResource: "suggestions", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                allSuggestions = try JSONDecoder().decode([String].self, from: data)
            } catch {
                print("Failed to load suggestions: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadHistory() {
        if let url = getHistoryFileURL() {
            do {
                let data = try Data(contentsOf: url)
                let decodedHistory = try JSONDecoder().decode([String].self, from: data)
                self.history = decodedHistory
            } catch {
                print("Failed to load search history: \(error.localizedDescription)")
            }
        }
    }
    
    private func addToHistory(searchTerm: String) {
        if history.contains(searchTerm) {
            return
        }
        history.insert(searchTerm, at: 0)
        if history.count > 5 {
            history = Array(history.prefix(5))
        }
        saveHistory()
    }
    
    private func saveHistory() {
        if let url = getHistoryFileURL() {
            do {
                let data = try JSONEncoder().encode(history)
                try data.write(to: url)
            } catch {
                print("Failed to save search history: \(error.localizedDescription)")
            }
        }
    }
    
    private func getHistoryFileURL() -> URL? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return nil }
        return documentDirectory.appendingPathComponent("history.json")
    }
    
}
