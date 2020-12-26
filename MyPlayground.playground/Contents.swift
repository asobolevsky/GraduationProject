import UIKit
import SceneKit
import PlaygroundSupport


let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 600, height: 300))
sceneView.allowsCameraControl = true
sceneView.backgroundColor = .lightGray

let scene = SCNScene()
sceneView.scene = scene

let turrelNode = SCNNode()
turrelNode.position = SCNVector3(0, -0.2, -0.5)
scene.rootNode.addChildNode(turrelNode)

var yOffset: Float = 0

// Base
let baseGeometry = SCNCylinder(radius: 0.15, height: 0.02)
yOffset += Float(baseGeometry.height / 2)
baseGeometry.firstMaterial?.diffuse.contents = UIColor.systemRed
let baseNode = SCNNode(geometry: baseGeometry)
baseNode.position += SCNVector3(0, yOffset, 0)
yOffset += Float(baseGeometry.height / 2)
turrelNode.addChildNode(baseNode)

// Leg
let legFeometry = SCNCylinder(radius: 0.03, height: 0.1)
yOffset += Float(legFeometry.height / 2)
legFeometry.firstMaterial?.diffuse.contents = UIColor.systemGray
let legNode = SCNNode(geometry: legFeometry)
legNode.position += SCNVector3(0, yOffset, 0)
yOffset += Float(legFeometry.height / 2)
turrelNode.addChildNode(legNode)

// Tower
let towerFeometry = SCNBox(width: 0.2, height: 0.08, length: 0.2, chamferRadius: 0)
yOffset += Float(towerFeometry.height / 2)
towerFeometry.firstMaterial?.diffuse.contents = UIColor.systemPink
let towerNode = SCNNode(geometry: towerFeometry)
towerNode.position += SCNVector3(0, yOffset, 0)
yOffset += Float(towerFeometry.height / 2)
turrelNode.addChildNode(towerNode)

// Barrels
var xBarrelOffset = Float(towerFeometry.width / 2)
let barrelGeometry = SCNCylinder(radius: 0.01, height: 0.1)
xBarrelOffset += Float(barrelGeometry.height / 2)
barrelGeometry.firstMaterial?.diffuse.contents = UIColor.systemGray3.withAlphaComponent(0.5)

let leftBarrelNode = SCNNode(geometry: barrelGeometry)
leftBarrelNode.eulerAngles = SCNVector3(0, 0, -Float.pi / 2)
leftBarrelNode.position += SCNVector3(xBarrelOffset, 0, -Float(towerFeometry.length / 4))
towerNode.addChildNode(leftBarrelNode)

let rightBarrelNode = leftBarrelNode.clone()
leftBarrelNode.position += SCNVector3(0, 0, Float(towerFeometry.length / 2))
towerNode.addChildNode(rightBarrelNode)

var leftBarrelSpawnLocation = SCNVector3(0, Float(barrelGeometry.height / 2), 0)
leftBarrelSpawnLocation = leftBarrelNode.convertPosition(leftBarrelSpawnLocation, to: turrelNode)

var rightBarrelSpawnLocation = SCNVector3(0, Float(barrelGeometry.height / 2), 0)
rightBarrelSpawnLocation = rightBarrelNode.convertPosition(rightBarrelSpawnLocation, to: turrelNode)

let spawnLocations: [SCNVector3] = [leftBarrelSpawnLocation, rightBarrelSpawnLocation]


let bullet = SCNSphere(radius: 0.005)
bullet.firstMaterial?.diffuse.contents = UIColor.systemRed
let bulletNode = SCNNode(geometry: bullet)
bulletNode.position = leftBarrelSpawnLocation
turrelNode.addChildNode(bulletNode)

let bulletCopy = bulletNode.clone()
bulletNode.position = rightBarrelSpawnLocation
turrelNode.addChildNode(bulletCopy)

turrelNode.pivot = SCNMatrix4MakeTranslation(0, yOffset / 2, 0)



PlaygroundPage.current.liveView = sceneView





extension SCNVector3 {
    static func += (_ lhs: inout SCNVector3, _ rhs: SCNVector3) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
}
