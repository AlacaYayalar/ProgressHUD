import UIKit
import ScreenShield

public final class Fl3FourthAnimationVC: UIViewController {

    // MARK: - UI Elements
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let shieldIconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private var option1View = Fl3FourthAnimationHelpView(title: "", description: "", premium: nil)
    private var option2View = Fl3FourthAnimationHelpView(title: "", description: "", premium: nil)
    
    private var purchaseOptions: [Fl3FourthAnimationHelpView] = []

    private lazy var optionsStackView: UIStackView = {
//        purchaseOptions = [option1View, option2View]
        let stackView = UIStackView(arrangedSubviews: purchaseOptions)
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private let infoTextLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.label
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
        button.addTarget(self, action: #selector(secureMyAccountTapped), for: .touchUpInside)
        
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var selectedOption: Fl3FourthAnimationHelpView?
    
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
        navigationItem.hidesBackButton = true

        setupInfo()
        setupUI()
        setupConstraints()
        
        if let firstOption = purchaseOptions.first {
            selectOption(firstOption)
        }
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.pageTitleLabel)
            ScreenShield.shared.protect(view: self.subtitleLabel)
            ScreenShield.shared.protect(view: self.shieldIconImageView)
            ScreenShield.shared.protect(view: self.option1View)
            ScreenShield.shared.protect(view: self.option2View)
            ScreenShield.shared.protect(view: self.optionsStackView)
            ScreenShield.shared.protect(view: self.infoTextLabel)
            ScreenShield.shared.protect(view: self.secureMyAccountButton)
            ScreenShield.shared.protect(view: self.cancelButton)
            ScreenShield.shared.protectFromScreenRecording()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let firstOption = purchaseOptions.first {
            selectOption(firstOption)
        }
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI Setup
    private func setupInfo() {
        pageTitleLabel.text = model?.flow3?.fl3_purch_tl
        subtitleLabel.text = model?.flow3?.fl3_purch_subt
        
        secureMyAccountButton.setTitle(model?.flow3?.fl3_purch_btn1, for: .normal)
        cancelButton.setTitle(model?.flow3?.fl3_purch_btn2, for: .normal)
        
        infoTextLabel.text = model?.flow3?.fl3_purch_text
        
        
        option1View = Fl3FourthAnimationHelpView(title: model?.flow3?.fl3_purch_box1_tl ?? "",
                                                 description: model?.flow3?.fl3_purch_box1_subt ?? "",
                                                 isSelected: true,
                                                 model,
                                                 premium: premiums.first(where: { $0.description?.lowercased().contains("year") == true }))
        
        option1View.translatesAutoresizingMaskIntoConstraints = false
        
        option1View.onTap = { [weak self] in
            guard let self else { return }
            self.selectOption(self.option1View)
        }
        
        option2View = Fl3FourthAnimationHelpView(title: model?.flow3?.fl3_purch_box2_tl ?? "",
                                                 description: model?.flow3?.fl3_purch_box2_subt ?? "",
                                                 model,
                                                 premium: premiums.first(where: { $0.description?.lowercased().contains("week") == true }))
        
        option2View.translatesAutoresizingMaskIntoConstraints = false
        
        option2View.onTap = { [weak self] in
            guard let self else { return }
            self.selectOption(self.option2View)
        }
        
        guard let iconURL = URL(string: model?.flow3?.fl3_top_img ?? "") else { return }
        
        shieldIconImageView.kf.setImage(with: iconURL, placeholder: UIImage())
    }
    
    private func setupUI() {
        infoTextLabel.font = .systemFont(ofSize: Constants.se3Screen ? 13 : 15, weight: .medium)
        
        optionsStackView.addArrangedSubview(option1View)
        optionsStackView.addArrangedSubview(option2View)
        purchaseOptions = [option1View, option2View]
        
        view.addSubview(pageTitleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(shieldIconImageView)
        view.addSubview(optionsStackView)
        view.addSubview(infoTextLabel)
        view.addSubview(secureMyAccountButton)
        view.addSubview(cancelButton)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        let horizontalPadding: CGFloat = 20
        let shieldSize: CGFloat = 50

        NSLayoutConstraint.activate([
            shieldIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            shieldIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            shieldIconImageView.widthAnchor.constraint(equalToConstant: shieldSize),
            shieldIconImageView.heightAnchor.constraint(equalToConstant: shieldSize + 10),

            pageTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            pageTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: shieldIconImageView.leadingAnchor, constant: -10),

            subtitleLabel.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: pageTitleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            optionsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            infoTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding + 10),
            infoTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(horizontalPadding + 10)),
            infoTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: secureMyAccountButton.topAnchor, constant: -20),
            
            secureMyAccountButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -12),
            secureMyAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            secureMyAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            secureMyAccountButton.heightAnchor.constraint(equalToConstant: 60),

            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    // MARK: - Actions
    private func selectOption(_ tappedOption: Fl3FourthAnimationHelpView) {
        purchaseOptions.forEach { optionView in
            optionView.isOptionSelected = (optionView == tappedOption)
        }
        selectedOption = tappedOption
    }

    @objc private func secureMyAccountTapped() {
        guard let selected = selectedOption else {
            print("No option selected")
            return
        }
//        
//        let successVC = Fl3FifthAnimationVC(model, delegate: self.delegate, rScreen: self.rScreen)
//
//        navigationController?.pushViewController(successVC, animated: true)
        
        self.delegate?.buttonTapped(isResult: false, fl1IsSecond: nil, premium: selected.premium)
    }

    @objc private func cancelTapped() {
        print("Cancel Tapped")
        navigationController?.popViewController(animated: true)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            cancelButton.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    public func goToNext(isPaid: Bool) {
        if isPaid {
            let successVC = Fl3FifthAnimationVC(model, delegate: self.delegate, rScreen: self.rScreen)

            navigationController?.pushViewController(successVC, animated: true)
        } else {            
            if self.rScreen == 2 {
                let vc = ReslutAnimationViewContoller(self.model, isPaid: isPaid, delegate: self.delegate)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = FlRFirstAnimationVC(self.model, delegate: self.delegate, isPaid: isPaid)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
