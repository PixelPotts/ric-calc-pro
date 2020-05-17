//
//  Calculator.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/8/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//
import UIKit

class Calculator {
    private var hasInstall = true
    private var hasTearout = true
    private var hasMaterial = true
    private var sqFtToInstall = Int16()
    private var sqFtOfTearout = Int16()
    private var yearHomeBuilt = Int16()
    private var materialCost = Double()
    private var installMaterial = "" // enum
    private var tearoutMaterial = "" // enum
    public var total: Double
    
    init(
        hasInstall: Bool,
        hasTearout: Bool,
        hasMaterial: Bool,
        sqFtToInstall: String,
        sqFtOfTearout: String,
        yearHomeBuilt: String,
        materialCost: String,
        installMaterial: String,
        tearoutMaterial: String
    ){
        self.hasInstall = hasInstall
        self.hasTearout = hasTearout
        self.hasMaterial = hasMaterial
        self.sqFtToInstall = Int16(sqFtToInstall) ?? 0
        self.sqFtOfTearout = Int16(sqFtOfTearout) ?? 0
        self.yearHomeBuilt = Int16(yearHomeBuilt) ?? 0
        self.materialCost = Double(materialCost) ?? 0.0
        self.installMaterial = installMaterial
        self.tearoutMaterial = tearoutMaterial
        self.total = Double(0)
    }
    
    func getInstallMaterialTypePrice() -> Double {
        switch self.installMaterial {
            case "NAILED":      return 2.95
            case "GLUED":       return 4.00
            case "FLOATING":    return 1.95
            case "TILED":       return 8.00
            case "CARPETED":    return 1.20
            default:            return 3.62 // average of all costs in fallthrough exception
        }
    }
    
    func getInstallTotal() -> Double {
        var t = getInstallMaterialTypePrice() * Double(self.sqFtToInstall)
        if(t < 800.0) {
            t = 800.0
        }
        return t
    }
    
    func getSubfloorPrepFee() -> Double {
        let rate = self.yearHomeBuilt < 1980 ? 300.0 : 230.0
        let t = rate * Double(self.sqFtToInstall) / 600.0
        return t < 250.0 ? 250.0 : t
    }
    
    func getFormattedTotal() -> String {
        _ = self.getTotal()
        let total = NSNumber(value: self.total)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: total) ?? "0.00"
    }
    
    func getTotal() -> Double {
        var total = Double(0)
        total += self.materialCost * Double(self.sqFtToInstall) // material fee
        total += 0.33 * 1.90 * Double(self.sqFtToInstall) // trim fee
        total += getInstallTotal() // install fee
        total += 0.33 * 1.50 * Double(self.sqFtToInstall) // uhh-not-sure fee
        total += getSubfloorPrepFee() // subfloor prep fee
        total += self.yearHomeBuilt < 1980 ? 180.0 : 0.0 // lead test fee
        total += total * 0.07 // sales tax
        self.total = total
        return Double(self.total)
    }
}
