//
//  DetailsViewController.swift
//  UnsplashPhoto
//
//  Created by Yersin Kazybekov on 07.09.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private var data: PhotoWithInfo
    
    init(data: PhotoWithInfo) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = ColorProvider.background
        setNavigationController()
        setupLayout()
    }
    
    private lazy var imageHolder: UIImageView = {
        let view = UIImageView(image: data.image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = ColorProvider.imageBackground
        return view
    }()
    
    private lazy var authorNameView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = ColorProvider.imageBackground
        view.text = "Author: \(data.photographerName)"
        view.font = UIFont(name: "Arial", size: 26)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = ColorProvider.text
        return view
    }()
    
    private lazy var descriptionView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = ColorProvider.imageBackground
        view.text = "Desc: \(data.description ?? "No Data")"
        view.font = UIFont(name: "Arial", size: 26)
        view.textColor = ColorProvider.text
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        view.textAlignment = .natural
        return view
    }()
    
    private func setupLayout() {
        self.view.addSubview(imageHolder)
        self.view.addSubview(authorNameView)
        self.view.addSubview(descriptionView)

        let height = self.view.frame.height * 0.55
        NSLayoutConstraint.activate([
            imageHolder.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 8),
            imageHolder.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 8),
            imageHolder.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            imageHolder.heightAnchor.constraint(equalToConstant: height)
        ])
        
        NSLayoutConstraint.activate([
            authorNameView.topAnchor.constraint(equalTo: imageHolder.bottomAnchor,constant: 8),
            authorNameView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 8),
            authorNameView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            authorNameView.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: authorNameView.bottomAnchor,constant: 8),
            descriptionView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 8),
            descriptionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            descriptionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
        ])
    }
    
    private func setNavigationController() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = ColorProvider.text
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor =  ColorProvider.secondary
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .done,
            target: self,
            action: #selector(shareImage)
        )
        
        let saveToGallery = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.down.on.square"),
            style: .done,
            target: self,
            action: #selector(saveToGallery)
        )
        navigationItem.rightBarButtonItems = [shareButton, saveToGallery]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func shareImage() {
        let shareAll = [data.image]
        let activityViewController = UIActivityViewController(
            activityItems: shareAll,
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func saveToGallery() {
        UIImageWriteToSavedPhotosAlbum(
            data.image,
            self,
            #selector(alert(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @objc private func alert(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(
                title: "Save error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Saved!",
                message: "Your image has been saved to your photos.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
