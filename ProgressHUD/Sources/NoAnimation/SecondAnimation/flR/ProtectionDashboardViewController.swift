
import UIKit

final class ProtectionDashboardViewController: UIViewController {

    // MARK: - UI Elements

    private let headerIconImageView: UIImageView = {
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "hand.raised.fill")
        }
        imageView.tintColor = .white
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 20 // Adjust for desired roundness
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "You are Protected"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastScanLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    public var isPaid: Bool
    
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate?, isPaid: Bool) {
        self.model = model
        self.delegate = delegate
        self.isPaid = isPaid
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use systemGroupedBackground for the main view for a settings-like feel
        view.backgroundColor = UIColor.systemGroupedBackground

        setupUI()
        configureLastScanDate()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(headerIconImageView)
        view.addSubview(titleLabel)
        view.addSubview(lastScanLabel)
        view.addSubview(mainStackView)

        // Create and add the rows to the stack view
        let protectionRow = createRealtimeProtectionRow()
        let systemRow = createSystemRow()
        mainStackView.addArrangedSubview(protectionRow)
        mainStackView.addArrangedSubview(systemRow)

        // Set constraints
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header Section
            headerIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            headerIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerIconImageView.widthAnchor.constraint(equalToConstant: 80),
            headerIconImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: headerIconImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            lastScanLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            lastScanLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Main Stack View for Rows
            mainStackView.topAnchor.constraint(equalTo: lastScanLabel.bottomAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    /// Configures the 'Last scan' date label with a locale-aware date format.
    private func configureLastScanDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short // Automatically handles locale (e.g., M/d/yy for US, d/M/yy for UK)
        dateFormatter.timeStyle = .none
        let todayString = dateFormatter.string(from: Date())
        lastScanLabel.text = "Last scan: \(todayString)"
    }

    // MARK: - Row Creation Helpers

    private func createRealtimeProtectionRow() -> UIView {
        // Container for the row
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground // White in light, dark gray in dark
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        // Icon
        let iconView = UIView()
        iconView.backgroundColor = .black
        iconView.layer.cornerRadius = 8
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // Labels
        let title = UILabel()
        title.text = "Real-time Protection"
        title.font = .systemFont(ofSize: 17, weight: .regular)
        title.textColor = .label
        
        let subtitle = UILabel()
        subtitle.text = "Auto-detect and remove viruses, avoid security breaches"
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 2
        
        let labelStack = UIStackView(arrangedSubviews: [title, subtitle])
        labelStack.axis = .vertical
        labelStack.spacing = 2
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        // Switch
        let protectionSwitch = UISwitch()
        protectionSwitch.isOn = true
        protectionSwitch.addTarget(self, action: #selector(protectionSwitchChanged(_:)), for: .valueChanged)
        protectionSwitch.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to container
        container.addSubview(iconView)
        container.addSubview(labelStack)
        container.addSubview(protectionSwitch)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            labelStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            labelStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            labelStack.trailingAnchor.constraint(equalTo: protectionSwitch.leadingAnchor, constant: -8),
            
            protectionSwitch.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            protectionSwitch.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            // Set container height
            container.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        return container
    }

    private func createSystemRow() -> UIView {
        // Container for the row
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        // Icon
        let iconView = UIImageView(image: UIImage(systemName: "gearshape.fill"))
        iconView.tintColor = .systemGray
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // Label
        let title = UILabel()
        title.text = "System"
        title.font = .systemFont(ofSize: 17, weight: .regular)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        
        // Scan Now Button
        let scanNowButton = UIButton(type: .system)
        let chevronImage = UIImage(systemName: "chevron.right")
        scanNowButton.setImage(chevronImage, for: .normal)
        scanNowButton.setTitle("Scan Now ", for: .normal) // Note the space for padding
        scanNowButton.titleLabel?.font = .systemFont(ofSize: 17)
        scanNowButton.semanticContentAttribute = .forceRightToLeft // Puts image on the right
        scanNowButton.tintColor = .systemGray
        scanNowButton.addTarget(self, action: #selector(scanNowTapped), for: .touchUpInside)
        scanNowButton.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconView)
        container.addSubview(title)
        container.addSubview(scanNowButton)
        
        // Make the whole container tappable
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scanNowTapped))
        container.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            title.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            scanNowButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            scanNowButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            // Set container height
            container.heightAnchor.constraint(equalToConstant: 70)
        ])

        return container
    }

    // MARK: - Actions

    @objc private func protectionSwitchChanged(_ sender: UISwitch) {
        print("Real-time Protection is now \(sender.isOn ? "ON" : "OFF")")
        // Add logic to handle the state change here
    }

    @objc private func scanNowTapped() {
        print("Scan Now tapped, presenting SystemScanViewController.")
        let systemScanVC = SystemScanViewController(model, delegate: delegate, isPaid: isPaid)
        systemScanVC.modalPresentationStyle = .fullScreen
        present(systemScanVC, animated: true, completion: nil)
    }
}
