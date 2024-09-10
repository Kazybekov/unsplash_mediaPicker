//
//  CustomTableViewCell.swift
//  UnsplashPhoto
//
//  Created by Yersin Kazybekov on 07.09.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = ColorProvider.secondary
        self.layer.cornerRadius = 4
        self.textLabel?.textColor = ColorProvider.text
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
