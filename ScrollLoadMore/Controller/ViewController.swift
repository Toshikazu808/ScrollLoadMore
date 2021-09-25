//
//  ViewController.swift
//  ScrollLoadMore
//
//  Created by Ryan Kanno on 9/23/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {
   
   @IBOutlet weak var tableView: UITableView!
   private var numLoaded = 20
   private let db = Firestore.firestore()
   private var data: [Person] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupTableView()
//      Utilities.generateDummyData()
      loadData()
   }
   
   private func setupTableView() {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: TableViewCell.id, bundle: nil), forCellReuseIdentifier: TableViewCell.id)
   }
   
   private func loadData() {
      guard let anonymous = Auth.auth().currentUser?.uid else { return }
      let group = DispatchGroup()
      for i in 0..<numLoaded {
         group.enter()
         db.collection(anonymous).whereField("number", isEqualTo: "\(i)").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
               print("Error getting document: \(error)")
            } else if let snapshot = snapshot {
               let person = Utilities.convertDocument(snapshot: snapshot)
               self.data.append(person)
               group.leave()
            }
         }
      }
      group.notify(queue: .main) { [weak self] in
         self?.tableView.reloadData()
      }
   }
}

extension ViewController: UITableViewDelegate , UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return data.count
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return TableViewCell.preferredHeight
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
      cell.configure(person: data[indexPath.row])
      return cell
   }
}
