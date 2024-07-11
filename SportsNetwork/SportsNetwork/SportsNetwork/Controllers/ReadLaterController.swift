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

        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(toggleEditingMode))
        navigationItem.leftBarButtonItem = deleteButton

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

    @objc func toggleEditingMode() {
        setEditing(!isEditing, animated: true)
    }

    func refreshGroupedArticles() {
        let articles = SavedData.shared.readLater
        groupedArticles = Dictionary(grouping: articles, by: { $0.sport })
        tableView.reloadData()
    }

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
        
        if let articles = groupedArticles[sportName], indexPath.row < articles.count {
            let article = articles[indexPath.row]
            cell.textLabel?.text = article.title
        } else {
            cell.textLabel?.text = "No article"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            return
        }
        
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sportName = sportNames[indexPath.section]
            if var articles = groupedArticles[sportName] {
                let article = articles.remove(at: indexPath.row)
                SavedData.shared.removeNewsItem(byLink: article.link)
                groupedArticles[sportName] = articles.isEmpty ? nil : articles
            }
            refreshGroupedArticles()
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        
        // Update the delete button title based on the editing state
        navigationItem.leftBarButtonItem?.title = editing ? "Cancel" : "Delete"
        
        if !editing {
            deleteSelectedArticles()
        }
    }

    func deleteSelectedArticles() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }
        
        for indexPath in selectedRows.reversed() {
            let sportName = sportNames[indexPath.section]
            if var articles = groupedArticles[sportName] {
                let article = articles.remove(at: indexPath.row)
                SavedData.shared.removeNewsItem(byLink: article.link)
                groupedArticles[sportName] = articles.isEmpty ? nil : articles
            }
        }
        refreshGroupedArticles()
    }
}
