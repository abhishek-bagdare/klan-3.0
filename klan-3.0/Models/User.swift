//
//  User.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//

import Foundation


//add enum for userType

public class User {
    private var _userID: Int
    private var _userName: String
    private var _passWord: String
    private var _email: String
    private var _contact: String
    private var _isActive: Bool
     var pic : String
    //userType
    //add profile photo
    //chat,conversation how to setup
    
    
    public init(userID: Int, userName: String, passWord: String, email: String, contact: String, isActive: Bool, pic:String) {
        self._userID = userID
        self._userName = userName
        self._passWord = passWord
        self._email = email
        self._contact = contact
        self._isActive = isActive
        self.pic = pic
    }
    
    // Getter and Setter for userID
    public var userID: Int {
        get {
            return _userID
        }
        set {
            _userID = newValue
        }
    }
    
    // Getter and Setter for userName
    public var userName: String {
        get {
            return _userName
        }
        set {
            _userName = newValue
        }
    }
    
    // Getter and Setter for passWord
    public var passWord: String {
        get {
            return _passWord
        }
        set {
            _passWord = newValue
        }
    }
    
    // Getter and Setter for email
    public var email: String {
        get {
            return _email
        }
        set {
            _email = newValue
        }
    }
    
    // Getter and Setter for contact
    public var contact: String {
        get {
            return _contact
        }
        set {
            _contact = newValue
        }
    }
    
    // Getter and Setter for isActive
    public var isActive: Bool {
        get {
            return _isActive
        }
        set {
            _isActive = newValue
        }
    }
}


