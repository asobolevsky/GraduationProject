//
//  SCNVector3+Extensions.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-24.
//

import SceneKit

extension SCNVector3 {
    static func - (_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
}
