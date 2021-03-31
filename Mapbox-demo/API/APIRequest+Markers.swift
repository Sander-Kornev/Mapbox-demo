//
//  APIRequest+Markers.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation

extension APIDecodableRequest {
    
    static var markers: APIDecodableRequest<[MapPoi]> {
        let request: APIDecodableRequest<[MapPoi]> = .GET()
        request.urlAdditionalPath = "features.json"
        request.getParameters = ["app_mode": "swh-mein-halle-mobil"]
        return request
    }
}
