import Foundation
import UIKit
import Kingfisher

final class StatsView: UIView {
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let iconImg = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let textBox1 = BoxStatView()
    private let textBox2 = BoxStatView()
    private let textBox3 = BoxStatView()
    private let textBox4 = BoxStatView()
    private let textBox5 = BoxStatView()
    private let textStackView = UIStackView()
    private let lineView = UIView()
    private let closeButton = UIButton(type: .system)
    
    private var model: AuthorizationOfferModel?
    private var isPaid: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        containerView.layer.cornerRadius = 14
        containerView.clipsToBounds = true
        
        iconImg.contentMode = .scaleAspectFit
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textAlignment = .center
        
        textStackView.axis = .vertical
        textStackView.spacing = 0
        
        textStackView.addArrangedSubview(textBox1)
        textStackView.addArrangedSubview(textBox2)
        textStackView.addArrangedSubview(textBox3)
        textStackView.addArrangedSubview(textBox4)
        textStackView.addArrangedSubview(textBox5)
        
        textStackView.backgroundColor = .white
        textStackView.layer.cornerRadius = 8
        textStackView.clipsToBounds = true
        
        lineView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.36)
        
        closeButton.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(iconImg)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(textStackView)
        containerView.addSubview(lineView)
        containerView.addSubview(closeButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(UIDevice.current.userInterfaceIdiom == .pad ? 150 : 27)
        }
        
        iconImg.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(iconImg.snp.bottom).offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
        
        textStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
        }
        
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(textStackView.snp.bottom).offset(15)
        }
        
        closeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    func setup(with model: AuthorizationOfferModel?, isPaid: Bool?) {
        guard let model = model else { return }
        guard let isPaid = isPaid else { return }
        self.isPaid = isPaid
        self.model = model
        
        guard let icon = URL(string: model.scn?.stats?.statImg ?? ""),
              let icon1 = URL(string: model.scn?.stats?.statScnImg1 ?? ""),
              let icon2 = URL(string: model.scn?.stats?.statScnIcon2 ?? ""),
              let icon3 = URL(string: model.scn?.stats?.statScnIcon3 ?? ""),
              let icon4 = URL(string: model.scn?.stats?.statScnIcon4 ?? ""),
              let icon5 = URL(string: model.scn?.stats?.statScnIcon5 ?? "")
        else { return }
        
        iconImg.kf.setImage(with: icon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        titleLabel.text = model.scn?.stats?.statBtnTitle
        subtitleLabel.text = model.scn?.stats?.statBtnSubtitle
                
        textBox1.setup(icon: icon1, title: model.scn?.stats?.statScnTitle1 ?? "", nubmerStr: isPaid ? (model.scn?.stats?.statScnSubtitle1 ?? "") : "0" , withLine: true)
        textBox2.setup(icon: icon2, title: model.scn?.stats?.statScnText2 ?? "", nubmerStr: isPaid ? (model.scn?.stats?.statScnCount2 ?? "") : "0" , withLine: true)
        textBox3.setup(icon: icon3, title: model.scn?.stats?.statScnText3 ?? "", nubmerStr: isPaid ? (model.scn?.stats?.statScnCount3 ?? "") : "0" , withLine: true)
        textBox4.setup(icon: icon4, title: model.scn?.stats?.statScnText4 ?? "", nubmerStr: isPaid ? (model.scn?.stats?.statScnCount4 ?? "") : "0" , withLine: true)
        textBox5.setup(icon: icon5, title: model.scn?.stats?.statScnText5 ?? "", nubmerStr: isPaid ? (model.scn?.stats?.statScnCount5 ?? "") : "0" , withLine: false)
        
        closeButton.setTitle(model.scn?.stats?.cls, for: .normal)
    }
    
    func show(in viewController: UIViewController) {
        guard let parentView = viewController.view else { return }
        parentView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    @objc private func closeTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

