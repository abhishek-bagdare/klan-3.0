//
//  Apartment.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//

import Foundation
import Firebase

enum ApartmentType: String {
    case Condo
    case Townhouse
    case Apartment
}

public class Apartment : Identifiable {
    private var _apartmentID: Int
    private var _availableDate: Date
    private var _isOnMarket: Bool
    private var _rent: Int
    private var _apartmentAmenities: Amenities
    private var _apartmentAddress: Address
    private var _postedBy : User
    var _timeStamp : Timestamp
     var image : String
//    private var _numberOfBedrooms : Int
//    private var _numberOfBathrooms : Int
//    private var _apartmentType : String
    //add images
    
    public init(apartmentID: Int, availableDate: Date, isOnMarket: Bool, rent: Int, apartmentAmenities: Amenities, apartmentAddress: Address,postedBy : User,image : String, timestamp:Timestamp) {
        self._apartmentID = apartmentID
        self._availableDate = availableDate
        self._isOnMarket = isOnMarket
        self._rent = rent
        self._apartmentAmenities = apartmentAmenities
        self._apartmentAddress = apartmentAddress
        self._postedBy = postedBy
        self.image = image
        self._timeStamp = timestamp
    }
    
    // Getter and Setter for apartmentID
    public var apartmentID: Int {
        get {
            return _apartmentID
        }
        set {
            _apartmentID = newValue
        }
    }
    public var postedBy: User {
        get {
            return _postedBy
        }
        set {
            _postedBy = newValue
        }
    }
    
    
    // Getter and Setter for availableDate
    public var availableDate: Date {
        get {
            return _availableDate
        }
        set {
            _availableDate = newValue
        }
    }
    
    // Getter and Setter for isOnMarket
    public var isOnMarket: Bool {
        get {
            return _isOnMarket
        }
        set {
            _isOnMarket = newValue
        }
    }
    
    // Getter and Setter for rent
    public var rent: Int {
        get {
            return _rent
        }
        set {
            _rent = newValue
        }
    }
    
    // Getter and Setter for apartmentAmenities
    public var apartmentAmenities: Amenities {
        get {
            return _apartmentAmenities
        }
        set {
            _apartmentAmenities = newValue
        }
    }
    
    // Getter and Setter for apartmentAddress
    public var apartmentAddress: Address {
        get {
            return _apartmentAddress
        }
        set {
            _apartmentAddress = newValue
        }
    }
}
