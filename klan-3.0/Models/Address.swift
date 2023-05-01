//
//  Address.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//

import Foundation

public class Address {
    private var _addressLine1: String
    private var _addressLine2: String
    private var _apartmentNumber: String
    private var _city: String
    private var _state: String
    private var _zipcode: Int
    private var _country: String
    
    public init(addressLine1: String, addressLine2: String, apartmentNumber: String, city: String, state: String, zipcode: Int, country: String) {
        _addressLine1 = addressLine1
        _addressLine2 = addressLine2
        _apartmentNumber = apartmentNumber
        _city = city
        _state = state
        _zipcode = zipcode
        _country = country
    }
    
    public var addressLine1: String {
        get {
            return _addressLine1
        }
        set {
            _addressLine1 = newValue
        }
    }
    
    public var addressLine2: String {
        get {
            return _addressLine2
        }
        set {
            _addressLine2 = newValue
        }
    }
    
    public var apartmentNumber: String {
        get {
            return _apartmentNumber
        }
        set {
            _apartmentNumber = newValue
        }
    }
    
    public var city: String {
        get {
            return _city
        }
        set {
            _city = newValue
        }
    }
    
    public var state: String {
        get {
            return _state
        }
        set {
            _state = newValue
        }
    }
    
    public var zipcode: Int {
        get {
            return _zipcode
        }
        set {
            _zipcode = newValue
        }
    }
    
    public var country: String {
        get {
            return _country
        }
        set {
            _country = newValue
        }
    }
}
