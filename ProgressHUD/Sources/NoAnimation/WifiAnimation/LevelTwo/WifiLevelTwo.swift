

import UIKit

final class WifiLevelTwo: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = WifiLevelTwo
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var continueButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 15
        nextButton.layer.cornerRadius = 15
    }
    
    func setup(with model: ScreenFirstLevel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        nextButton.setTitle(model.scr_btn, for: .normal)
        
        guard let url = URL(string: model.scr_img) else { return }
        
        imageView.kf.setImage(with: url, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        continueButtonTapped?()
    }
}
