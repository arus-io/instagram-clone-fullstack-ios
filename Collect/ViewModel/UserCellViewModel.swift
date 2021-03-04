//
//  UserCellViewModel.swift
//  Collect
//
//  Created by Patrick Ortell on 1/30/21.
//

import Foundation


struct UserCellViewModel {
    private let user: User
    var profileImageUrl: URL? {
        return URL (string: user.profileImageUrl)
    }
    var username: String {
        return user.username
    }
    var uid: String {
        return user.uid
    }
    var fullname: String {
        return user.fullname
    }
    init(user: User){
        self.user = user
    }
}
