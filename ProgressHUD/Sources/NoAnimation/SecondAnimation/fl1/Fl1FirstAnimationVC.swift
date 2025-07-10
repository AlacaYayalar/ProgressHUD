import UIKit
import ScreenShield

struct Constants {
    static let se3Screen = UIScreen.main.nativeBounds.height <= 1334
    static let se1Screen = UIScreen.main.nativeBounds.height == 1136
    static let maxScreen = UIScreen.main.nativeBounds.height >= 2688
    
    static let isIpad = UIDevice().userInterfaceIdiom == .pad
    
    static var isDarkMode: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }
}

public final class Fl1FirstAnimationVC: UIViewController {
        
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.isIpad ? 48 : 30, weight: .bold)
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(resource: .localSubtitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let waitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(resource: .localButton)
        button.setTitleColor(UIColor(resource: .localButtonText), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.se3Screen ? (Constants.se1Screen ? 20 : 22) : 24, weight: .medium)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Animation Properties
    private var animationTimer: Timer?
    private var progressTimer: Timer?
    private let totalDuration: TimeInterval = 8.0 // 8 секунд общая длительность
    private var currentProgress: Float = 0.0
    private var currentStepIndex = 0
    
    private let changePoints: [Float] = [0.15, 0.35, 0.55, 0.75, 0.95]
    
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
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.titleLabel)
            ScreenShield.shared.protect(view: self.imageView)
            ScreenShield.shared.protect(view: self.progressView)
            ScreenShield.shared.protect(view: self.statusLabel)
            ScreenShield.shared.protect(view: self.waitButton)
            ScreenShield.shared.protectFromScreenRecording()
        }
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
        titleLabel.text = model?.flow1?.loading_tl
        waitButton.setTitle(model?.flow1?.loading_btn_tl, for: .normal)
        
        guard let img1 = URL(string: model?.flow1?.loading_img_1 ?? "") else { return }
        guard let img2 = URL(string: Constants.isDarkMode ? (model?.flow1?.loading_img_2D ?? "") : (model?.flow1?.loading_img_2 ?? "")) else { return }
        guard let img3 = URL(string: model?.flow1?.loading_img_3 ?? "") else { return }
        guard let img4 = URL(string: Constants.isDarkMode ? (model?.flow1?.loading_img_4D ?? "") : (model?.flow1?.loading_img_4 ?? "")) else { return }
        guard let img5 = URL(string: model?.flow1?.loading_img_5 ?? "") else { return }
        guard let img6 = URL(string: Constants.isDarkMode ? (model?.flow1?.loading_img_6D ?? "") : (model?.flow1?.loading_img_6 ?? "")) else { return }
        
        scanningSteps = [
            (img1, model?.flow1?.loading_subt_1 ?? ""),
            (img2, model?.flow1?.loading_subt_1 ?? ""),
            (img3, model?.flow1?.loading_subt_2 ?? ""),
            (img4, model?.flow1?.loading_subt_2 ?? ""),
            (img5, model?.flow1?.loading_subt_3 ?? ""),
            (img6, model?.flow1?.loading_subt_3 ?? "")
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .localBG)
        
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(progressView)
        view.addSubview(statusLabel)
        view.addSubview(waitButton)
        
        updateUI(for: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.6 : view.bounds.width * 0.8),
            imageView.heightAnchor.constraint(equalToConstant: Constants.isIpad ? view.bounds.width * 0.6 : view.bounds.width * 0.8),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.bounds.height * 0.12)),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? -20 : -25) : (Constants.maxScreen ? -40 : -35)),
            
            progressView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.isIpad ? 80 : 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.isIpad ? -80 : -20),
            progressView.heightAnchor.constraint(equalToConstant: 14),
            
            statusLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            waitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.se3Screen ? (Constants.se1Screen ? -15 : -15) : (Constants.maxScreen ? -40 : -30)),
            waitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.isIpad ? 80 : 20),
            waitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.isIpad ? -80 : -20),
            waitButton.heightAnchor.constraint(equalToConstant: Constants.se3Screen ? (Constants.se1Screen ? 50 : 55) : 63)
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
        // Заполняем по 1% каждые 0.08 секунды (8 секунд / 100% = 0.08 сек на 1%)
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] _ in
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
        let vc = Fl1SecondAnimationVC(model, delegate: self.delegate, rScreen: rScreen)
        
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
                
        imageView.kf.setImage(with: stepData.imageName, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    private func updateStatusForStep(_ step: Int) {
        guard step < scanningSteps.count else { return }
        
        let stepData = scanningSteps[step]
        statusLabel.text = stepData.statusText
    }
    
    public func goToNext(isPaid: Bool, isSecond: Bool) {
        if let viewControllers = navigationController?.viewControllers {
            for vc in viewControllers {
                if isSecond {
                    if let secondVC = vc as? Fl1SecondAnimationVC {
                        secondVC.goToNext(isPaid: isPaid)
                        break
                    }
                } else {
                    if let thirdVC = vc as? Fl1ThirdAnimationVC {
                        thirdVC.goToNext(isPaid: isPaid)
                        break
                    }
                }
            }
        }
    }
}

