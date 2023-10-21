//  CoachCrowe
/// Created by nor
/// This one for `CR7` ❤

import SwiftUI
import LeanCloud

@main
struct CoachCroweApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MasterView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions : [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LCApplication.logLevel = .off
        do {
            try LCApplication.default.set (
                id: Keys.lcAppID,
                key: Keys.lcAppKey,
                serverURL: Keys.lcServerURL
            )
        } catch {
            fatalError("\(error)")
        }
        
        return true
    }
}
