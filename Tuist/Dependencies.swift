//
//  Dependencies.swift
//  Config
//
//  Created by 홍성준 on 2023/06/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(TargetDependency.SPM.allCases.compactMap(\.package))
)
