import Foundation
import FeedKit

struct NewsItem: Hashable, Codable {
    let title: String
    let link: String
    let description: String
    let pubDate: Date?
    let saved: Bool
    let sport: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(link)
        hasher.combine(description)
        hasher.combine(pubDate)
        hasher.combine(sport)
    }
    
    static func ==(lhs: NewsItem, rhs: NewsItem) -> Bool {
        return lhs.title == rhs.title &&
               lhs.link == rhs.link &&
               lhs.description == rhs.description &&
               lhs.pubDate == rhs.pubDate &&
               lhs.sport == rhs.sport
    }
}

struct NewsFeed {
    let sport: String
    var items: [NewsItem]
    mutating func shuffleItems() {
        items.shuffle()
    }
}
