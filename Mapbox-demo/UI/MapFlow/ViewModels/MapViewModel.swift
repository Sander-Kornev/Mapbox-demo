//
//  MapViewModel.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import Combine
import UIKit

class MapViewModel {
    
    var insertContainer: PassthroughSubject<UIView, Never> = .init()
    var viewLoaded: PassthroughSubject<Void, Never> = .init()
    
    var isLoading: PassthroughSubject<Bool, Never> = .init()
    var reloadAction: PassthroughSubject<Void, Never> = .init()
    
    let apiManager = APIManager()
    
    let mapViewModel = MapBoxViewModel()
    
    var mapPoiSelected: ((MapPoi) -> Void)?
    var set: Set<AnyCancellable> = []
    
    init() {
        
        viewLoaded
            .sink { [weak self] in
                self?.setupView()
                self?.setupMapActions()
            }
            .store(in: &set)    }
    
    func setupView() {
        insertContainer.send(mapViewModel.view)
    }
    
    func setupMapActions() {
        let mergedLoad = reloadAction
            .merge(with: Just(Void()))
            .makeConnectable()
        
        mergedLoad
            .flatMap { [unowned self] _ in
                markersPublisher
                    .catch { [weak self] _ -> Empty<[MapPoi], Never> in
                        self?.isLoading(false)
                        return Empty()
                    }
            }
            .sink { [weak self] annotations in
                self?.mapViewModel.annotations.send(annotations)
                self?.isLoading(false)
            }
            .store(in: &set)
        
        mergedLoad
            .map { true }
            .subscribe(isLoading)
            .store(in: &set)
        
        mergedLoad
            .connect()
            .store(in: &set)
        
        reloadAction
            .map { [] }
            .subscribe(mapViewModel.annotations)
            .store(in: &set)
        
        mapViewModel
            .selectedAnnotation
            .sink { [weak self] in self?.mapPoiSelected?($0) }
            .store(in: &set)
    }
}

// MARK: - API
extension MapViewModel {
    
    private var markersPublisher: AnyPublisher<[MapPoi], String> {
        apiManager
            .performRequest(
                APIDecodableRequest<[MapPoi]>.markers
            )
    }
}
