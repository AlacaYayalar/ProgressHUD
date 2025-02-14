
import UIKit

final class WifiLevelOneViewController: UIViewController {
    private let wifiLevelOne = WifiLevelOne.instanceFromNib()
    
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
        
        wifiLevelOne.setup(with: model.scr_first)
        
        wifiLevelOne.continueButtonTapped = { [weak self] in
            let vc = WifiLevelOneTwoViewController(model, delegate: self?.delegate)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
