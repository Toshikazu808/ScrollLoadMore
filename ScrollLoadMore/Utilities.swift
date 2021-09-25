//
//  Utilities.swift
//  ScrollLoadMore
//
//  Created by Ryan Kanno on 9/24/21.
//

import Foundation
import Firebase

struct Utilities {
   static func convertDocument(snapshot: QuerySnapshot) -> Person {
      var person = Person(name: "", id: "", age: "", number: "")
      snapshot.documents.forEach { doc in
         let data = doc.data() as! [String: String]
         person = convertToStruct(data)
      }
      return person
   }
   
   static func convertToStruct(_ data: [String: String]) -> Person {
      let converted = Person(
         name: data["name"] ?? "name unavailable",
         id: data["id"] ?? "id unavailable",
         age: data["age"] ?? "age unavailable",
         number: data["number"] ?? "number unavailable")
      return converted
   }
   
   static func generateDummyData() {
      guard let anonymous = Auth.auth().currentUser?.uid else { return }
      let db = Firestore.firestore()
      let group = DispatchGroup()
      for i in 0..<200 {
         let uuid = UUID().uuidString
         let user = createUser(index: i, id: uuid)
         group.enter()
         db.collection(anonymous).document(uuid).setData(user) { error in
            if let error = error {
               print("Error creating dummy data: \(error)")
            } else {
               print("Successfully created dummy user.")
               group.leave()
            }
         }
      }
      group.notify(queue: .main) {
         print("Dummy users greated successfully")
      }
   }
   
   private static func createUser(index: Int, id: String) -> [String: String] {
      let user = [
         "id": id,
         "name": getRandomName(),
         "age": "\(Int.random(in: 18...65))",
         "number": "\(index)"
      ]
      return user
   }
   
   private static func getRandomName() -> String {
      let names = ["Bob", "Joe", "Harry", "Lynn", "Cary", "Julie", "Adam", "Sara", "Jim", "Molly"]
      let random = Int.random(in: 0..<names.count)
      return names[random]
   }
}
