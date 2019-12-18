//
//  ViewController.swift
//  Eko Task
//
//  Created by apple on 12/16/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class HomeViewController: UIViewController, UsersCellDelegate {
    
    @IBOutlet weak var usersTableView: UITableView!
    var usersList: [AllUsers] = []
    var favorites : [String] = []
    var usersFrom = 0
    var usersApiURL = "https://api.github.com/users"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let favoritesDefaults : AnyObject = defaults.object(forKey: "favorites") as AnyObject? {
            favorites = favoritesDefaults as! [String]
        }
        getUsersList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsersList()
    }
    
    func didPressFavouriteButton(cell: UsersTableViewCell) {
        guard let indexPath = self.usersTableView.indexPath(for: cell) else {
            return
        }
        let defaults = UserDefaults.standard
        if let favoritesDefaults : AnyObject = defaults.object(forKey: "favorites") as AnyObject? {
            favorites = favoritesDefaults as! [String]
        }
        let userName = usersList[indexPath.row].login!
        if favorites.contains(userName) {
            favorites.removeAll { $0 == userName }
        }else{
            favorites.append(userName)
        }
        defaults.set(favorites, forKey: "favorites")
        defaults.synchronize()
        usersTableView.reloadData()
    }
    
    func getUsersList(){
        if Reachability.isConnectedToNetwork() == true {
            UsersWebService().getUsersList(controller: self, dataURL: usersApiURL, apiTitle: "All Users", view: self.view) { (data) in
                self.usersList.removeAll()
                self.usersList = data
                self.usersTableView.reloadData()
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoInternetViewController") as! NoInternetViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            loadMoreDown()
        }else if currentOffset < 0 {
            loadMoreUp()
        }
    }
    
    func loadMoreUp(){
        if usersFrom > 0 {
            usersFrom = usersFrom - 30
            usersApiURL = "https://api.github.com/users?since=\(usersFrom)"
            getUsersList()
        }
    }
    
    func loadMoreDown(){
        usersFrom = usersFrom + 30
        usersApiURL = "https://api.github.com/users?since=\(usersFrom)"
        getUsersList()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UsersTableViewCell
        let user = usersList[indexPath.row]
        cell.nameLabel.text = user.login
        cell.urlLabel.text = user.html_url
        cell.typeLabel.text = user.type
        cell.adminStatusLabel.text = "\(user.site_admin ?? false)"
        cell.profileImageView.sd_setImage(with: URL(string: user.avatar_url!), placeholderImage: UIImage(named: "profile-placeholder.png"))
        cell.usersCellDelegate = self
        
        let favoriteImage = #imageLiteral(resourceName: "ico-fav")
        cell.favoriteButton.setBackgroundImage(favoriteImage, for: .normal)
        if favorites.contains(user.login!) {
            cell.favoriteButton.tintColor = UIColor.red
        }else{
            cell.favoriteButton.tintColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.url = user.html_url!
        vc.title = user.login
        navigationController?.pushViewController(vc, animated: true)
    }
}
