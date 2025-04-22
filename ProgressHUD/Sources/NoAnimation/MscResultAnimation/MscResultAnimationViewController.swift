import UIKit

public class MscResultAnimationViewController: UIViewController, SpecialAnimationDelegate {
    private let screenSE1 = UIScreen.main.nativeBounds.height <= 1136
    private let screenSE3 = UIScreen.main.nativeBounds.height <= 1334
    
    public func buttonTapped(isResult: Bool) {
        delegate?.buttonTapped(isResult: isResult)
    }
    
    public func eventsFunc(event: EventsName) {
        delegate?.eventsFunc(event: event)
    }
    
    public var isPaid: Bool
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    
    // MARK: - Private Properties
    private var isProtectionEnabled = true
    private var autoScrollTimer: Timer?
    private var currentCardIndex = 0
    
    // MARK: - UI Elements
    private let mainContainerView = UIView()
    private let topLabel = UILabel()
    private let corgiImageView = UIImageView()
    private let cardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let pageControl = UIPageControl()
    private let switchLabel = UILabel()
    private let greenSwitch = UISwitch()
    private let exploreButton = UIButton()
    private let closeButton = UIButton()
    private let switchContainerView = UIView()
    
    // MARK: - UI Constraint values
    private var exploreButtonHeight: CGFloat = 56
    private var switchContainerViewHeightAct: CGFloat = 62
    private var switchContainerViewHeightDis: CGFloat = 88
    private var cardsCollectionViewHeight: CGFloat = 88
    private var pageControllHeight: CGFloat = 20
    private var topOffsetAct: CGFloat = 20
    private var topOffsetDis: CGFloat = 20
    private var bottomOffset: CGFloat = 25
    private var corgiIVTopOffsetAct: CGFloat = 25
    private var corgiIVBottomOffsetAct: CGFloat = 25
    private var corgiIVTopOffsetDis: CGFloat = 25
    private var corgiIVBottomOffsetDis: CGFloat = 25
    private var topFontSize: CGFloat = 36
    private var switchFontSize: CGFloat = 17
    private var buttonFontSize: CGFloat = 18
    
    // MARK: - Init
    public init(_ model: AuthorizationOfferModel? = nil, isPaid: Bool, delegate: SpecialAnimationDelegate?) {
        self.model = model
        self.delegate = delegate
        self.isPaid = isPaid
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFirst()
        setupUI()
        setupConstraints()
        updateUI(animated: false)
        startAutoScrollTimer()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopAutoScrollTimer()
    }
    
    // MARK: - Setup
    private func setupFirst() {
//        if isPaid {
//            if !Storage.isFirstShowMsc {
//                isProtectionEnabled = true
//                Storage.isFirstShowMsc = true
//                Storage.isMscActive = true
//            } else {
//                isProtectionEnabled = Storage.isMscActive
//            }
//        } else {
//            isProtectionEnabled = false
//            Storage.isMscActive = false
//        }
//        if isPaid {
//            if Storage.isMscActive == nil {
//                Storage.isMscActive = isPaid
//                isProtectionEnabled = isPaid
//            } else {
//                isProtectionEnabled = Storage.isMscActive ?? false
//            }
//        } else {
            if Storage.isMscActive == nil {
                Storage.isMscActive = isPaid
                isProtectionEnabled = isPaid
            } else {
                isProtectionEnabled = Storage.isMscActive ?? false
            }
            
//        }
        
        if screenSE1 {
            
        } else if screenSE3 {
            exploreButtonHeight = 50
            switchContainerViewHeightAct = 60
            switchContainerViewHeightDis = 80
            cardsCollectionViewHeight = 80
            pageControllHeight = 15
            topOffsetAct = 0
            topOffsetDis = 35
            bottomOffset = 5
            corgiIVTopOffsetAct = 10
            corgiIVBottomOffsetAct  = 20
            corgiIVTopOffsetDis = 10
            corgiIVBottomOffsetDis = 35
            topFontSize = 30
            switchFontSize = 15
            buttonFontSize = 16
        } else {
            exploreButtonHeight = 56
            switchContainerViewHeightAct = 62
            switchContainerViewHeightDis = 88
            cardsCollectionViewHeight = 88
            pageControllHeight = 20
            topOffsetAct = 20
            topOffsetDis = 70
            bottomOffset = 20
            corgiIVTopOffsetAct = 30
            corgiIVBottomOffsetAct  = 20
            corgiIVTopOffsetDis = 42
            corgiIVBottomOffsetDis = 53
            topFontSize = 36
            switchFontSize = 17
            buttonFontSize = 18
        }
    }
    
