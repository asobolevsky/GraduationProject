//
//  SCNVector3+Extensions.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-24.
//

import SceneKit

extension SCNVector3 {
    static func - (_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
    static func + (_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func / (_ lhs: SCNVector3, _ rhs: Float) -> SCNVector3 {
        return SCNVector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
    }
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    func median(to other: SCNVector3) -> SCNVector3 {
        return (other + self) / 2
    }
}
