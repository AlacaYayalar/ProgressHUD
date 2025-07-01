import UIKit

public final class FlRFirstAnimationVC: UIViewController {

    // MARK: - UI Elements
    
    private let topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "resultContainerColor") /*.resultContainer*/
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false // Important
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let handIconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let protectedStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastScanLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spamProtectionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "resultContainerColor") /*.resultContainer*/
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false // Important
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spamProtectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let warningIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let realtimeProtectionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "resultContainerColor") /*.resultContainer*/
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false // Important
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shieldIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let realtimeProtectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let realtimeProtectionSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let protectionSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private var wasNavigationBarHidden: Bool?
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    public var isPaid: Bool?

    // MARK: - Lifecycle
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate?, isPaid: Bool) {
        self.model = model
        self.delegate = delegate
        self.isPaid = isPaid
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "localBGColor") /*.localBG*/
        setupUI()
        setupConstraints()
        setupActions()
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
        protectedStatusLabel.text = model?.result3?.result_tl
        lastScanLabel.text = model?.result3?.result_subt
        spamProtectionLabel.text = model?.result3?.result_box1_tl
        realtimeProtectionTitleLabel.text = model?.result3?.result_box2_tl
        realtimeProtectionSubtitleLabel.text = model?.result3?.result_box2_subt
        
        guard let img1URL = URL(string:  model?.result3?.result_img ?? "") else { return }
        
        handIconImageView.kf.setImage(with: img1URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        guard let img2URL = URL(string: model?.result3?.result_box1_img1 ?? "") else { return }
        
        warningIconImageView.kf.setImage(with: img2URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        guard let img3URL = URL(string: model?.result3?.result_box1_img2 ?? "") else { return }
        
        chevronImageView.kf.setImage(with: img3URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        guard let img4URL = URL(string: model?.result3?.result_box2_img1 ?? "") else { return }
        
        shieldIconImageView.kf.setImage(with: img4URL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }

    private func setupUI() {
        view.addSubview(topContainerView)
        topContainerView.addSubview(handIconImageView)
        topContainerView.addSubview(protectedStatusLabel)
        topContainerView.addSubview(lastScanLabel)
        
        view.addSubview(spamProtectionContainerView)
        spamProtectionContainerView.addSubview(spamProtectionLabel)
        spamProtectionContainerView.addSubview(warningIconImageView)
        spamProtectionContainerView.addSubview(chevronImageView)
        
        view.addSubview(realtimeProtectionContainerView)
        realtimeProtectionContainerView.addSubview(shieldIconImageView)
        
        let protectionLabelsStack = UIStackView(arrangedSubviews: [realtimeProtectionTitleLabel, realtimeProtectionSubtitleLabel])
        protectionLabelsStack.axis = .vertical
        protectionLabelsStack.spacing = 2
        protectionLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        realtimeProtectionContainerView.addSubview(protectionLabelsStack)
        realtimeProtectionContainerView.addSubview(protectionSwitch)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        
        let protectionLabelsStack = realtimeProtectionContainerView.subviews.first { $0 is UIStackView }

        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            handIconImageView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 20),
            handIconImageView.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            handIconImageView.widthAnchor.constraint(equalToConstant: 95),
            handIconImageView.heightAnchor.constraint(equalToConstant: 95),
            
            protectedStatusLabel.topAnchor.constraint(equalTo: handIconImageView.bottomAnchor, constant: 16),
            protectedStatusLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            
            lastScanLabel.topAnchor.constraint(equalTo: protectedStatusLabel.bottomAnchor, constant: 8),
            lastScanLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            lastScanLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -20),
            
            spamProtectionContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
            spamProtectionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            spamProtectionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            spamProtectionLabel.leadingAnchor.constraint(equalTo: spamProtectionContainerView.leadingAnchor, constant: 16),
            spamProtectionLabel.centerYAnchor.constraint(equalTo: spamProtectionContainerView.centerYAnchor),
            spamProtectionLabel.topAnchor.constraint(equalTo: spamProtectionContainerView.topAnchor, constant: 20),
            spamProtectionLabel.bottomAnchor.constraint(equalTo: spamProtectionContainerView.bottomAnchor, constant: -20),

            chevronImageView.trailingAnchor.constraint(equalTo: spamProtectionContainerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: spamProtectionContainerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 7),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            warningIconImageView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            warningIconImageView.centerYAnchor.constraint(equalTo: spamProtectionContainerView.centerYAnchor),
            warningIconImageView.widthAnchor.constraint(equalToConstant: 24),
            warningIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            realtimeProtectionContainerView.topAnchor.constraint(equalTo: spamProtectionContainerView.bottomAnchor, constant: 20),
            realtimeProtectionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            realtimeProtectionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),

            shieldIconImageView.leadingAnchor.constraint(equalTo: realtimeProtectionContainerView.leadingAnchor, constant: 16),
            shieldIconImageView.centerYAnchor.constraint(equalTo: realtimeProtectionContainerView.centerYAnchor),
            shieldIconImageView.widthAnchor.constraint(equalToConstant: 40),
            shieldIconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            protectionLabelsStack!.leadingAnchor.constraint(equalTo: shieldIconImageView.trailingAnchor, constant: 12),
            protectionLabelsStack!.centerYAnchor.constraint(equalTo: realtimeProtectionContainerView.centerYAnchor),
            protectionLabelsStack!.topAnchor.constraint(greaterThanOrEqualTo: realtimeProtectionContainerView.topAnchor, constant: 16),
            protectionLabelsStack!.bottomAnchor.constraint(lessThanOrEqualTo: realtimeProtectionContainerView.bottomAnchor, constant: -16),
            
            protectionSwitch.trailingAnchor.constraint(equalTo: realtimeProtectionContainerView.trailingAnchor, constant: -16),
            protectionSwitch.centerYAnchor.constraint(equalTo: realtimeProtectionContainerView.centerYAnchor),
            protectionSwitch.leadingAnchor.constraint(equalTo: protectionLabelsStack!.trailingAnchor, constant: 8)
        ])
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(spamProtectionTapped))
        
        spamProtectionContainerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func spamProtectionTapped() {
        let nextVC = FlRSecondAnimationVC(model, delegate: self.delegate)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
