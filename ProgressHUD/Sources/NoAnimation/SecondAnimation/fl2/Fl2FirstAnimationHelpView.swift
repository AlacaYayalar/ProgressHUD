import UIKit

public final class Fl2FirstAnimationHelpView: UIView {
    
    private let stackView = UIStackView()
    private var networks: [String]
    private var imgURL = URL(string: "")
    
    public var model: AuthorizationOfferModel?

    // MARK: - Init

    init(_ model: AuthorizationOfferModel? = nil) {
        self.model = model
        self.networks = [
            model?.flow2?.loading2_Details_text1 ?? "",
            model?.flow2?.loading2_Details_text2 ?? "",
            model?.flow2?.loading2_Details_text3 ?? "",
            model?.flow2?.loading2_Details_text4 ?? ""
        ]
        
        super.init(frame: .zero)
        setupView()
        
        guard let iconURL = URL(string: model?.flow2?.loading2_Details_img ?? "") else { return }
        
        imgURL = iconURL
        
        setupNetworks()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = UIColor(resource: .localContainer)
        layer.cornerRadius = 15
        clipsToBounds = false
        
        layer.shadowColor = UIColor(resource: .localContainerShadow).cgColor /*UIColor.localContainerShadow.cgColor*/
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupNetworks() {
        for (index, name) in networks.enumerated() {
            let rowView = createRowView(text: name, showSeparator: index < networks.count - 1)
            stackView.addArrangedSubview(rowView)
        }
    }

    private func createRowView(text: String, showSeparator: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView()
        iconImageView.kf.setImage(with: imgURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        iconImageView.tintColor = .systemBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView()
        separator.backgroundColor = UIColor(resource: .localSeporator) 
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.isHidden = !showSeparator

        container.addSubview(iconImageView)
        container.addSubview(label)
        container.addSubview(separator)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 9),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])

        return container
    }
}

