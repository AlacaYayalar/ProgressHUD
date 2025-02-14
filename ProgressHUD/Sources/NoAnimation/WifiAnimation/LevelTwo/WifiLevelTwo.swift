

import UIKit

final class WifiLevelTwo: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = WifiLevelTwo
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
    }
}
