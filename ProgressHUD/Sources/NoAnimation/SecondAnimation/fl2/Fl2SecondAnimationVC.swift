import UIKit

public final class Fl2SecondAnimationVC: UIViewController {

    // MARK: - UI Elements

    private let backgroundGlowImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let warningIconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 48 : (Constants.se3Screen ? (Constants.se1Screen ? 22 : 26) : 30), weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let infoContainerView: UIView = {
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

    private let primaryInfoLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 26 : (Constants.se3Screen ? (Constants.se1Screen ? 15 : 17) : 19), weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let secondaryInfoLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 24 : (Constants.se3Screen ? (Constants.se1Screen ? 14 : 14) : 15), weight: .medium)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private lazy var activateButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: Constants.isIpad ? 24 : (Constants.se3Screen ? (Constants.se1Screen ? 16 : 18) : 18), weight: .medium)
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

    // MARK: - UI Setup
    
    private func setupInfo() {
        titleLabel.text = model?.flow2?.det_tl
        activateButton.setTitle(model?.flow2?.det_btn_tl, for: .normal)
        primaryInfoLabel.text = model?.flow2?.det_tl_low
        secondaryInfoLabel.text = model?.flow2?.det_subt_low
        
        guard let icon1URL = URL(string: Constants.isDarkMode ? (model?.flow1?.scr2_blurD ?? "") : (model?.flow1?.scr2_blur ?? "")) else { return }
        
//        backgroundGlowImageView.kf.setImage(with: icon1URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        backgroundGlowImageView.kf.setImage(with: icon1URL, placeholder: UIImage(), options: [.processor(PDFProcessor())])
        
        guard let icon2URL = URL(string: model?.flow2?.det_img ?? "") else { return }
        
//        warningIconImageView.kf.setImage(with: icon2URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        warningIconImageView.kf.setImage(with: icon2URL, placeholder: UIImage(), options: [.processor(PDFProcessor())])
    }

    private func setupUI() {
        view.addSubview(backgroundGlowImageView)
        view.addSubview(warningIconImageView)
        view.addSubview(titleLabel)

        infoContainerView.addSubview(primaryInfoLabel)
        infoContainerView.addSubview(secondaryInfoLabel)
        view.addSubview(infoContainerView)

        view.addSubview(activateButton)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        let verticalSpacing: CGFloat = 20
        let horizontalPadding: CGFloat = Constants.isIpad ? 80 : 25

        NSLayoutConstraint.activate([
            // Background Glow ImageView (covers entire screen)
            backgroundGlowImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.isIpad ? 150 : (Constants.se3Screen ? (Constants.se1Screen ? -50 : 0) : (Constants.maxScreen ? 40 : 0))),
            backgroundGlowImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundGlowImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundGlowImageView.heightAnchor.constraint(equalToConstant: 500),

            // Warning Icon ImageView (Centered horizontally, in the upper third)
            warningIconImageView.bottomAnchor.constraint(equalTo: backgroundGlowImageView.centerYAnchor, constant: view.bounds.width * 0.14),
            warningIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningIconImageView.widthAnchor.constraint(equalToConstant: Constants.isIpad ? 270 : (Constants.se3Screen ? (Constants.se1Screen ? 144 : 162) : 179)),
            warningIconImageView.heightAnchor.constraint(equalToConstant: Constants.isIpad ? 270 : (Constants.se3Screen ? (Constants.se1Screen ? 144 : 162) : 179)),

            // Title Label (Below warning icon)
            titleLabel.topAnchor.constraint(equalTo: warningIconImageView.bottomAnchor, constant: -5),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -horizontalPadding),

            // Info Container View (Below title label)
            infoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            infoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            // Primary Info Label (Inside info container)
            primaryInfoLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: verticalSpacing * 0.75),
            primaryInfoLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 15),
            primaryInfoLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -15),

            // Secondary Info Label (Below primary info label)
            secondaryInfoLabel.topAnchor.constraint(equalTo: primaryInfoLabel.bottomAnchor, constant: verticalSpacing * 0.8),
            secondaryInfoLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 15),
            secondaryInfoLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -15),
            secondaryInfoLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -verticalSpacing * 0.75), // Determines container height

            // Activate Button (Bottom of the screen)
            activateButton.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: Constants.isIpad ? 30 : 10),
            activateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            activateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            activateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? -15 : -15) : (Constants.maxScreen ? -40 : -30)),
            activateButton.heightAnchor.constraint(equalToConstant: Constants.se3Screen ? (Constants.se1Screen ? 50 : 55) : 63)
        ])
    }

    // MARK: - Actions

    @objc private func activateButtonTapped() {
//        let purchaseSucceeded = Bool.random()
//
//        if purchaseSucceeded {
//            let successVC = Fl1FourthAnimationVC(model, isFromFirst: false, delegate: self.delegate, rScreen: rScreen)
//
//            navigationController?.pushViewController(successVC, animated: true)
//        } else {
//            let alert = UIAlertController(title: "Activation Failed",
//                                      message: "The security activation could not be completed at this time. Please try again later.",
//                                      preferredStyle: .alert)
//            
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        
        self.delegate?.buttonTapped(isResult: false)
    }
    
    public func goToNext(isPaid: Bool) {
        if isPaid {
            let successVC = Fl1FourthAnimationVC(model, isFromFirst: false, delegate: self.delegate, rScreen: rScreen)

            navigationController?.pushViewController(successVC, animated: true)
        } else {
            let resultVC = FlRFirstAnimationVC(model, delegate: delegate, isPaid: false)
            navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}


