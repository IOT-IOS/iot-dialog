import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabBarBottom()
    }
    
    func initTabBarBottom() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "dialog", image: UIImage(named: "dialog"), tag: 0)
        
        let historyViewController = HistoryViewController()
        historyViewController.tabBarItem = UITabBarItem(title: "history", image: UIImage(named: "history"), tag: 1)
        
        let tabBarList = [homeViewController, historyViewController]
        viewControllers = tabBarList
    }

}
