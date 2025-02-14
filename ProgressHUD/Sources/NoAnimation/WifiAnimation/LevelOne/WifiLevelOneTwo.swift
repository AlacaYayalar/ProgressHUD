

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
            guard let self else { return }
            
            self.animationView.animation = animation
            self.animationView.loopMode = .loop
            self.animationView.play()
            self.bringSubviewToFront(self.titleLabel)
        }, animationCache: DefaultAnimationCache.sharedCache)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.titleLabel.text = model.titles.last
        }
    }
}
