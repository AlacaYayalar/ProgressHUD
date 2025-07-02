import UIKit

public final class Fl3SecondAnimationVC: UIViewController {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let alertIconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let alertInfoContainerView: UIView = {
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

    private let alertTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let alertDetailLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private lazy var viewDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(viewDetailsButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var wasNavigationBarHidden: Bool?
    
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

        if let navController = navigationController {
            if wasNavigationBarHidden == nil {
                 wasNavigationBarHidden = navController.isNavigationBarHidden
            }
            navController.setNavigationBarHidden(true, animated: animated)
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navController = navigationController, let wasHidden = wasNavigationBarHidden {
            if !wasHidden {
                navController.setNavigationBarHidden(false, animated: animated)
            }
        }
    }

    // MARK: - UI Setup
    private func setupInfo() {
        titleLabel.text = model?.flow3?.loading3_tl
        alertTitleLabel.text = model?.flow3?.loading3_details_tl
        alertDetailLabel.text = model?.flow3?.loading3_details_subt
        viewDetailsButton.setTitle(model?.flow3?.loading3_details_btn, for: .normal)
                
        guard let iconURL = URL(string: model?.flow3?.loading3_det_img ?? "") else { return }
        
        alertIconImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(alertIconImageView)
        
        alertInfoContainerView.addSubview(alertTitleLabel)
        alertInfoContainerView.addSubview(alertDetailLabel)
        view.addSubview(alertInfoContainerView)
        
        view.addSubview(viewDetailsButton)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        let iconSize: CGFloat = 250
        let horizontalPaddingForText: CGFloat = 30
        let horizontalPaddingForElements: CGFloat = 20
        let titleTopPadding: CGFloat = 60

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPaddingForText),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPaddingForText),

            alertIconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            alertIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertIconImageView.heightAnchor.constraint(equalToConstant: iconSize),
            alertIconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alertIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            alertInfoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPaddingForElements),
            alertInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPaddingForElements),

            alertTitleLabel.topAnchor.constraint(equalTo: alertInfoContainerView.topAnchor, constant: 16),
            alertTitleLabel.leadingAnchor.constraint(equalTo: alertInfoContainerView.leadingAnchor, constant: 16),
            alertTitleLabel.trailingAnchor.constraint(equalTo: alertInfoContainerView.trailingAnchor, constant: -16),

            alertDetailLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 8),
            alertDetailLabel.leadingAnchor.constraint(equalTo: alertInfoContainerView.leadingAnchor, constant: 16),
            alertDetailLabel.trailingAnchor.constraint(equalTo: alertInfoContainerView.trailingAnchor, constant: -16),
            alertDetailLabel.bottomAnchor.constraint(equalTo: alertInfoContainerView.bottomAnchor, constant: -16),

            viewDetailsButton.topAnchor.constraint(equalTo: alertInfoContainerView.bottomAnchor, constant: 20),
            viewDetailsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPaddingForElements),
            viewDetailsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPaddingForElements),
            viewDetailsButton.heightAnchor.constraint(equalToConstant: 60),
            viewDetailsButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Actions

    @objc private func viewDetailsButtonTapped() {
        let detailVC = Fl3ThirdAnimationVC(model, delegate: self.delegate, rScreen: self.rScreen)

        navigationController?.pushViewController(detailVC, animated: true)
    }
}

