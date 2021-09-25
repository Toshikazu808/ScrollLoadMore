//
//  AppDelegate.swift
//  ScrollLoadMore
//
//  Created by Ryan Kanno on 9/23/21.
//

import UIKit
import Firebase
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   static let email = "anonymous1@email.com"
   static let pw = "anonymous123"
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
//      checkForUser()
      anonymousLogin()
      return true
   }

   // MARK: UISceneSession Lifecycle

   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      // Called when a new scene session is being created.
      // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }

   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      // Called when the user discards a scene session.
      // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
      // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }
   
   private func checkForUser() {
      if Auth.auth().currentUser != nil {
         do {
            try Auth.auth().signOut()
         } catch {
            print("Error signing out user: \(error)")
         }
      }
   }
   
   private func anonymousLogin() {
      if Auth.auth().currentUser != nil {
         print("Anonymous user already logged in.")
//         Utilities.generateDummyData()
      } else {
         print("Loggining in anonymous user.")
         Auth.auth().signIn(withEmail: AppDelegate.email, password: AppDelegate.pw) { [weak self] _, error in
            if let error = error {
               print("Error logging in anonymous user: \(error)")
               self?.createAnonymousUser()
            } else {
               print("Anonymous user logged in successfully.")
            }
         }
      }
   }
   
   private func createAnonymousUser() {
      Auth.auth().createUser(withEmail: AppDelegate.email, password: AppDelegate.pw) { _, error in
         if let error = error {
            print("Error creating anonymous user: \(error)")
         } else {
            print("Anonymous user created successfully.")
            Utilities.generateDummyData()
         }
      }
   }
}

