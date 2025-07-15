import UIKit
import ScreenShield

public final class Fl1FifthAnimationVC: UIViewController {

    // MARK: - UI Elements

    private let backgroundGlowImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let checkmarkIconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let secureStatusLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 48 : (Constants.se3Screen ? (Constants.se1Screen ? 24 : 28) : 30), weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let resultsContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(resource: .localContainer)
        view.layer.cornerRadius = 16
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
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 28 : (Constants.se3Screen ? (Constants.se1Screen ? 16 : 18) : 18), weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let resultsDetailLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: Constants.isIpad ? 26 : (Constants.se3Screen ? (Constants.se1Screen ? 14 : 15) : 15), weight: .medium)
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

    private lazy var startNewScanButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: Constants.isIpad ? 24 : (Constants.se3Screen ? (Constants.se1Screen ? 16 : 16) : 17), weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startNewScanTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let isFromFirst: Bool
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    public var rScreen: Int

    // MARK: - Lifecycle
    
    init(_ model: AuthorizationOfferModel? = nil, isFromFirst: Bool, delegate: SpecialAnimationDelegate?, rScreen: Int) {
        self.model = model
        self.isFromFirst = isFromFirst
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

        setupUI()
        setupConstraints()
        setupInfo()
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.backgroundGlowImageView)
            ScreenShield.shared.protect(view: self.checkmarkIconImageView)
            ScreenShield.shared.protect(view: self.secureStatusLabel)
            ScreenShield.shared.protect(view: self.resultsContainerView)
            ScreenShield.shared.protect(view: self.resultsTitleLabel)
            ScreenShield.shared.protect(view: self.resultsDetailLabel)
            ScreenShield.shared.protect(view: self.startNewScanButton)
            ScreenShield.shared.protectFromScreenRecording()
        }
    }

    // MARK: - UI Setup
    private func setupInfo() {
        resultsDetailLabel.text = isFromFirst ? (model?.flow1?.scr4_subt_low) : (model?.flow2?.fl2_result_subt)
        resultsTitleLabel.text = model?.flow1?.scr4_tl_low
        secureStatusLabel.text = isFromFirst ? (model?.flow1?.scr4_tl) : (model?.flow2?.fl2_result_tl)
        startNewScanButton.setTitle(model?.flow2?.fl2_result_ok, for: .normal)
        
        guard let icon1URL = URL(string: Constants.isDarkMode ? (model?.flow1?.scr4_blurD ?? "") : (model?.flow1?.scr4_blur ?? "")) else { return }
        
        backgroundGlowImageView.kf.setImage(with: icon1URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        guard let icon2URL = URL(string: isFromFirst ? (model?.flow1?.scr4_img ?? "") : (model?.flow2?.fl2_result_img ?? "")) else { return }
        

        if isFromFirst {
            checkmarkIconImageView.kf.setImage(with: icon2URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        } else {
            checkmarkIconImageView.kf.setImage(with: icon2URL, placeholder: UIImage())
        }
        
    }

    private func setupUI() {
        view.addSubview(backgroundGlowImageView)
        view.addSubview(checkmarkIconImageView)
        view.addSubview(secureStatusLabel)

        resultsContainerView.addSubview(resultsTitleLabel)
        resultsContainerView.addSubview(resultsDetailLabel)
        resultsContainerView.addSubview(seperatorView)
        resultsContainerView.addSubview(startNewScanButton)
        view.addSubview(resultsContainerView)
        
        guard !isFromFirst && Constants.se1Screen else { return }
        resultsDetailLabel.font = .systemFont(ofSize: 13, weight: .medium)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        let iconSize: CGFloat = Constants.isIpad ? view.bounds.width * 0.35 : 180
        let horizontalPadding: CGFloat = Constants.isIpad ? 80 : 20
        let verticalPaddingFromTop: CGFloat = view.bounds.height * 0.15
        
        if isFromFirst {
            NSLayoutConstraint.activate([
                // Background Glow ImageView
                backgroundGlowImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.isIpad ? 80 : (Constants.se3Screen ? (Constants.se1Screen ? -140 : -90) : (Constants.maxScreen ? 40 : -5))),
                backgroundGlowImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundGlowImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundGlowImageView.heightAnchor.constraint(equalToConstant: 500),
            ])
        } else {
            NSLayoutConstraint.activate([
                // Background Glow ImageView
                backgroundGlowImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.isIpad ? 80 : (Constants.se3Screen ? (Constants.se1Screen ? -140 : -90) : (Constants.maxScreen ? 40 : -30))),
                backgroundGlowImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundGlowImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundGlowImageView.heightAnchor.constraint(equalToConstant: 500),
            ])
        }

        NSLayoutConstraint.activate([
            // Checkmark Icon ImageView
            checkmarkIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkmarkIconImageView.widthAnchor.constraint(equalToConstant: Constants.se3Screen ? (Constants.se1Screen ? iconSize * 0.75 : iconSize) : iconSize),
            checkmarkIconImageView.heightAnchor.constraint(equalToConstant: Constants.se3Screen ? (Constants.se1Screen ? iconSize * 0.75 : iconSize) : iconSize),
            checkmarkIconImageView.centerYAnchor.constraint(equalTo: backgroundGlowImageView.centerYAnchor),

            // Secure Status Label (Below checkmark icon)
            secureStatusLabel.topAnchor.constraint(equalTo: checkmarkIconImageView.bottomAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? 10 : 15) : (Constants.maxScreen ? 20 : 20)),
            secureStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secureStatusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: horizontalPadding),
            secureStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -horizontalPadding),

            // Results Container View (Below status label, but with space, closer to bottom)
            resultsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            resultsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            resultsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.isIpad ? -50 : (Constants.se3Screen ? (Constants.se1Screen ? -15 : -20) : (Constants.maxScreen ? -30 : -25))),

            // Results Title Label
            resultsTitleLabel.topAnchor.constraint(equalTo: resultsContainerView.topAnchor, constant: 20),
            resultsTitleLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 15),
            resultsTitleLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -15),

            // Results Detail Label
            resultsDetailLabel.topAnchor.constraint(equalTo: resultsTitleLabel.bottomAnchor, constant: 10),
            resultsDetailLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 15),
            resultsDetailLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -15),

            seperatorView.topAnchor.constraint(equalTo: resultsDetailLabel.bottomAnchor, constant: 15),
            seperatorView.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            
            // Start New Scan Button
            startNewScanButton.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 15),
            startNewScanButton.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 15),
            startNewScanButton.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -15),
            startNewScanButton.bottomAnchor.constraint(equalTo: resultsContainerView.bottomAnchor, constant: -15),
            startNewScanButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    // MARK: - Actions

    @objc private func startNewScanTapped() {
        goToResult(isPaid: true)
    }
    
    private func goToResult(isPaid: Bool) {
        DispatchQueue.main.async {
            if self.rScreen == 2 {
                let vc = ReslutAnimationViewContoller(self.model, isPaid: isPaid, delegate: self.delegate)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ProtectionDashboardViewController(self.model, delegate: self.delegate, isPaid: isPaid)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

