//
//  EncoderDecoders.swift
//  UnsplashPhoto
//
//  Created by Yersin Kazybekov on 09.09.2024.
//

import UIKit

struct PhotoURLs: Codable {
    let regular: String
}

struct UnsplashSearchResult: Decodable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let id: String
    let description: String?
    let alt_description: String?
    let urls: UnsplashPhotoURLs
    let user: UnsplashUser
}

struct UnsplashPhotoURLs: Decodable {
    let regular: String
}

struct UnsplashUser: Decodable {
    let name: String
}

struct PhotoWithInfo {
    let id: String
    let description: String?
    let altDescription: String?
    let photographerName: String
    let image: UIImage
}
