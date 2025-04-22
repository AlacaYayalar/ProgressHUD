//
//  File.swift
//  ProgressHUD
//
//  Created by user1000 on 22/04/2025.
//

import Foundation
import UIKit

final class CardCell: UICollectionViewCell {
    private let screenSE1 = UIScreen.main.nativeBounds.height <= 1136
    private let screenSE3 = UIScreen.main.nativeBounds.height <= 1334
    
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private var textFontSize: CGFloat = 17
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSize()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSize() {
        if screenSE1 {
            textFontSize = 15
        } else if screenSE3 {
            textFontSize = 16
        } else {
            textFontSize = 17
        }
    }
    
    private func setupCell() {
        containerView.backgroundColor = UIColor(red: 255/255, green: 243/255, blue: 211/255, alpha: 1)
        containerView.layer.cornerRadius = 15
        contentView.addSubview(containerView)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemYellow
        containerView.addSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: textFontSize, weight: .medium)
        titleLabel.textColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(52)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with titleText: String, iconURL: String?) {
        titleLabel.text = titleText
        
        if let urlString = iconURL, let url = URL(string: urlString) {
            let processor = SVGImgProcessor()
            iconImageView.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .transition(.fade(0.2))
                ],
                completionHandler: { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        self.iconImageView.image = UIImage(systemName: "lightbulb.fill")
                    }
                }
            )
        } else {
            iconImageView.image = UIImage(systemName: "lightbulb.fill")
        }
    }
}

