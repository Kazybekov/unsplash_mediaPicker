//
//  ImageCollectionViewCell.swift
//  UnsplashPhoto
//
//  Created by Yersin Kazybekov on 07.09.2024.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    internal var data: PhotoWithInfo?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "cloud")
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = ColorProvider.imageBackground
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Ariel", size: 16)
        label.textColor = ColorProvider.text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
    
    func setData(data: PhotoWithInfo?) {
        self.data = data
        if let data {
            imageView.image = data.image
            label.text = "Author: \(data.photographerName)"
        } else {
            imageView.image = UIImage(systemName: "cloud")
            label.text = "Author: No Data"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

