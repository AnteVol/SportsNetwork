import Foundation
import FeedKit

class SportDataModel: ObservableObject {
    
    @Published var sportNewsFeeds: [NewsFeed] = []
    var parser: FeedParser?
    var currentSport: String
    var standingsLink: String
    
    init(sport: String) {
        self.currentSport = sport
        self.standingsLink = ""
        fetchRSSFeed(completion: {})
        self.standingsLink = standingsURL(for: sport)
    }
    
    func fetchRSSFeed(completion: @escaping () -> Void) {
        guard let feedURL = URL(string: feedURLString(for: currentSport)) else {
            print("Invalid feed URL for \(currentSport)")
            return
        }
        
        parser = FeedParser(URL: feedURL)

        parser?.parseAsync { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let feed):
                switch feed {
                case .rss(let rssFeed):
                    if let items = rssFeed.items {
                        let sportNewsItems = items.map { item in
                            return NewsItem(
                                title: item.title ?? "No title",
                                link: item.link ?? "No link",
                                description: item.description ?? "No description",
                                pubDate: item.pubDate,
                                saved: SavedData.shared.readLater.contains { $0.link == item.link },
                                sport: self.currentSport
                            )
                        }
                        var sportNewsFeed = NewsFeed(sport: self.currentSport, items: sportNewsItems)
                        sportNewsFeed.shuffleItems()
                        DispatchQueue.main.async {
                            self.sportNewsFeeds.append(sportNewsFeed)
                            completion()
                        }
                    }

                case .atom, .json:
                    print("Unsupported feed type")
                }

            case .failure(let error):
                print("Failed to parse feed: \(error.localizedDescription)")
            }
        }
    }
    
    func feedURLString(for sport: String) -> String {
        switch sport {
        case "All Sports 🏟":
            return "https://www.espn.com/espn/rss/news"
        case "NFL 🏈":
            return "https://www.espn.com/espn/rss/nfl/news"
        case "NBA 🏀":
            return "https://www.espn.com/espn/rss/nba/news"
        case "MLB ⚾":
            return "https://www.espn.com/espn/rss/mlb/news"
        case "NHL 🏒":
            return "https://www.espn.com/espn/rss/nhl/news"
        case "Motorsports 🏎️":
            return "https://www.espn.com/espn/rss/rpm/news"
        case "Soccer ⚽":
            return "https://www.espn.com/espn/rss/soccer/news"
        case "ESPNU 🎓":
            return "https://www.espn.com/espn/rss/espnu/news"
        case "College Basketball 🎓🏀":
            return "https://www.espn.com/espn/rss/ncb/news"
        case "College Football 🎓🏈":
            return "https://www.espn.com/espn/rss/ncf/news"
        case "Poker News 🃏":
            return "https://www.espn.com/espn/rss/poker/master"
        default:
            return ""
        }
    }
    
    private func standingsURL(for sport: String) -> String {
        switch sport {
        case "All Sports 🏟":
            return "https://www.sofascore.com"
        case "NFL 🏈":
            return "https://widgets.sofascore.com/embed/tournament/108947/season/51361/standings/NFL%2023%2F24?widgetTitle=NFL%2023%2F24&showCompetitionLogo=true"
        case "NBA 🏀":
            return "https://www.sofascore.com/tournament/basketball/usa/nba/132#id:54105"
        case "MLB ⚾":
            return "https://www.sofascore.com/tournament/baseball/usa/mlb/11205#id:57577"
        case "NHL 🏒":
            return "https://www.sofascore.com/tournament/ice-hockey/usa/nhl/234#id:52528"
        case "Motorsports 🏎️":
            return "https://www.sofascore.com/motorsport"
        case "Soccer ⚽":
            return "https://www.sofascore.com/tournament/football/europe/european-championship/1#id:56953"
        case "ESPNU 🎓":
            return "https://www.espn.com/espn/rss/espnu/news"
        case "College Basketball 🎓🏀":
            return "https://www.sofascore.com/tournament/basketball/usa/ncaa-march-madness-division-1/13434#id:59155"
        case "College Football 🎓🏈":
            return "https://www.sofascore.com/tournament/american-football/usa/ncaa-regular-season/19510#id:51602"
        case "Poker News 🃏":
            return "https://www.globalpokerindex.com/rankings/"
        default:
            return "https://www.sofascore.com"
        }
    }
    
    func shuffleNews() {
        guard var sportFeed = sportNewsFeeds.first else { return }
        sportFeed.shuffleItems()
        sportNewsFeeds[0] = sportFeed
    }
}
