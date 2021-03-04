//
//  Post.swift
//  Collect
//
//  Created by Patrick Ortell on 2/2/21.
//

import Firebase


struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postID: String
    
    let ownerImageUrl: String
    let ownerUserName: String
    
    init(postID: String, dictionary: [String: Any]){
        self.postID = postID
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUserName = dictionary["ownerUserName"] as? String ?? ""
//        self.postID = dictionary["postID"] as? String ?? ""
        
        
    }
    
    
}
