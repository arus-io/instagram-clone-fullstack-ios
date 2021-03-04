//
//  PostViewModel.swift
//  Collect
//
//  Created by Patrick Ortell on 2/2/21.
//

import Foundation

struct PostViewModel {
    
    let post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var userProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var username: String {
        return post.ownerUserName
    }
    
    var caption: String {
        return post.caption
    }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
        
    }
    
    var likes: Int {
        return post.likes
    }
    
    init(post: Post) {
        self.post = post
        
    }
    
}
