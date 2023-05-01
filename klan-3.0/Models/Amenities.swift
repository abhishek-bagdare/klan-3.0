//
//  Amenities.swift
//  klan-3.0
//
//  Created by Abhishek Bagdare on 4/26/23.
//

import Foundation

public class Amenities {
    private var _isHeatIncluded: Bool
    private var _isGasIncluded: Bool
    private var _isElectricityIncluded: Bool
    private var _isWifiIncluded: Bool
    private var _arePetsAllowed: Bool
    private var _isParkingIncluded: Bool
    
    public init(isHeatIncluded: Bool, isGasIncluded: Bool, isElectricityIncluded: Bool, isWifiIncluded: Bool, arePetsAllowed: Bool, isParkingIncluded: Bool) {
        _isHeatIncluded = isHeatIncluded
        _isGasIncluded = isGasIncluded
        _isElectricityIncluded = isElectricityIncluded
        _isWifiIncluded = isWifiIncluded
        _arePetsAllowed = arePetsAllowed
        _isParkingIncluded = isParkingIncluded
    }
    
    public var isHeatIncluded: Bool {
        get {
            return _isHeatIncluded
        }
        set {
            _isHeatIncluded = newValue
        }
    }
    
    public var isGasIncluded: Bool {
        get {
            return _isGasIncluded
        }
        set {
            _isGasIncluded = newValue
        }
    }
    
    public var isElectricityIncluded: Bool {
        get {
            return _isElectricityIncluded
        }
        set {
            _isElectricityIncluded = newValue
        }
    }
    
    public var isWifiIncluded: Bool {
        get {
            return _isWifiIncluded
        }
        set {
            _isWifiIncluded = newValue
        }
    }
    
    public var arePetsAllowed: Bool {
        get {
            return _arePetsAllowed
        }
        set {
            _arePetsAllowed = newValue
        }
    }
    
    public var isParkingIncluded: Bool {
        get {
            return _isParkingIncluded
        }
        set {
            _isParkingIncluded = newValue
        }
    }
}
