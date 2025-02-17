

import UIKit

final class WifiLevelOneThree: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = WifiLevelOneThree
    @IBOutlet weak var mainIcon: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainSub: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contIcon: UIImageView!
    @IBOutlet weak var contTitle: UILabel!
    @IBOutlet weak var contSub: UILabel!
    @IBOutlet var contImage: [UIImageView]!
    @IBOutlet var contLabel: [UILabel]!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var iconTopCons: NSLayoutConstraint!
    
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    var continueButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 15
        nextButton.layer.cornerRadius = 15
        
        if isVerySmallDevice {
            iconTopCons.constant = 20
            mainTitle.font = .systemFont(ofSize: 16, weight: .bold)
            mainSub.font = .systemFont(ofSize: 10, weight: .regular)
            contTitle.font = .systemFont(ofSize: 14, weight: .bold)
            contSub.font = .systemFont(ofSize: 10, weight: .regular)
            contLabel.forEach { label in
                label.font = .systemFont(ofSize: 10, weight: .medium)
            }
        }
    }
    
    func setup(with model: ScreenThird) {
        mainTitle.text = model.title
        mainSub.text = model.description
        contTitle.text = model.cart.title
        contSub.text = model.cart.subtitle
        nextButton.setTitle(model.cart.btn, for: .normal)
        
        model.cart.items.enumerated().forEach { index, item in
            guard let url = URL(string: item.icon) else { return }
            
            contImage[index].kf.setImage(with: url, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            contLabel[index].text = item.text
        }
        
        guard let url = URL(string: model.cart.title_icon),
              let mainIconUrl = URL(string: model.title_icon) else { return }
        
        mainIcon.kf.setImage(with: mainIconUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        contIcon.kf.setImage(with: url, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        continueButtonTapped?()
    }
}
