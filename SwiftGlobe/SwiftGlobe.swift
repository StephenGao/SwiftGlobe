//
//  SwiftGlobe.swift
//  SwiftGlobe
//
//  Created by David Mojdehi on 4/6/17.
//  Copyright © 2017 David Mojdehi. All rights reserved.
//

import Foundation

import SceneKit

let kGlobeRadius = 5.0
let kTiltOfEarthsAxisInDegrees = 23.5

class SwiftGlobe {
    
    
    var scene = SCNScene()
    var camera = SCNCamera()
    var cameraNode = SCNNode()
    var globe = SCNNode()

    init() {
        // make the globe
        let globeShape = SCNSphere(radius: CGFloat(kGlobeRadius) )
        globeShape.segmentCount = 30
        globeShape.firstMaterial!.diffuse.contents = "world2700x1350.jpg" //earth-diffuse.jpg"
        //globeShape.firstMaterial!.specular.contents = "earth_lights.jpg"
        globeShape.firstMaterial!.specular.contents = "earth-specular.jpg"
        globeShape.firstMaterial!.specular.intensity = 0.2
        //globeShape.firstMaterial!.shininess = 0.1
        
        globeShape.firstMaterial!.metalness.contents = "metalness-1000x500.png"
        globeShape.firstMaterial!.roughness.contents = "roughness-1000x500.png"
        
        //globeShape.firstMaterial!.reflective.contents = "envmap.jpg"
        //globeShape.firstMaterial!.reflective.intensity = 0.5
        globeShape.firstMaterial!.fresnelExponent = 2
        
        // tilt it on it's axis (23.5 degrees)
        #if os(iOS)
            let tiltInRadians = Float( kTiltOfEarthsAxisInDegrees  * M_PI / 180 )
        #elseif os(OSX)
            let tiltInRadians = CGFloat( kTiltOfEarthsAxisInDegrees  * Double.pi / 180 )
        #endif
        globe.eulerAngles = SCNVector3(x: tiltInRadians, y: 0, z: 0)
        
        
        // add the galaxy skybox
        scene.background.contents = "eso0932a-milkyway360-dimmed"
        scene.background.intensity = 0.01
        
        globe.geometry = globeShape
        scene.rootNode.addChildNode(globe)
        
        // create and add a camera to the scene
        // configure the camera itself
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 9
        camera.zNear = 0
        camera.zFar = 100
        // its node (so it can live in the scene)
        #if os(iOS)
            cameraNode.position = SCNVector3(x: 0, y: 0, z:  Float( kGlobeRadius * 2.0)  )
        #elseif os(OSX)
            // uggh; MacOS uses CGFloat instad of float :-(
            cameraNode.position = SCNVector3(x: 0, y: 0, z:  CGFloat( kGlobeRadius * 2.0)  )
        #endif
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
    
    }
    
    
}
