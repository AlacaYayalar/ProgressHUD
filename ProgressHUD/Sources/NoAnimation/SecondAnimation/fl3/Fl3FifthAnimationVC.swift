import UIKit
import ScreenShield

public final class Fl3FifthAnimationVC: UIViewController {

    // MARK: - UI Elements
    
    private let backgroundGlowImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let protectedGraphicImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let resultsContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(resource: .localContainer)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.shadowColor = UIColor(resource: .localContainerShadow).cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.clipsToBounds = false
        
        return view
    }()

    private let resultsTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let resultsDetailLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    public var rScreen: Int

    // MARK: - Lifecycle
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate?, rScreen: Int) {
        self.model = model
        self.delegate = delegate
        self.rScreen = rScreen
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(resource: .localBG)
        navigationItem.hidesBackButton = true

        setupUI()
        setupConstraints()
        setupInfo()
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.backgroundGlowImageView)
            ScreenShield.shared.protect(view: self.protectedGraphicImageView)
            ScreenShield.shared.protect(view: self.statusLabel)
            ScreenShield.shared.protect(view: self.resultsContainerView)
            ScreenShield.shared.protect(view: self.resultsTitleLabel)
            ScreenShield.shared.protect(view: self.resultsDetailLabel)
            ScreenShield.shared.protect(view: self.okButton)
            ScreenShield.shared.protectFromScreenRecording()
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI Setup
    private func setupInfo() {
        statusLabel.text = model?.flow3?.fl3_result_tl
        resultsTitleLabel.text = model?.flow3?.fl3_result_tl2
        resultsDetailLabel.text = model?.flow3?.fl3_result_subt
        okButton.setTitle(model?.flow3?.fl3_result_ok ?? "", for: .normal)
        
//        guard let icon1URL = URL(string: Constants.isDarkMode ? (model?.flow1?.scr2_blurD ?? "") : (model?.flow1?.scr2_blur ?? "")) else { return }
        guard let icon1URL = URL(string: Constants.isDarkMode ? (model?.flow1?.scr4_blurD ?? "") : (model?.flow1?.scr4_blur ?? "")) else { return }
        
        backgroundGlowImageView.kf.setImage(with: icon1URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
//        guard let iconURL = URL(string: Constants.isDarkMode ? (model?.flow3?.fl3_result_img_d ?? ""): (model?.flow3?.fl3_result_img ?? "")) else { return }
        guard let iconURL = URL(string: model?.flow3?.fl3_result_img ?? "") else { return }
        
//        protectedGraphicImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        protectedGraphicImageView.kf.setImage(with: iconURL, placeholder: UIImage())
    }

    private func setupUI() {
        view.addSubview(backgroundGlowImageView)
        view.addSubview(protectedGraphicImageView)
        view.addSubview(statusLabel)

        resultsContainerView.addSubview(resultsTitleLabel)
        resultsContainerView.addSubview(resultsDetailLabel)
        resultsContainerView.addSubview(seperatorView)
        resultsContainerView.addSubview(okButton)
        view.addSubview(resultsContainerView)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        let horizontalPadding: CGFloat = 25
        let statusLabelCenterYOffset: CGFloat = Constants.se3Screen ? (-view.bounds.height * 0.018) : (view.bounds.height * 0.05)

        NSLayoutConstraint.activate([
            protectedGraphicImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            protectedGraphicImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            protectedGraphicImageView.heightAnchor.constraint(equalToConstant: 179),
            protectedGraphicImageView.widthAnchor.constraint(equalToConstant: 179),
            
            backgroundGlowImageView.centerYAnchor.constraint(equalTo: protectedGraphicImageView.centerYAnchor, constant: 0),
            backgroundGlowImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundGlowImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundGlowImageView.heightAnchor.constraint(equalToConstant: 500),

            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: statusLabelCenterYOffset),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: horizontalPadding + 20),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -(horizontalPadding + 20)),

            resultsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            resultsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            resultsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            resultsTitleLabel.topAnchor.constraint(equalTo: resultsContainerView.topAnchor, constant: 20),
            resultsTitleLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 15),
            resultsTitleLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -15),

            resultsDetailLabel.topAnchor.constraint(equalTo: resultsTitleLabel.bottomAnchor, constant: 10),
            resultsDetailLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 15),
            resultsDetailLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -15),

            seperatorView.topAnchor.constraint(equalTo: resultsDetailLabel.bottomAnchor, constant: 15),
            seperatorView.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            
            okButton.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 15),
            okButton.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 15),
            okButton.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -15),
            okButton.bottomAnchor.constraint(equalTo: resultsContainerView.bottomAnchor, constant: -15),
            okButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    // MARK: - Actions

    @objc private func okButtonTapped() {
//        var presentingVC = self.navigationController?.presentingViewController
//
//        while presentingVC?.presentingViewController != nil {
//            presentingVC = presentingVC?.presentingViewController
//        }
//
//        if let rootModalPresenter = presentingVC {
//            rootModalPresenter.dismiss(animated: true, completion: nil)
//        } else if let navController = self.navigationController {
//            if navController.viewControllers.count > 1 {
//                navController.popToRootViewController(animated: true)
//            } else {
//                 self.navigationController?.dismiss(animated: true, completion: nil)
//            }
//        } else {
//            self.dismiss(animated: true, completion: nil)
//        }
        
//        let vc = ProtectionDashboardViewController(model, delegate: self.delegate, rScreen: self.rScreen)
//        
//        self.navigationController?.pushViewController(vc, animated: true)
        
        goToResult(isPaid: true)
    }
    
    private func goToResult(isPaid: Bool) {
        DispatchQueue.main.async {
            if self.rScreen == 2 {
                let vc = ReslutAnimationViewContoller(self.model, isPaid: isPaid, delegate: self.delegate)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = FlRFirstAnimationVC(self.model, delegate: self.delegate, isPaid: isPaid)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            resultsContainerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
}
