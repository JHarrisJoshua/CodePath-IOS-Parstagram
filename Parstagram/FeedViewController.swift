//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Joshua Harris on 10/21/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var numberofPhotos: Int!
    
    
    let myRefreshControl = UIRefreshControl()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 400
        
        numberofPhotos = 20
        loadPhotos()
        
        myRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        
    }
    
    func loadPhotos() {
        if numberofPhotos == nil {
            numberofPhotos = 20
        }
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberofPhotos
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts.removeAll()
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    //override func viewDidAppear(_ animated: Bool) {
    //    super.viewDidAppear(animated)
    //
    //    if numberofPhotos == nil {
    //        numberofPhotos = 20
    //    }
        
    //    let query = PFQuery(className: "Posts")
    //    query.includeKey("author")
    //    query.limit = numberofPhotos
    //    query.findObjectsInBackground { (posts, error) in
    //        if posts != nil {
    //            self.posts = posts!
    //            self.tableView.reloadData()
    //        }
    //    }

        
    //}
    
    func loadMorePhotos() {
        
        numberofPhotos = numberofPhotos + 20
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberofPhotos
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts.removeAll()
                self.posts = posts!
                self.tableView.reloadData()
        self.tableView.reloadData()
        
    }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = self.posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }
    
   @objc func onRefresh() {
        self.numberofPhotos = 20
        self.loadPhotos()
        self.tableView.reloadData()
        self.myRefreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count {
            loadMorePhotos()
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func onLogoutButton(_ sender: Any) {

        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
    }
    
    
    
    
}
