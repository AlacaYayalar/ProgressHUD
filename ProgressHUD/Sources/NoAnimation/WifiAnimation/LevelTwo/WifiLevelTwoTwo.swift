

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
    @IBOutlet weak var imagetopCons: NSLayoutConstraint!
    
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    var continueButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 15
        nextButton.layer.cornerRadius = 15
        
        if isVerySmallDevice {
            imagetopCons.constant = 20
            titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
            infoLabel.font = .systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    func setup(with model: ScreenSecondLevel) {
        titleLabel.text = model.title
        infoLabel.text = model.description
        nextButton.setTitle(model.scr_btn, for: .normal)
        progressLabel.text = model.scn_items.first
        
        guard let url = URL(string: model.scr_img) else { return }
        
        imageView.kf.setImage(with: url, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.progressLabel.text = model.scn_items[1]
            self?.progressView.progress = 0.44
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.progressLabel.text = model.scn_items.last
            self?.progressView.progress = 0.7
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) { [weak self] in
            self?.progressView.progress = 1
        }
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
