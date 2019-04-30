import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // because we already have some settings in Storyboard
        // allows to use same vc class for dif tabs without duplicating it
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // nil = use my current app bundle
            // why do I instantiate vc but using identifier of nav controller?
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavController")
            viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
            tabBarController.viewControllers?.append(viewController)
        }
        return true
    }
}

