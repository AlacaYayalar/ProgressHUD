

import UIKit
import Lottie

final class WifiLevelOne: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = WifiLevelOne
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var animationButton: UIButton!
    @IBOutlet weak var animationTopCons: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomCons: NSLayoutConstraint!
    
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    var continueButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 20
        animationButton.layer.cornerRadius = 15
        
        if isVerySmallDevice {
            animationTopCons.constant = 50
            buttonBottomCons.constant = 20
            titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
            subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
            infoLabel.font = .systemFont(ofSize: 12, weight: .medium)
        }
    }
    
    func setup(with model: ScreenFirst) {
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        infoLabel.text = model.item
        animationButton.setTitle(model.scr_btn, for: .normal)
        
        guard let url = URL(string: model.anim_lot),
              let mainIcon = URL(string: model.item_icon) else { return }
        
        animationView.isHidden = false
        LottieAnimation.loadedFrom(url: url, closure: { [weak self] animation in
            self?.animationView.animation = animation
            self?.animationView.loopMode = .loop
            self?.animationView.play()
        }, animationCache: DefaultAnimationCache.sharedCache)
        
        iconImageView.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        continueButtonTapped?()
    }
}
