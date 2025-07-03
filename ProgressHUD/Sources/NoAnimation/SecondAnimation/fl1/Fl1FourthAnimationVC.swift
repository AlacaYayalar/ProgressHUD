import UIKit

public final class Fl1FourthAnimationVC: UIViewController {

    // MARK: - UI Elements

    private let iconWithGlowImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.isIpad ? 48 : 30, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        
        pv.progress = 0.0
        pv.progressTintColor = UIColor(resource: .localProgressBlue)
        pv.trackTintColor = UIColor(resource: .localProgressBG)
        pv.layer.cornerRadius = 7
        pv.clipsToBounds = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        
        return pv
    }()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "0%"
        label.font = .systemFont(ofSize: Constants.isIpad ? 26 : 18, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: - Properties
    private var timer: Timer?
    private var currentProgress: Float = 0.0
    private let totalDuration: TimeInterval = 5.0 // Simulate for 5 seconds
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
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startProgressSimulation()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }

    // MARK: - UI Setup
    private func setupInfo() {
        statusLabel.text = isFromFirst ? (model?.flow1?.scr3_tl) : (model?.flow2?.remov_tl)
        
        guard let iconURL = URL(string: model?.flow1?.scr3_img ?? "") else { return }
        
        iconWithGlowImageView.kf.setImage(with: iconURL, placeholder: UIImage())
    }
    
    private func setupUI() {
        view.addSubview(iconWithGlowImageView)
        view.addSubview(statusLabel)
        view.addSubview(progressView)
        view.addSubview(percentageLabel)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        let iconSize: CGFloat = Constants.isIpad ? view.bounds.width * 0.6 : 350
        let horizontalPadding: CGFloat = Constants.isIpad ? 80 : 20

        NSLayoutConstraint.activate([
            // Icon with Glow
            iconWithGlowImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconWithGlowImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconWithGlowImageView.heightAnchor.constraint(equalToConstant:  Constants.se3Screen ? (Constants.se1Screen ? iconSize * 0.9 : iconSize) : iconSize),
            iconWithGlowImageView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: 0),

            // Status Label
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            // Progress View
            progressView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 25),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            progressView.heightAnchor.constraint(equalToConstant: 15),

            // Percentage Label
            percentageLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            percentageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Progress Simulation
    private func startProgressSimulation() {
        currentProgress = 0.0
        progressView.setProgress(0.0, animated: false)
        percentageLabel.text = "0%"

        let updatesPerSecond: Double = 30.0
        let increment = 1.0 / (Float(totalDuration) * Float(updatesPerSecond))

        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / updatesPerSecond, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.currentProgress += increment
            
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.progressView.setProgress(self.currentProgress, animated: true)
                self.percentageLabel.text = "100%"
                self.timer?.invalidate()
                self.timer = nil
                self.navigateToCompletionScreen()
            } else {
                self.progressView.setProgress(self.currentProgress, animated: true)
                let percentage = Int(self.currentProgress * 100)
                
                self.percentageLabel.text = "\(percentage)%"
            }
        }
    }

    private func navigateToCompletionScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let deviceSecureVC = Fl1FifthAnimationVC(self.model, isFromFirst: self.isFromFirst, delegate: self.delegate, rScreen: self.rScreen)
            
            self.navigationController?.pushViewController(deviceSecureVC, animated: true)
        }
    }
}

