//
//  NetworkService.swift
//  UnsplashPhoto
//
//  Created by Yersin Kazybekov on 07.09.2024.
//

import UIKit

final class NetworkService {
    
    private let apiKey = apiKeyGlobal
    private let secretKey = secretKeyGlobal
    private let baseURL = baseURLGlobal
    
    func fetchPhotos(for text: String, completion: @escaping ([PhotoWithInfo]?) -> Void) {
        let urlString = "\(baseURL)/search/photos?client_id=\(apiKey)&query=\(text)&per_page=30"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching photos: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data found")
                completion(nil)
                return
            }
            
            do {
                let searchResult = try JSONDecoder().decode(UnsplashSearchResult.self, from: data)
                let photos = searchResult.results
                self.downloadImages(from: photos) { images in
                    completion(images)
                }
            } catch {
                print("Error decoding photos: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    private func downloadImages(
        from photos: [UnsplashPhoto],
        completion: @escaping ([PhotoWithInfo]?) -> Void
    ) {
        var photosWithImages = [PhotoWithInfo]()
        let dispatchGroup = DispatchGroup()

        for photo in photos {
            dispatchGroup.enter()

            guard let imageURL = URL(string: photo.urls.regular) else {
                print("Invalid image URL")
                dispatchGroup.leave()
                continue
            }

            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    let photoWithImage = PhotoWithInfo(
                        id: photo.id,
                        description: photo.description,
                        altDescription: photo.alt_description,
                        photographerName: photo.user.name,
                        image: image
                    )
                    
                    photosWithImages.append(photoWithImage)
                }

                dispatchGroup.leave()
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            completion(photosWithImages)
        }
    }
}
