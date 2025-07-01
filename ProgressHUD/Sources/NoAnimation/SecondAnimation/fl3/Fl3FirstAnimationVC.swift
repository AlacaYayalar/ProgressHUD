import UIKit

public final class Fl3FirstAnimationVC: UIViewController {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        
        pv.progress = 0.0
        pv.progressTintColor = UIColor(named: "localProgressBlueColor") /*.localProgressBlue*/
        pv.trackTintColor = UIColor(named: "localProgressBGColor") /*.localProgressBG*/
        pv.layer.cornerRadius = 7
        pv.clipsToBounds = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        
        return pv
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: - Properties
    private var timer: Timer?
    private var currentProgress: Float = 0.0
    private let totalDuration: TimeInterval = 1
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    public var rScreen: Int

    // MARK: - Lifecycle
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate, rScreen: Int) {
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
        
        view.backgroundColor = UIColor(named: "localBGColor") /*UIColor.localBG*/

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
        titleLabel.text = model?.flow3?.loading3_tl
        statusLabel.text = model?.flow3?.loading3_subt
                
        guard let iconURL = URL(string: model?.flow3?.loading3_img ?? "") else { return }
        
        iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(iconImageView)
        view.addSubview(progressView)
        view.addSubview(statusLabel)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        let iconSize: CGFloat = 200
        let horizontalPadding: CGFloat = 20
        let titleTopPadding: CGFloat = 60

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: 400),

            progressView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            progressView.heightAnchor.constraint(equalToConstant: 14),

            statusLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Progress Simulation
    private func startProgressSimulation() {
        currentProgress = 0.0
        progressView.setProgress(0.0, animated: false)

        let updatesPerSecond: Double = 30.0
        let increment = 1.0 / (Float(totalDuration) * Float(updatesPerSecond))

        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / updatesPerSecond, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.currentProgress += increment
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.progressView.setProgress(self.currentProgress, animated: true)
                self.timer?.invalidate()
                self.timer = nil
                self.navigateToNextScreen()
            } else {
                self.progressView.setProgress(self.currentProgress, animated: true)
            }
        }
    }

    private func navigateToNextScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let alertVC = Fl3SecondAnimationVC(self.model, delegate: self.delegate, rScreen: self.rScreen)
            
            if let navController = self.navigationController {
                navController.pushViewController(alertVC, animated: true)
            } else {
                alertVC.modalPresentationStyle = .fullScreen
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    public func goToNext(isPaid: Bool) {
        if let viewControllers = navigationController?.viewControllers {
            for vc in viewControllers {
                if let thirdVC = vc as? Fl3FourthAnimationVC {
                    thirdVC.goToNext(isPaid: isPaid)
                    break
                }
            }
        }
    }
}

