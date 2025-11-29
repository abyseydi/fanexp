import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialiser Firebase
    FirebaseApp.configure()
    
    // Configuration des notifications pour iOS 10+
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { granted, error in
          if granted {
            print("✅ Permissions de notification accordées")
          } else {
            print("❌ Permissions de notification refusées")
          }
        }
      )
    } else {
      // iOS 9 et antérieur
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    // Enregistrer pour les notifications à distance
    application.registerForRemoteNotifications()
    
    // Enregistrer les plugins Flutter
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Gérer l'enregistrement réussi du token APNs
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Passer le token APNs à Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
    
    // Appeler la méthode parent
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // Gérer l'échec de l'enregistrement
  override func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("❌ Échec de l'enregistrement pour les notifications: \(error.localizedDescription)")
  }
  
  // Gérer la réception de notifications en arrière-plan (iOS 10+)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print("📨 Notification reçue au premier plan: \(userInfo)")
    
    // Afficher la notification même au premier plan
    if #available(iOS 14.0, *) {
      completionHandler([[.banner, .badge, .sound]])
    } else {
      completionHandler([[.alert, .badge, .sound]])
    }
  }
  
  // Gérer le tap sur une notification (iOS 10+)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print("👆 Notification tapée: \(userInfo)")
    
    completionHandler()
  }
}