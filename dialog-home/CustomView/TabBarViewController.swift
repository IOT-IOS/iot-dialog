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
     
        initAppearance()
        let tabBarList = [homeViewController, historyViewController]
        viewControllers = tabBarList
    }

}

extension TabBarViewController {
    func initAppearance() {
        //background TabBar
        tabBar.barTintColor = UIColor.black
        
        //icon
         UITabBar.appearance().tintColor = UIColor.white
        
        //text icon
        let textColorItem   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        setTabBarItemText(color: UIColor.white, state: .normal)
        setTabBarItemText(color: textColorItem, state: .selected)
    }
    
    func setTabBarItemText(color: UIColor, state: UIControl.State) {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: state)
    }
}
