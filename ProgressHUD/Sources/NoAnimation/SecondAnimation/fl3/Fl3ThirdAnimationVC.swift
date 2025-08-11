import UIKit
import ScreenShield

public final class Fl3ThirdAnimationVC: UIViewController {
    
    // MARK: - UI Elements
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let topInfoContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(resource: .localContainer)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        
        return view
    }()

    private let smallWarningIconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let deviceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.black
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1)
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1)
        label.numberOfLines = 0
        return label
    }()

    private lazy var deviceInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deviceLabel, timeLabel, locationLabel])
        
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private let bottomInfoContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(resource: .localContainer)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false // Important
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        
        return view
    }()

    private let maliciousProgramLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private lazy var secureMyAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor(resource: .localBlueButton)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(secureMyAccountButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    public var rScreen: Int
    public var premiums: [SubscriptionModel] = []
    
    // MARK: - Lifecycle
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate?, rScreen: Int, premiums: [SubscriptionModel]) {
        self.model = model
        self.delegate = delegate
        self.rScreen = rScreen
        self.premiums = premiums
        
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
        
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor(resource: .navItemColorCust)
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.pageTitleLabel)
            ScreenShield.shared.protect(view: self.topInfoContainerView)
            ScreenShield.shared.protect(view: self.smallWarningIconImageView)
            ScreenShield.shared.protect(view: self.deviceLabel)
            ScreenShield.shared.protect(view: self.timeLabel)
            ScreenShield.shared.protect(view: self.locationLabel)
            ScreenShield.shared.protect(view: self.deviceInfoStackView)
            ScreenShield.shared.protect(view: self.bottomInfoContainerView)
            ScreenShield.shared.protect(view: self.maliciousProgramLabel)
            ScreenShield.shared.protect(view: self.secureMyAccountButton)
            ScreenShield.shared.protectFromScreenRecording()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UI Setup
    private func setupInfo() {
        pageTitleLabel.text = model?.flow3?.fl3_sc2_tl
        secureMyAccountButton.setTitle(model?.flow3?.fl3_sc2_btn ?? "", for: .normal)
        maliciousProgramLabel.text = model?.flow3?.fl3_sc2_low_text
        deviceLabel.text = model?.flow3?.fl3_sc2_det_text1
        timeLabel.text = model?.flow3?.fl3_sc2_det_text2
        locationLabel.text = model?.flow3?.fl3_sc2_det_text3
        
        guard let ico1URL = URL(string: model?.flow3?.fl3_sc2_det_img1 ?? "") else { return }
        
//        flagImageView.kf.setImage(with: ico1URL, placeholder: UIImage(), options: [.processor(PDFProcessor())])
        
//        guard let icon2URL = URL(string: model?.flow3?.fl3_sc2_det_img2 ?? "") else { return }
        
//        smallWarningIconImageView.kf.setImage(with: icon2URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        smallWarningIconImageView.kf.setImage(with: ico1URL, placeholder: UIImage())
    }

    private func setupUI() {
        view.addSubview(pageTitleLabel)
        
        // Top container elements
        topInfoContainerView.addSubview(smallWarningIconImageView)
        topInfoContainerView.addSubview(deviceInfoStackView)
        view.addSubview(topInfoContainerView)

        // Bottom container elements
        bottomInfoContainerView.addSubview(maliciousProgramLabel)
        view.addSubview(bottomInfoContainerView)

        // Button
        view.addSubview(secureMyAccountButton)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 20
        let flagHeight: CGFloat = 120

        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            pageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            topInfoContainerView.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: verticalPadding),
            topInfoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            topInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            smallWarningIconImageView.centerYAnchor.constraint(equalTo: topInfoContainerView.centerYAnchor, constant: 0),
            smallWarningIconImageView.leadingAnchor.constraint(equalTo: topInfoContainerView.leadingAnchor, constant: 16),
            smallWarningIconImageView.widthAnchor.constraint(equalToConstant: 69),
            smallWarningIconImageView.heightAnchor.constraint(equalToConstant: 49),
            
            deviceInfoStackView.leadingAnchor.constraint(equalTo: smallWarningIconImageView.trailingAnchor, constant: 20),
            deviceInfoStackView.trailingAnchor.constraint(equalTo: topInfoContainerView.trailingAnchor, constant: -10),
            deviceInfoStackView.topAnchor.constraint(equalTo: topInfoContainerView.topAnchor, constant: 15),
            deviceInfoStackView.bottomAnchor.constraint(lessThanOrEqualTo: topInfoContainerView.bottomAnchor, constant: -15),

            bottomInfoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            bottomInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            maliciousProgramLabel.topAnchor.constraint(equalTo: bottomInfoContainerView.topAnchor, constant: 16),
            maliciousProgramLabel.leadingAnchor.constraint(equalTo: bottomInfoContainerView.leadingAnchor, constant: 16),
            maliciousProgramLabel.trailingAnchor.constraint(equalTo: bottomInfoContainerView.trailingAnchor, constant: -16),
            maliciousProgramLabel.bottomAnchor.constraint(equalTo: bottomInfoContainerView.bottomAnchor, constant: -16),

            secureMyAccountButton.topAnchor.constraint(equalTo: bottomInfoContainerView.bottomAnchor, constant: verticalPadding),
            secureMyAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            secureMyAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            secureMyAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
            secureMyAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Actions

    @objc private func secureMyAccountButtonTapped() {
        let purchaseVC = Fl3FourthAnimationVC(model, delegate: self.delegate, rScreen: self.rScreen, premiums: premiums)
        
        navigationController?.pushViewController(purchaseVC, animated: true)
    }
}

