//
//  FacilityPinInfo.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/24/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit

class FacilityPinInfo {
    var addedDate: Double?
    var additionalFacilityInfo: String?
    var city: String?
    var facilityPhoto: String?
    var lat: Double?
    var long: Double?
    var name: String?
    var state: String?
    var streetAddress: String?
    var userIDPostingThis: String?
    var zip: String?
    var facilityUid: String?
    
    init(passedAddedDate: Double, passedAdditionalFacilityInfo: String, passedCity: String, passedFacilityPhoto: String, passedLat: Double, passedLong: Double, passedName: String, passedState: String, passedStreetAddress: String, passedUserIDPostingThis: String, passedZip: String, passedFacilityUid: String){

        self.addedDate = passedAddedDate
        self.additionalFacilityInfo = passedAdditionalFacilityInfo
        self.city = passedCity
        self.facilityPhoto = passedFacilityPhoto
        self.lat = passedLat
        self.long = passedLong
        self.name = passedName
        self.state = passedState
        self.streetAddress = passedStreetAddress
        self.userIDPostingThis = passedUserIDPostingThis
        self.zip = passedZip
        self.facilityUid = passedFacilityUid
    }
}
