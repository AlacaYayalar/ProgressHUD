

import UIKit

final class WifiLevelTwoTwo: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = WifiLevelTwoTwo
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: CustProgeressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var continueButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 15
    }
    
    func setup(with model: ScreenSecondLevel) {
        titleLabel.text = model.title
        infoLabel.text = model.description
        nextButton.setTitle(model.scr_btn, for: .normal)
        progressLabel.text = model.scn_items.first
        
        guard let url = URL(string: model.scr_img) else { return }
        
        imageView.kf.setImage(with: url, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        continueButtonTapped?()
    }
}

final class CustProgeressView: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}
