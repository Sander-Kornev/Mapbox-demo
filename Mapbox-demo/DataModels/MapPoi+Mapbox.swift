//
//  MapPoi+Mapbox.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import Mapbox

extension MapPoi {
    
    var coordinate: CLLocationCoordinate2D {
        position.count > 1
            ? .init(latitude: position[1], longitude: position[0])
            : kCLLocationCoordinate2DInvalid
    }
    
    var mapAnnotation: MGLPointAnnotation {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.subtitle = String(id)
        return annotation
    }
}
