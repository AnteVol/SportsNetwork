import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let webView = WKWebView()
    private var url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.frame = view.bounds
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
