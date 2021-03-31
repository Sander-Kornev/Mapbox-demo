//
//  MapBoxViewModel.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import Combine
import Mapbox

class MapBoxViewModel: NSObject {
    
    var view: UIView {
        mapView
    }
    
    lazy private var mapView: MGLMapView = {
       
        let mapView = MGLMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()
    
    var annotations: CurrentValueSubject<[MapPoi], Never> = .init([])
    var selectedAnnotation: PassthroughSubject<MapPoi, Never> = .init()
    
    private var annotationsInfo: CurrentValueSubject<[String: [MapPoi]], Never> = .init([:])
    var set: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        
        annotations
            .filter { $0.isEmpty == false }
            .map {
                Array($0.filter { $0.type == "SimplePoi" }.map { $0.mapAnnotation })
            }
            .sink { [weak self] in
                self?.mapView.addAnnotations($0)
                self?.mapView.showAnnotations($0, animated: true)
            }
            .store(in: &set)
        
        annotations
            .filter { $0.isEmpty == false }
            .map {
                Dictionary(grouping: $0, by: { String($0.id) })
            }
            .subscribe(annotationsInfo)
            .store(in: &set)
        
        annotations
            .filter { $0.isEmpty == true }
            .sink { [weak self] _  in
                self?.mapView.removeAnnotations((self?.mapView.annotations).orEmpty)
            }
            .store(in: &set)
    }
}

extension MapBoxViewModel: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if let id = annotation.subtitle, let mapPoi = annotationsInfo.value[id.orEmpty]?.first {
            selectedAnnotation(mapPoi)
        }
    }
}
