import UIKit

public final class FlRSecondAnimationVC: UIViewController {

    // MARK: - UI Elements

    private let topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .localContainer)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let antiSpamContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .resultContainer)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let antiSpamLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let antiSpamSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let scanOptionsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .resultContainer)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var chevronImageURL = URL(string: "")
    private var urlImg1 = URL(string: "")
    private var urlImg2 = URL(string: "")
    private var urlImg3 = URL(string: "")
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?

    // MARK: - Lifecycle
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate?) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .localBG)
        setupInfo()
//        setupUI()
        setupConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor(resource: .navItemColorCust)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI Setup
    private func setupInfo() {
        titleLabel.text = model?.result3?.result_det_tl
        antiSpamLabel.text = model?.result3?.result_det_subt
                
        guard let iconURL = URL(string: model?.result3?.result_det_icon ?? "") else { return }
        
//        shieldIconImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        shieldIconImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(PDFProcessor())])
        
        guard let icon2URL = URL(string: model?.result3?.result_box1_img2 ?? "") else { return }
        
        chevronImageURL = icon2URL
        
        guard let img1URL = URL(string: model?.result3?.result_det_box1_img ?? "") else { return }
        
        urlImg1 = img1URL
        
        guard let img2URL = URL(string: model?.result3?.result_det_box2_img ?? "") else { return }
        
        urlImg2 = img2URL
        
        guard let img3URL = URL(string: model?.result3?.result_det_box3_img ?? "") else { return }
        
        urlImg3 = img3URL
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(topContainerView)
        topContainerView.addSubview(shieldIconImageView)
        topContainerView.addSubview(titleLabel)
        
        view.addSubview(antiSpamContainerView)
        antiSpamContainerView.addSubview(antiSpamLabel)
        antiSpamContainerView.addSubview(antiSpamSwitch)
        
        view.addSubview(scanOptionsContainerView)
        
        let scanningSystemView = createScanOptionView(iconName: urlImg1!, text: model?.result3?.result_det_box1_tl ?? "")
        let scanningNetworksView = createScanOptionView(iconName: urlImg2!, text: model?.result3?.result_det_box2_tl ?? "", iconColor: .systemBlue)
        let appleIDScanView = createScanOptionView(iconName: urlImg3!, text: model?.result3?.result_det_box3_tl ?? "", iconColor: .systemBlue)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(firstButtonTapped))
        scanningSystemView.isUserInteractionEnabled = true
        scanningSystemView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(secondButtonTapped))
        scanningNetworksView.isUserInteractionEnabled = true
        scanningNetworksView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(thirdButtonTapped))
        appleIDScanView.isUserInteractionEnabled = true
        appleIDScanView.addGestureRecognizer(tap3)

        let separator1 = createSeparator()
        let separator2 = createSeparator()
        
        let stackView = UIStackView(arrangedSubviews: [scanningSystemView, separator1, scanningNetworksView, separator2, appleIDScanView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        
        scanOptionsContainerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scanOptionsContainerView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scanOptionsContainerView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: scanOptionsContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scanOptionsContainerView.trailingAnchor)
        ])
    }

    private func createScanOptionView(iconName: URL, text: String, iconColor: UIColor = .gray) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
//        iconImageView.kf.setImage(with: iconName, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        iconImageView.kf.setImage(with: iconName, placeholder: UIImage(), options: [.processor(PDFProcessor())])
        iconImageView.tintColor = iconColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView()
        
//        chevronImageView.kf.setImage(with: chevronImageURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        chevronImageView.kf.setImage(with: chevronImageURL, placeholder: UIImage(), options: [.processor(PDFProcessor())])
        
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iconImageView)
        view.addSubview(label)
        view.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 7),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return view
    }

    private func createSeparator() -> UIView {
        let separatorContainer = UIView()
        separatorContainer.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        separatorContainer.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: separatorContainer.leadingAnchor, constant: 56),
            separator.trailingAnchor.constraint(equalTo: separatorContainer.trailingAnchor),
            separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor),
            separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        return separatorContainer
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            shieldIconImageView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 30),
            shieldIconImageView.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            shieldIconImageView.widthAnchor.constraint(equalToConstant: 98),
            shieldIconImageView.heightAnchor.constraint(equalToConstant: 115),
            
            titleLabel.topAnchor.constraint(equalTo: shieldIconImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -30),
            
            antiSpamContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
            antiSpamContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            antiSpamContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            antiSpamContainerView.heightAnchor.constraint(equalToConstant: 70),

            antiSpamLabel.leadingAnchor.constraint(equalTo: antiSpamContainerView.leadingAnchor, constant: 16),
            antiSpamLabel.centerYAnchor.constraint(equalTo: antiSpamContainerView.centerYAnchor),
            
            antiSpamSwitch.trailingAnchor.constraint(equalTo: antiSpamContainerView.trailingAnchor, constant: -16),
            antiSpamSwitch.centerYAnchor.constraint(equalTo: antiSpamContainerView.centerYAnchor),
            
            scanOptionsContainerView.topAnchor.constraint(equalTo: antiSpamContainerView.bottomAnchor, constant: 20),
            scanOptionsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            scanOptionsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    @objc private func firstButtonTapped() {
        guard let delegate = delegate else { return }
        let vc = Fl1FirstAnimationVC(model, delegate: delegate, rScreen: 1)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func secondButtonTapped() {
        guard let delegate = delegate else { return }
        let vc = Fl2FirstAnimationVC(model, delegate: delegate, rScreen: 1)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func thirdButtonTapped() {
        guard let delegate = delegate else { return }
        let vc = Fl3FirstAnimationVC(model, delegate: delegate, rScreen: 1)
        navigationController?.pushViewController(vc, animated: true)
    }
}

