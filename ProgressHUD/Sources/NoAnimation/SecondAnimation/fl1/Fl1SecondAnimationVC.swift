import UIKit

public final class Fl1SecondAnimationVC: UIViewController {
    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 48 : 30, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let iconContainerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let glowImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private let badgeView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "11"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let resultsContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(resource: .localContainer)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let resultsTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 30 : (Constants.se3Screen ? (Constants.se1Screen ? 16 : 16) : 18), weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let suspiciousLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 28 : (Constants.se3Screen ? (Constants.se1Screen ? 16 : 16) : 18), weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let threatsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 26 : (Constants.se3Screen ? (Constants.se1Screen ? 14 : 14) : 15), weight: .medium)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private lazy var activateButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: Constants.isIpad ? 24 : (Constants.se3Screen ? (Constants.se1Screen ? 16 : 16) : 18), weight: .medium)
        button.backgroundColor = UIColor(resource: .localBlueButton)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(activateButtonTapped), for: .touchUpInside)
        
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

        setupUI()
        setupConstraints()
        setupInfo()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupInfo() {
        titleLabel.text = model?.flow1?.loading_tl
        resultsTitleLabel.text = model?.flow1?.scr1_tl_low
        suspiciousLabel.text = model?.flow1?.scr1_subt_low
        threatsLabel.text = model?.flow1?.scr1_text_low
        activateButton.setTitle(model?.flow1?.scr2_btn_tl, for: .normal)
        
        guard let glowURL = URL(string: Constants.isDarkMode ? (model?.flow1?.scr1_blurD ?? "") : (model?.flow1?.scr1_blur ?? "")) else { return }
        
//        glowImageView.kf.setImage(with: glowURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        glowImageView.kf.setImage(with: glowURL, placeholder: UIImage(), options: [.processor(PDFProcessor()), .cacheOriginalImage])
        
        guard let iconURL = URL(string: model?.flow1?.scr1_img ?? "") else { return }
        
//        appIconImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        appIconImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(PDFProcessor()), .cacheOriginalImage])
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(titleLabel)
        
        iconContainerView.addSubview(glowImageView)
        iconContainerView.addSubview(appIconImageView)
        iconContainerView.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        
        view.addSubview(iconContainerView)

        resultsContainerView.addSubview(resultsTitleLabel)
        resultsContainerView.addSubview(suspiciousLabel)
        resultsContainerView.addSubview(threatsLabel)
        view.addSubview(resultsContainerView)

        view.addSubview(activateButton)
        view.bringSubviewToFront(titleLabel)
    }
    
    // MARK: - Constraints

    private func setupConstraints() {
        let iconSize: CGFloat = 170
        let badgeSize: CGFloat = 44
        let glowSizeMultiplier: CGFloat = 1.8

        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? 15 : 20) : (Constants.maxScreen ? 40 : 40)),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Icon Container View
            iconContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? -5 : 35) : (Constants.maxScreen ? 60 : 60)),
            iconContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // The container's size will be determined by the glow image view's size
            iconContainerView.widthAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.65 : (iconSize * glowSizeMultiplier)),
            iconContainerView.heightAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.65 : (iconSize * glowSizeMultiplier)),

            // Glow Image View (fills iconContainerView, or adjust as needed)
            glowImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            glowImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            glowImageView.widthAnchor.constraint(equalTo: iconContainerView.widthAnchor),
            glowImageView.heightAnchor.constraint(equalTo: iconContainerView.heightAnchor),

            // App Icon Image View (centered in iconContainerView)
            appIconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            appIconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            appIconImageView.widthAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.35 : iconSize),
            appIconImageView.heightAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.35 : iconSize),

            // Badge View (top-right of appIconImageView)
            badgeView.topAnchor.constraint(equalTo: appIconImageView.topAnchor, constant: -badgeSize / 3),
            badgeView.trailingAnchor.constraint(equalTo: appIconImageView.trailingAnchor, constant: badgeSize / 3),
            badgeView.widthAnchor.constraint(equalToConstant: badgeSize),
            badgeView.heightAnchor.constraint(equalToConstant: badgeSize),

            // Badge Label (centered in badgeView)
            badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),

            // Results Container View
            resultsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.isIpad ? 80 : 20),
            resultsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.isIpad ? -80 : -20),

            // Results Title Label
            resultsTitleLabel.topAnchor.constraint(equalTo: resultsContainerView.topAnchor, constant: 16),
            resultsTitleLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? 8 : 16) : 16),
            resultsTitleLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? -8 : -16) : -16),

            // Suspicious Label
            suspiciousLabel.topAnchor.constraint(equalTo: resultsTitleLabel.bottomAnchor, constant: 8),
            suspiciousLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? 8 : 16) : 16),
            suspiciousLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? -8 : -16) : -16),

            // Threats Label
            threatsLabel.topAnchor.constraint(equalTo: suspiciousLabel.bottomAnchor, constant: 4),
            threatsLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? 8 : 16) : 16),
            threatsLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? -8 : -16) : -16),
            threatsLabel.bottomAnchor.constraint(equalTo: resultsContainerView.bottomAnchor, constant: -16),

            // Activate Button
            activateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.isIpad ? 80 : 20),
            activateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.isIpad ? -80 : -20),
            activateButton.topAnchor.constraint(equalTo: resultsContainerView.bottomAnchor, constant: Constants.isIpad ? 30 : 10),
            activateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.isIpad ? -80 : (Constants.se3Screen ? (Constants.se1Screen ? -15 : -15) : (Constants.maxScreen ? -40 : -30))),
            activateButton.heightAnchor.constraint(equalToConstant: Constants.se3Screen ? (Constants.se1Screen ? 50 : 55) : 63)
        ])
    }

    // MARK: - Actions

    @objc private func activateButtonTapped() {
        let purchaseSucceeded = Bool.random()

        if purchaseSucceeded {
            let successVC = Fl1FourthAnimationVC(model, isFromFirst: true, delegate: self.delegate, rScreen: rScreen)

            navigationController?.pushViewController(successVC, animated: true)
        } else {
            let highRiskVC = Fl1ThirdAnimationVC(model, delegate: self.delegate, rScreen: self.rScreen)

            navigationController?.pushViewController(highRiskVC, animated: true)
        }
    }
}

