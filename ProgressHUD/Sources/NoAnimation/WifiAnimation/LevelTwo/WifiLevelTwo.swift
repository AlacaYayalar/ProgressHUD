

import UIKit

final class WifiLevelTwo: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = WifiLevelTwo
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageTopConst: NSLayoutConstraint!
    
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    var continueButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 15
        nextButton.layer.cornerRadius = 15
        
        if isVerySmallDevice {
            imageTopConst.constant = 50
            titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
            subtitleLabel.font = .systemFont(ofSize: 10, weight: .regular)
        }
    }
    
    func setup(with model: ScreenFirstLevel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        nextButton.setTitle(model.scr_btn, for: .normal)
        
        guard let url = URL(string: model.scr_img) else { return }
        
        imageView.kf.setImage(with: url, placeholder: UIImage())
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        continueButtonTapped?()
    }
}
