//
//  MapPoi.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation

struct MapPoi: Codable {
    var id: Int
    var icon: String?
    var title: String?
    var titleEn: String?
    var description: String?
    var descriptionEn: String?
    var subtitle: String?
    var subtitleEn: String?
    var position: [Double]
    var type: String?
}
