import Foundation

class SavedData {
    static let shared = SavedData()
    
    private let readLaterKey = "readLater"
    
    var readLater: [NewsItem] {
        get {
            guard let data = UserDefaults.standard.data(forKey: readLaterKey),
                  let items = try? JSONDecoder().decode([NewsItem].self, from: data) else {
                return []
            }
            return items
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: readLaterKey)
        }
    }
    
    func addNewsItem(_ item: NewsItem) {
        var currentItems = readLater
        if !currentItems.contains(item) {
            currentItems.append(item)
            readLater = currentItems
        }
    }
    
    func removeNewsItem(byLink link: String) {
        var currentItems = readLater
        if let index = currentItems.firstIndex(where: { $0.link == link }) {
            currentItems.remove(at: index)
            readLater = currentItems
        }
    }
    
    func resetSavedData() {
        UserDefaults.standard.removeObject(forKey: readLaterKey)
    }
    
}
extension Notification.Name {
    static let newArticleAdded = Notification.Name("newArticleAdded")
}
