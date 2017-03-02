//
//  UserInfoViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/28/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit

class UserInfoViewController {

    var name: String?
    var userProfilePic: String?
    var userEmail: String?
    var userName: String?
    var userUid: String?
    var additionalProfileInfo: String?
    
    init(passedName: String, passedUserProfilePic: String, passedEmail: String, passedUserName: String, passedUid: String, passedAdditionalProfileInfo: String) {
        self.name = passedName
        self.userProfilePic = passedUserProfilePic
        self.userEmail = passedEmail
        self.userUid = passedUid
        self.additionalProfileInfo = passedAdditionalProfileInfo
    }
}
