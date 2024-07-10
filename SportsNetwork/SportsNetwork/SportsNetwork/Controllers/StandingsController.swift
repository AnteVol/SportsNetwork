import UIKit
import WebKit
import PureLayout

class StandingsController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    let sportName: String
    var model: SportDataModel?
    
    init(sportName: String) {
        self.sportName = sportName
        self.model = SportDataModel(sport: sportName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        loadSofascoreStandings()
        
        let attributionLabel = UILabel()
        attributionLabel.text = "Standings provided by "
        attributionLabel.textAlignment = .left
        attributionLabel.font = UIFont.systemFont(ofSize: 12)
        attributionLabel.textColor = .gray
        view.addSubview(attributionLabel)
        
        let sofascoreLink = UIButton()
        sofascoreLink.setTitle("Sofascore", for: .normal)
        sofascoreLink.setTitleColor(.blue, for: .normal)
        sofascoreLink.addTarget(self, action: #selector(openSofascore), for: .touchUpInside)
        view.addSubview(sofascoreLink)
        
        webView.autoPinEdge(toSuperviewSafeArea: .top)
        webView.autoPinEdge(toSuperviewSafeArea: .leading)
        webView.autoPinEdge(toSuperviewSafeArea: .trailing)
        webView.autoPinEdge(.bottom, to: .top, of: attributionLabel, withOffset: -8)
        
        attributionLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        attributionLabel.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        
        sofascoreLink.autoPinEdge(.leading, to: .trailing, of: attributionLabel, withOffset: 4)
        sofascoreLink.autoAlignAxis(.horizontal, toSameAxisOf: attributionLabel)
    }
    
    func loadSofascoreStandings(){
        let urlString = model?.standingsLink ?? "https://www.sofascore.com/"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func openSofascore() {
        if let url = URL(string: "https://www.sofascore.com/") {
            UIApplication.shared.open(url)
        }
    }
}
