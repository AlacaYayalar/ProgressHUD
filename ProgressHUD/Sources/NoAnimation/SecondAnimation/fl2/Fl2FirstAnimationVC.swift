import UIKit

public final class Fl2FirstAnimationVC: UIViewController {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.isIpad ? 48 : Constants.se3Screen ? (Constants.se1Screen ? 26 : 28) : 30, weight: .bold)
        label.textColor = UIColor(resource: .localTitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = UIColor(resource: .localProgressBlue)
        progress.trackTintColor = UIColor(resource: .localProgressBG)
        progress.layer.cornerRadius = 7
        progress.clipsToBounds = true
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.se3Screen ? (Constants.se1Screen ? 16 : 18) : 18, weight: .regular)
        label.textColor = UIColor(resource: .localSubtitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bottomView = Fl2FirstAnimationHelpView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Animation Properties
    private var animationTimer: Timer?
    private var progressTimer: Timer?
    private let totalDuration: TimeInterval = 3.0
    private var currentProgress: Float = 0.0
    private var currentStepIndex = 0
    
    private let changePoints: [Float] = [0.15, 0.55]
    
    private var scanningSteps: [(imageName: URL, statusText: String)] = []
    
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
        setupUI()
        setupConstraints()
        setupInfo()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScanning()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanning()
    }
    
    // MARK: - Setup UI
    private func setupInfo() {
        titleLabel.text = model?.flow2?.loading2_tl
        
        bottomView = Fl2FirstAnimationHelpView(model)
        
        guard let imgURL = URL(string: model?.flow2?.loading2_img ?? "") else { return }

        scanningSteps = [
            (imgURL, model?.flow2?.loading2_subt ?? ""),
            (imgURL, model?.flow2?.loading2_subt ?? ""),
            (imgURL, model?.flow2?.loading2_subt ?? "")
        ]
    }
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .localBG)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(progressView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(bottomView)
        
        updateUI(for: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? 15 : 20) : (Constants.maxScreen ? 65 : 65)),
            
            imageView.widthAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.6 : view.bounds.width * 0.8),
            imageView.heightAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.6 : view.bounds.width * 0.8),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            progressView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.isIpad ? 80 : 20),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.isIpad ? -80 : -20),
            progressView.heightAnchor.constraint(equalToConstant: 14),
            
            statusLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            bottomView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bottomView.heightAnchor.constraint(equalToConstant: 223),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Animation
    private func startScanning() {
        currentProgress = 0.0
        currentStepIndex = 0
        progressView.progress = 0
        
        updateUI(for: 0)
        
        startProgressAnimation()
    }
    
    private func startProgressAnimation() {
        // Заполняем по 1% каждые 0.03 секунды (3 секунд / 100% = 0.03 сек на 1%)
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentProgress += 0.01 // +1%
            
            self.checkForContentChange()
            
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.progressView.setProgress(self.currentProgress, animated: false)
                self.progressTimer?.invalidate()
                self.progressTimer = nil
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showFinish()
                }
            } else {
                self.progressView.setProgress(self.currentProgress, animated: false)
            }
        }
    }
    
    private func checkForContentChange() {
        if currentStepIndex < changePoints.count && currentProgress >= changePoints[currentStepIndex] {
            currentStepIndex += 1
            
            UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve) {
                self.updateImageForStep(self.currentStepIndex)
            }
            
            UIView.transition(with: statusLabel, duration: 0.5, options: .transitionCrossDissolve) {
                self.updateStatusForStep(self.currentStepIndex)
            }
        }
    }
    
    private func showFinish() {
        let vc = Fl2SecondAnimationVC(model, delegate: self.delegate, rScreen: self.rScreen)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func stopScanning() {
        animationTimer?.invalidate()
        animationTimer = nil
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    private func updateUI(for step: Int) {
        guard step < scanningSteps.count else { return }
        updateImageForStep(step)
        updateStatusForStep(step)
    }
    
    private func updateImageForStep(_ step: Int) {
        guard step < scanningSteps.count else { return }
        
        let stepData = scanningSteps[step]
                
//        imageView.kf.setImage(with: stepData.imageName, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        imageView.kf.setImage(with: stepData.imageName, placeholder: UIImage(), options: [.processor(PDFProcessor())])
        
        setBottomViewVisible(step == 2)
        scrollView.isScrollEnabled = (step == 2)        
    }
    
    private func updateStatusForStep(_ step: Int) {
        guard step < scanningSteps.count else { return }
        
        let stepData = scanningSteps[step]
        statusLabel.text = stepData.statusText
    }
    
    func setBottomViewVisible(_ visible: Bool) {
        if visible {
            bottomView.alpha = 0
            bottomView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            bottomView.isHidden = false

            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseInOut],
                           animations: {
                self.bottomView.alpha = 1
                self.bottomView.transform = .identity
            })
        } else {
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                self.bottomView.alpha = 0
                self.bottomView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: { _ in
                self.bottomView.isHidden = true
            })
        }
    }

    public func goToNext(isPaid: Bool) {        
        if let viewControllers = navigationController?.viewControllers {
            for vc in viewControllers {
                if let thirdVC = vc as? Fl2SecondAnimationVC {
                    thirdVC.goToNext(isPaid: isPaid)
                    break
                }
            }
        }
    }
}


