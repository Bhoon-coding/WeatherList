//
//  SceneDelegate.swift
//  WeatherList
//
//  Created by BH on 2022/09/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainViewController(viewModel: MainViewModel(weatherService: WeatherService()))
        window.makeKeyAndVisible()
        self.window = window
    }

}

