import UIKit

class Router {
    
    private var tabBarController: UITabBarController!
    
    func start(in window: UIWindow) {
        // Customize navigation bar appearance globally
        customizeNavigationBarAppearance()
        
        tabBarController = UITabBarController()
        
        let listOfSportsController = ListOfSportsController(router: self)
        let newsNavigationController = UINavigationController(rootViewController: listOfSportsController)
        newsNavigationController.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))
        
        let readLaterController = ReadLaterController()
        let readLaterNavigationController = UINavigationController(rootViewController: readLaterController)
        readLaterNavigationController.tabBarItem = UITabBarItem(title: "Read Later", image: UIImage(systemName: "bookmark"), selectedImage: UIImage(systemName: "bookmark.fill"))
        
        tabBarController.viewControllers = [newsNavigationController, readLaterNavigationController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    func showNewsForSport(sportName: String) {
        guard let selectedNavigationController = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
        
        let newsController = ViewController(sportName: sportName, router:self)
        selectedNavigationController.pushViewController(newsController, animated: true)
    }
    
    func showStandingsForSport(sportName: String) {
        guard let selectedNavigationController = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
        
        let standings = StandingsController(sportName: sportName)
        selectedNavigationController.pushViewController(standings, animated: true)
    }
    
    private func customizeNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor.systemBlue
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().prefersLargeTitles = false
        
        UINavigationBar.appearance().tintColor = .white
    }
}
