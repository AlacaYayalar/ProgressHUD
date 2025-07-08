import Foundation
import UIKit

final class BoxStatView: UIView {
    private let icon = UIImageView()
    private let titleLabel = UILabel()
    private let numberText = UILabel()
    private let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        clipsToBounds = true
        
        icon.contentMode = .scaleAspectFit
        
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
//        titleLabel.textColor = .black
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .left
        numberText.font = .systemFont(ofSize: 13, weight: .regular)
//        numberText.textColor = UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1)
        numberText.textColor = UIColor.secondaryLabel
        numberText.textAlignment = .right
        titleLabel.numberOfLines = 0
//        line.backgroundColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1)
        line.backgroundColor = UIColor.secondaryLabel
        
        addSubview(icon)
        addSubview(numberText)
        addSubview(titleLabel)
        addSubview(line)
        
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(28)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        numberText.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(icon.snp.trailing).offset(15)
            make.trailing.equalTo(numberText.snp.leading).offset(-5)
        }
        
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.trailing.equalToSuperview()
            make.leading.equalTo(icon.snp.trailing).offset(15)
        }
    }
    
    func setup(icon: URL, title: String, nubmerStr: String, withLine: Bool) {
        self.icon.kf.setImage(with: icon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        self.titleLabel.text = title
        self.numberText.text = nubmerStr
        
        if !withLine {
            line.backgroundColor = .clear
        }
    }
}


