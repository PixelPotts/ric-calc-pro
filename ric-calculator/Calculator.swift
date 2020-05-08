//
//  Calculator.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/8/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//

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
    public var total: Int32
    
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
        self.total = Int32(0)
    }
}
