

import UIKit

final class WifiLevelTwoTwoViewController: UIViewController {
    private let wifiLevelOne = WifiLevelTwoTwo.instanceFromNib()
    
    public var model: LevelTwo?
    weak var delegate: SpecialAnimationDelegate?
    
    init(_ model: LevelTwo? = nil, delegate: SpecialAnimationDelegate?) {
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
        
        navigationController?.isNavigationBarHidden = true
        wifiLevelOne.setup(with: model.scr_second)
        
        wifiLevelOne.continueButtonTapped = { [weak self] in
            self?.delegate?.buttonTapped(isResult: false)
        }
    }
}
