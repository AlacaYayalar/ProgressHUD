import Foundation
import UIKit
import SnapKit
import Kingfisher


final class CustomStatsButton: UIView {
    private let icon = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    private let chevroneIcon = UIImageView()
    
    private var model: AuthorizationOfferModel?
    private var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
//        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        backgroundColor = UIColor(resource: .localRContainer)
        layer.cornerRadius = 15
        clipsToBounds = true
        
        icon.contentMode = .scaleAspectFit
        chevroneIcon.contentMode = .scaleAspectFit
        chevroneIcon.tintColor = UIColor.label
        
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
//        titleLabel.textColor = .black
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .left
        subtitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
//        subtitleLabel.textColor = UIColor(red: 103/255, green: 103/255, blue: 103/255, alpha: 1)
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.textAlignment = .left
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        subtitleLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        
        addSubview(icon)
        addSubview(chevroneIcon)
        addSubview(stackView)
        
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        chevroneIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.trailing.equalTo(chevroneIcon.snp.leading).offset(-10)
        }
    }
    
    func setup(with model: AuthorizationOfferModel?, action: (() -> Void)? = nil) {
        guard let model = model else { return }
        self.model = model
        self.action = action
        
        guard let mainIcon = URL(string: model.scn?.stats?.statImg ?? ""),
              let smallIcon = URL(string: model.scn?.stats?.statBtnArrowImg ?? "")
        else { return }
        
        icon.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        chevroneIcon.kf.setImage(with: smallIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        titleLabel.text = model.scn?.stats?.statBtnTitle
        subtitleLabel.text = model.scn?.stats?.statBtnSubtitle
        
        if Locale.preferredLanguages.first?.hasPrefix("ar") == true {
            icon.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        action?()
    }
}

