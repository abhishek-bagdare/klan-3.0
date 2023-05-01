//
//  Post.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//

import Foundation

class Post {
    private var _postID: Int
    private var _postedBy: User
    private var _apartment: Apartment
    private var _postedDate: Date
    
    var postID: Int {
        get {
            return _postID
        }
        set(newPostID) {
            _postID = newPostID
        }
    }
    
    var postedBy: User {
        get {
            return _postedBy
        }
        set(newPostedBy) {
            _postedBy = newPostedBy
        }
    }
    
    var apartment: Apartment {
        get {
            return _apartment
        }
        set(newApartment) {
            _apartment = newApartment
        }
    }
    
    var postedDate: Date {
        get {
            return _postedDate
        }
        set(newPostedDate) {
            _postedDate = newPostedDate
        }
    }
    
    init(postID: Int, postedBy: User, apartment: Apartment, postedDate: Date) {
        _postID = postID
        _postedBy = postedBy
        _apartment = apartment
        _postedDate = postedDate
    }
}
