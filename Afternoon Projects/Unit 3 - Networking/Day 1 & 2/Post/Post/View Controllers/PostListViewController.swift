//
//  PostViewController.swift
//  Post
//
//  Created by Kevin Tanner on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    // MARK: - Properties
    var postController = PostController()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        
        postController.fetchPosts {
            self.reloadTableView()
        }
        
        tableViewOutlet.estimatedRowHeight = 45
        tableViewOutlet.rowHeight = UITableView.automaticDimension
        
        tableViewOutlet.refreshControl = refreshControl
        
        
    }
    
    // MARK: - Actions
    @IBAction func addNewPostButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    
    
    // MARK: - Custom Methods
    @objc func refreshControlPulled() {
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        postController.fetchPosts {
            DispatchQueue.main.async {
                self.reloadTableView()
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableViewOutlet.reloadData()
        }
    }
    
    func presentNewPostAlert() {
        
        let alertController = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "usernameTextField"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "messageTextField"
        }
        
//        guard let usernameTextField = alertController.textFields?[0].text, let messageTextField = alertController.textFields?[1].text else { return }
        
//        guard (alertController.textFields?[0]) != nil, (alertController.textFields?[1] != nil) else { return }
        
        
        alertController.addAction(UIAlertAction(title: "Post", style: .default, handler: { (UIAlertAction) in
            
            guard let usernameTextField = alertController.textFields?[0].text,
//                let usernameInputText =
                !usernameTextField.isEmpty,
                let messageTextField = alertController.textFields?[1].text,
                !messageTextField.isEmpty else {
                    
                    self.presentErrorAlert()
                    return
            }
            
            self.postController.addNewPostWith(username: usernameTextField, text: messageTextField, completion: {
                    self.reloadTableView()
            })
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Missing Info", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
} // End of Class

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username
        
        return cell
        
    }
}
