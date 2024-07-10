import UIKit

class NewsItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NewsItemCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let readLaterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Read Later 📚", for: .normal)
        button.setTitle("Saved! 💙", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.addTarget(NewsItemCollectionViewCell.self, action: #selector(readLaterButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private var newsURL: URL?
    
    var readLaterButtonTappedCallback: (() -> Void)?
    
    var tapAction: (() -> Void)?
    
    private var newsItem: NewsItem?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(readLaterButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        
        readLaterButton.translatesAutoresizingMaskIntoConstraints = false
        readLaterButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        readLaterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        readLaterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        readLaterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        readLaterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configure(with item: NewsItem, isFavorite: Bool = false, newsURL: URL? = nil) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        if let pubDate = item.pubDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
            dateLabel.text = dateFormatter.string(from: pubDate)
        } else {
            dateLabel.text = ""
        }
        
        let isSaved = SavedData.shared.readLater.contains { $0.link == item.link }
        readLaterButton.isSelected = isSaved
        readLaterButton.backgroundColor = isSaved ? .systemBlue : UIColor(red: 176/255.0, green: 224/255.0, blue: 230/255.0, alpha: 1.0)
        
        self.newsURL = newsURL
        self.newsItem = item
    }
    
    @objc private func readLaterButtonTapped(_ sender: UIButton) {
        guard let item = newsItem else { return }
        
        if readLaterButton.isSelected {
            SavedData.shared.removeNewsItem(byLink: item.link)
        } else {
            SavedData.shared.addNewsItem(item)
        }
        
        readLaterButton.isSelected = !readLaterButton.isSelected
        readLaterButton.backgroundColor = readLaterButton.isSelected ? .systemBlue : UIColor(red: 176/255.0, green: 224/255.0, blue: 230/255.0, alpha: 1.0)
        
        readLaterButtonTappedCallback?()
    }
    
    @objc private func cellTapped() {
        tapAction?()
    }
}
