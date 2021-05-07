//
//  AppDelegate.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import UIKit
import CoreData
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerBackgroundTask()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Babel_skills_test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.lotuslabs.weatherDataRefreshIdentifier", using: .main) { (taks) in
            guard let task = taks as? BGAppRefreshTask else { return }
            self.handleAppRefreshTask(task: task)
        }
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        let viewModel = ViewModel(service: WeatherService())
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        viewModel.getWeatherData {
            task.setTaskCompleted(success: true)
        }
        scheduleBackgroundWeatherFetch()
    }
    
    func scheduleBackgroundWeatherFetch() {
        let weatherFetchTask = BGAppRefreshTaskRequest(identifier: "com.lotuslabs.weatherDataRefreshIdentifier")
        weatherFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(weatherFetchTask)
            debugPrint("Submit background task")
        } catch {
            debugPrint("Unable to submit task: \(error.localizedDescription)")
        }
    }
}

