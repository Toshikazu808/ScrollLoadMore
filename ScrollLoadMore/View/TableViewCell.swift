//
//  TableViewCell.swift
//  ScrollLoadMore
//
//  Created by Ryan Kanno on 9/23/21.
//

import UIKit

class TableViewCell: UITableViewCell {
   static let id = "TableViewCell"
   static let preferredHeight: CGFloat = 75
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var ageLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(person: Person) {
      nameLabel.text = person.name
      ageLabel.text = person.age
   }
}