    private func setupUI() {
        if !ProgressHUD.shared.isShow {
            guard let secureView = SecureField().secureContainer else { return }
            view.addSubview(secureView)
            secureView.snp.makeConstraints({$0.edges.equalToSuperview()})
            secureView.addSubview(mainContainerView)
        } else {
            view.addSubview(mainContainerView)
        }
        
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        mainContainerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        topLabel.text = model?.msc?.title ?? ""
        topLabel.textColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1)
        topLabel.font = UIFont.systemFont(ofSize: topFontSize, weight: .bold)
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        mainContainerView.addSubview(topLabel)
        
        corgiImageView.contentMode = .scaleAspectFit
        loadCorgiImage(isHappy: true)
        mainContainerView.addSubview(corgiImageView)
        
        cardsCollectionView.backgroundColor = .clear
        cardsCollectionView.showsHorizontalScrollIndicator = false
        cardsCollectionView.isPagingEnabled = true
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        mainContainerView.addSubview(cardsCollectionView)
        
        pageControl.numberOfPages = model?.msc?.cards?.count ?? 0
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 32/255, green: 123/255, blue: 234/255, alpha: 1)
        mainContainerView.addSubview(pageControl)
        
        switchContainerView.layer.cornerRadius = 15
        switchContainerView.backgroundColor = .white
        mainContainerView.addSubview(switchContainerView)
        
        switchLabel.text = model?.msc?.swtTitle ?? ""
        switchLabel.font = UIFont.systemFont(ofSize: switchFontSize, weight: .medium)
        switchLabel.textColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1)
        switchContainerView.addSubview(switchLabel)
        
        greenSwitch.isOn = isProtectionEnabled
        greenSwitch.onTintColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)
        greenSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        switchContainerView.addSubview(greenSwitch)
        
        exploreButton.setTitle(model?.msc?.btnTitle ?? "", for: .normal)
        exploreButton.backgroundColor = UIColor(red: 32/255, green: 123/255, blue: 234/255, alpha: 1)
        exploreButton.setTitleColor(.white, for: .normal)
        exploreButton.layer.cornerRadius = 15
        exploreButton.addTarget(self, action: #selector(buttonExpTapped), for: .touchUpInside)
        exploreButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .medium)
        mainContainerView.addSubview(exploreButton)
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        closeButton.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        closeButton.layer.cornerRadius = 16
        closeButton.alpha = 0
        mainContainerView.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffsetAct)
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(32)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffsetAct)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        exploreButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(exploreButtonHeight)
            make.bottom.equalToSuperview().offset(-bottomOffset)
        }
        
        switchContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(isProtectionEnabled ? switchContainerViewHeightAct : switchContainerViewHeightDis)
            make.bottom.equalTo(exploreButton.snp.top).offset(-16)
        }
        
        switchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        greenSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(switchContainerView.snp.top).offset(-18)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        cardsCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-18)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(cardsCollectionViewHeight)
        }
        
        corgiImageView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(isProtectionEnabled ? corgiIVTopOffsetAct : corgiIVTopOffsetDis)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(mainContainerView.snp.width)
            
            if self.isProtectionEnabled {
                make.bottom.equalTo(cardsCollectionView.snp.top).offset(-corgiIVBottomOffsetAct)
            } else {
                make.bottom.equalTo(switchContainerView.snp.top).offset(-corgiIVBottomOffsetDis)
            }
        }
    }
    
    // MARK: - Auto Scroll Timer
    private func startAutoScrollTimer() {
        stopAutoScrollTimer()
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextCard), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    @objc private func scrollToNextCard() {
        guard let cardsCount = model?.msc?.cards?.count, cardsCount > 0 else { return }
        
        currentCardIndex = (currentCardIndex + 1) % cardsCount
        
        let indexPath = IndexPath(item: currentCardIndex, section: 0)
        cardsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCardIndex
    }
    
    @objc private func buttonExpTapped() {
        eventsFunc(event: .featureAction)
    }
    
    @objc private func switchValueChanged() {
        if isPaid {
            isProtectionEnabled = greenSwitch.isOn
            Storage.isMscActive = isProtectionEnabled
            updateUI(animated: true)
        } else {
            greenSwitch.isOn = false
            buttonTapped(isResult: true)
        }
    }
    
    private func updateUI(animated: Bool) {
        let duration = animated ? 0.3 : 0
        
        if isProtectionEnabled {
            greenSwitch.isOn = isProtectionEnabled
            startAutoScrollTimer()
        } else {
            greenSwitch.isOn = isProtectionEnabled
            stopAutoScrollTimer()
        }
        
        UIView.animate(withDuration: duration) {
            self.loadCorgiImage(isHappy: self.isProtectionEnabled)
            
            self.topLabel.text = self.isProtectionEnabled ?
            (self.model?.msc?.title ?? "") :
            (self.model?.msc?.titleDis ?? "")
            
            self.switchContainerView.layer.borderWidth = self.isProtectionEnabled ? 0 : 4
            self.switchContainerView.layer.borderColor = self.isProtectionEnabled ? UIColor.clear.cgColor : UIColor(red: 32/255, green: 123/255, blue: 234/255, alpha: 1).cgColor
            
            self.exploreButton.alpha = self.isProtectionEnabled ? 1 : 0
            self.cardsCollectionView.alpha = self.isProtectionEnabled ? 1 : 0
            self.pageControl.alpha = self.isProtectionEnabled ? 1 : 0
            self.closeButton.alpha = self.isProtectionEnabled ? 0 : 1
        }
        
        switchContainerView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(isProtectionEnabled ? switchContainerViewHeightAct : switchContainerViewHeightDis)
            
            if self.isProtectionEnabled {
                make.bottom.equalTo(exploreButton.snp.top).offset(-16)
            } else {
                make.bottom.equalTo(exploreButton.snp.bottom).offset(-10)
            }
        }
        
        topLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(isProtectionEnabled ? topOffsetAct : topOffsetDis)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        corgiImageView.snp.remakeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(isProtectionEnabled ? corgiIVTopOffsetAct : corgiIVTopOffsetDis)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(mainContainerView.snp.width)
            
            if self.isProtectionEnabled {
                make.bottom.equalTo(cardsCollectionView.snp.top).offset(-corgiIVBottomOffsetAct)
            } else {
                make.bottom.equalTo(switchContainerView.snp.top).offset(-corgiIVBottomOffsetDis)
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func loadCorgiImage(isHappy: Bool) {
        let urlString = isHappy ? (model?.msc?.iconAct ?? "") : (model?.msc?.iconDis ?? "")
        
        if let url = URL(string: urlString) {
            let processor = SVGImgProcessor()
            corgiImageView.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .transition(.fade(0.2))
                ],
                completionHandler: { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        let systemName = isHappy ? "" : ""
                        let configuration = UIImage.SymbolConfiguration(pointSize: 100)
                        self.corgiImageView.image = UIImage(systemName: systemName, withConfiguration: configuration)
                    }
                }
            )
        } else {
            let systemName = isHappy ? "" : ""
            let configuration = UIImage.SymbolConfiguration(pointSize: 100)
            corgiImageView.image = UIImage(systemName: systemName, withConfiguration: configuration)
        }
    }
}

// MARK: - Collection View Delegate & DataSource
extension MscResultAnimationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.msc?.cards?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        if let cards = model?.msc?.cards, indexPath.item < cards.count {
            cell.configure(with: cards[indexPath.item], iconURL: model?.msc?.smallIcon)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
        currentCardIndex = pageIndex
        
        if isProtectionEnabled {
            startAutoScrollTimer()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScrollTimer()
    }
}
