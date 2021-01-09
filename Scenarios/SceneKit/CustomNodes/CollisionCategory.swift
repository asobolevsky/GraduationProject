//
//  CollisionCategory.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-26.
//

import Foundation

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let turrelProjectile     = CollisionCategory(rawValue: 1 << 0)
    static let mob                  = CollisionCategory(rawValue: 2 << 0)
}
