//
//  AppDelegate.swift
//  MSGG
//
//  Created by Maxim Solovyov on 26/10/2018.
//  Copyright © 2018 MaximSolovyov. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerDependencies()
        
        setupTabBarController()
        
        return true
    }

    fileprivate func registerDependencies() {
        let container = DepedencyContainer.global
        
        container.register(StreamsService.self, factory: { _ in StreamsServiceImpl() })
        
        container.register(FavoritesService.self, factory: { r in
            FavoritesServiceImpl(streamsService: r.resolve(StreamsService.self)!)
        }).inObjectScope(.container)
        
        container.register(CategoriesService.self, factory: { _ in CategoriesServiceImpl() })
    }
    
    fileprivate func setupTabBarController() {
        let streamListVC = SharedComponents.vcFactory.create(.streamList) as StreamListVC
        streamListVC.title = NSLocalizedString("streams", comment: "")
        
        let favoriteStreamListVC = SharedComponents.vcFactory.create(.streamList) as FavoriteListVC
        favoriteStreamListVC.title = NSLocalizedString("favorites", comment: "")

        let gameListVC = SharedComponents.vcFactory.create(.categoryList) as GameListVC
        gameListVC.title = NSLocalizedString("games", comment: "")

        let genreListVC = SharedComponents.vcFactory.create(.categoryList) as GenreListVC
        genreListVC.title = NSLocalizedString("genres", comment: "")

        let controllers = [streamListVC, favoriteStreamListVC, gameListVC, genreListVC].map({UINavigationController(rootViewController: $0)})
        controllers.forEach({ $0.isNavigationBarHidden = true })
        tabBarController = window!.rootViewController as? UITabBarController
        tabBarController.setViewControllers(controllers, animated: false)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let stream = getStream(from: url) {
            Logger.info(stream)
            SharedComponents.router.openFavoriteStream(stream)
        }
        return true
    }
    
    fileprivate func getStream(from url: URL) -> Stream? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let encodedStr = components.queryItems?.first(where: { $0.name == Appex.streamQueryItemName })?.value,
            let data = encodedStr.data(using: .utf8) else {
            return nil
        }
        guard let ggStream = try? JSONDecoder().decode(GoodGame.Stream.self, from: data) else {
            return nil
        }
        let stream = Stream(goodgameStream: ggStream)
        return stream
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

