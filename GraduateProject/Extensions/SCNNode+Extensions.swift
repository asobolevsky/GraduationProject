//
//  SCNNode+Extensions.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-24.
//

import SceneKit

extension SCNNode {
    func distance(to node: SCNNode) -> Float {
        let node1Pos = presentation.worldPosition
        let node2Pos = node.presentation.worldPosition
        let distanceVector = node2Pos - node1Pos
        return distanceVector.length()
    }
}
