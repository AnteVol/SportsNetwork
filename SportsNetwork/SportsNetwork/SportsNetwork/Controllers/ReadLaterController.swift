import UIKit
import WebKit

class ReadLaterController: UITableViewController {

    var groupedArticles: [String: [NewsItem]] = [:]

    var sportNames: [String] {
        return Array(groupedArticles.keys).sorted()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Read Later"
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetSavedData))
        navigationItem.rightBarButtonItem = resetButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NotificationCenter.default.addObserver(self, selector: #selector(handleNewArticleAdded), name: .newArticleAdded, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshGroupedArticles()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .newArticleAdded, object: nil)
    }

    @objc func handleNewArticleAdded() {
        DispatchQueue.main.async {
            self.refreshGroupedArticles()
            self.tableView.reloadData()
        }
    }

    @objc func resetSavedData() {
        SavedData.shared.resetSavedData()
        refreshGroupedArticles()
    }

    func refreshGroupedArticles() {
        let articles = SavedData.shared.readLater
        groupedArticles = Dictionary(grouping: articles, by: { $0.sport })
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sportNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sportName = sportNames[section]
        return groupedArticles[sportName]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sportName = sportNames[indexPath.section]
        
        // Check if articles for the section exist and if the indexPath is valid
        if let articles = groupedArticles[sportName], indexPath.row < articles.count {
            let article = articles[indexPath.row]
            cell.textLabel?.text = article.title
        } else {
            cell.textLabel?.text = "No article"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sportName = sportNames[indexPath.section]
        
        if let articles = groupedArticles[sportName], indexPath.row < articles.count {
            let article = articles[indexPath.row]
            if let url = URL(string: article.link) {
                let webViewController = WebViewController(url: url)
                navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sportNames[section]
    }
}
