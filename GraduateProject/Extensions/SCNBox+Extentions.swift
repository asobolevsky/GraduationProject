//
//  File.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-26.
//

import SceneKit

typealias SCNBoundingBox = (min: SCNVector3, max: SCNVector3)

extension SCNBox {
    convenience init(boundingBox: SCNBoundingBox) {
        let width = CGFloat(boundingBox.max.x - boundingBox.min.x)
        let height = CGFloat(boundingBox.max.y - boundingBox.min.y)
        let length = CGFloat(boundingBox.max.z - boundingBox.min.z)
        self.init(width: width, height: height, length: length, chamferRadius: 0)
    }
}
