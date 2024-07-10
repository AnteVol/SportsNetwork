import UIKit

class ListOfSportsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let router: Router
    
    let collectionView: UICollectionView
    let items = [
        ("All Sports 🏟", "https://images-platform.99static.com/hJhN99KFc63KpiR1jTsxlfvk52Q=/117x143:884x910/500x500/top/smart/99designs-contests-attachments/112/112065/attachment_112065281"),
        ("NFL 🏈", "https://i0.wp.com/m.media-amazon.com/images/I/61OZ0IegRPL._AC_UF894,1000_QL80_.jpg?ssl=1"),
        ("NBA 🏀", "https://assets.stickpng.com/images/58428defa6515b1e0ad75ab4.png"),
        ("MLB ⚾", "https://wordsabovereplacement.com/wp-content/uploads/2020/06/mlb.png"),
        ("NHL 🏒", "https://logowik.com/content/uploads/images/nhl-on-tnt-20214176.logowik.com.webp"),
        ("Motorsports 🏎️", "https://assets.stickpng.com/images/61fc02163cf0e70004222072.png"),
        ("Soccer ⚽", "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/UEFA_logo.svg/2560px-UEFA_logo.svg.png"),
        ("ESPNU 🎓", "https://hotdog.com/wp-content/uploads/watch-espnu-without-cable.png"),
        ("College Basketball 🎓🏀", "https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/March_Madness_logo.svg/1200px-March_Madness_logo.svg.png"),
        ("College Football 🎓🏈", "https://greenhouse.hulu.com/app/uploads/sites/11/2023/08/NCAA-FOOTBALL.jpeg"),
        ("Poker News 🃏", "https://t3.ftcdn.net/jpg/04/39/82/84/360_F_439828429_jYMsCVybpgpsEgbfcFWYEMTYkKjmO6cx.jpg")
    ]
    
    init(router: Router) {
        self.router = router
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sport Categories"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(SportCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.backgroundColor = UIColor(red: 232/255.0, green: 241/255.0, blue: 242/255.0, alpha: 1)
        collectionView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SportCell
        let item = items[indexPath.row]
        cell.nameLabel.text = item.0
        cell.setImage(from: item.1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSportName = items[indexPath.row].0
        router.showNewsForSport(sportName: selectedSportName)
    }
    
    @objc func showStandings() {
        // Implement action for standings button
    }
}
