

import UIKit
import Lottie

final class WifiLevelOneTwo: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = WifiLevelOneTwo
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setup(with model: ScreenSecond) {
        titleLabel.text = model.titles.first
        
        guard let url = URL(string: model.anim_lot) else { return }
        
        animationView.isHidden = false
        LottieAnimation.loadedFrom(url: url, closure: { [weak self] animation in
            self?.animationView.animation = animation
            self?.animationView.play()
        }, animationCache: DefaultAnimationCache.sharedCache)
    }
}
