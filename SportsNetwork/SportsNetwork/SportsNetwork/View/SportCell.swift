import UIKit
import PureLayout
import Kingfisher

class SportCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let together = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        together.addSubview(imageView)
        together.addSubview(nameLabel)
        
        contentView.addSubview(together)
        
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
        
        imageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        imageView.autoMatch(.height, to: .height, of: contentView, withMultiplier: 0.7)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        
        nameLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 10)
        nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        
        together.autoPinEdgesToSuperviewEdges(with: .zero)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.2))])
    }
}
