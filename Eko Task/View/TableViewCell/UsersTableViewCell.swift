//
//  UsersTableViewCell.swift
//  Eko Task
//
//  Created by apple on 12/16/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import UIKit

protocol UsersCellDelegate : class {
    func didPressFavouriteButton(cell: UsersTableViewCell)
}

class UsersTableViewCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var adminStatusLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var usersCellDelegate: UsersCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.usersCellDelegate = nil
    }
    
    @IBAction func favouriteButtonPressed(sender: UIButton){
        self.usersCellDelegate?.didPressFavouriteButton(cell: self)
    }
}
