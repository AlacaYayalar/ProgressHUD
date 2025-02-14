

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
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
        
    }
}
