import UIKit
import WebKit
import Kingfisher

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var model: SportDataModel?
    var sportName: String
    var router: Router?

    init(sportName: String, router: Router) {
        self.sportName = sportName
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.sportName = ""
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(sportName) News"
        
        model = SportDataModel(sport: sportName)
        setupCollectionView()
        
        let emojiImage = UIImage(systemName: "chart.bar.fill")
        let standingsButton = UIBarButtonItem(image: emojiImage, style: .plain, target: self, action: #selector(showStandings))
        navigationItem.rightBarButtonItem = standingsButton
        
        collectionView.backgroundColor = UIColor(red: 232/255.0, green: 241/255.0, blue: 242/255.0, alpha: 1)
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(NewsItemCollectionViewCell.self, forCellWithReuseIdentifier: NewsItemCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
    }
    
    private func loadData() {
        model?.fetchRSSFeed {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func refreshData() {
        // Reload any parameters or data that need to be updated
        loadData()
    }
    
    @objc private func shuffleNews() {
        model?.shuffleNews()
        collectionView.reloadData()
    }
    
    @objc private func showStandings() {
        router?.showStandingsForSport(sportName: sportName)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.sportNewsFeeds.first?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsItemCollectionViewCell.reuseIdentifier, for: indexPath) as? NewsItemCollectionViewCell else {
            fatalError("Failed to dequeue NewsItemCollectionViewCell")
        }
        
        if let items = model?.sportNewsFeeds.first?.items {
            let sortedItems = items.sorted { $0.pubDate ?? Date() > $1.pubDate ?? Date() }
            
            let item = sortedItems[indexPath.item]
            _ = SavedData.shared.readLater.contains { $0.link == item.link }
            cell.configure(with: item, isFavorite: false, newsURL: URL(string: item.link))
            
            cell.tapAction = { [weak self] in
                self?.openNewsInWebView(url: URL(string: item.link))
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 240)
    }
    
    private func openNewsInWebView(url: URL?) {
        guard let url = url else { return }
        
        let webViewController = WebViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
