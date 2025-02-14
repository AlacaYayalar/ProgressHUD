

import UIKit

final class WifiLevelOneTwoViewController: UIViewController {
    private let wifiLevelOne = WifiLevelOneTwo.instanceFromNib()
    
    public var model: LevelOne?
    weak var delegate: SpecialAnimationDelegate?
    
    init(_ model: LevelOne? = nil, delegate: SpecialAnimationDelegate?) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = wifiLevelOne
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model else { return }
        
        wifiLevelOne.setup(with: model.scr_second)
    }
}
