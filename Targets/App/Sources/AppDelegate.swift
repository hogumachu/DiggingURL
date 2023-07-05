import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        setupFirebase()
        return true
    }

}

extension AppDelegate {
    
    private func setupFirebase() {
        let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        guard let path = plistPath,
              let optios = FirebaseOptions(contentsOfFile: path)
        else {
            print("ERROR - Can't find GoogleService-Info.plist File")
            return
        }
        FirebaseApp.configure(options: optios)
    }
    
}
