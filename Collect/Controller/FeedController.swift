//
//  FeedController.swift
//  Collect
//
//  Created by Patrick Ortell on 1/22/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    private var posts = [Post]()
    var post: Post?
    
    // MARK --Lifecycle
     override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    //MARK: -- Actions
    @objc func handleRefresh(){
        posts.removeAll()
        fetchPosts()
        
    }
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("Error: failed to logout")
        }
    }
    //MARK -- API
    func fetchPosts(){
        guard post == nil else { return }
        
        PostService.fetchPosts { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK --Helpers
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                          style: .plain,
                                                          target:self,
                                                          action: #selector(handleLogout))
        }
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
}

//MARK UI Collection view data src

extension FeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ?  posts.count : 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
}
// MARK: --UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
}
