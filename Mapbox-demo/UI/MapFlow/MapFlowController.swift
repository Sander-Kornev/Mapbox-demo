//
//  MapFlowController.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import UIKit
import SafariServices

class MapFlowController {
    
    var rootViewController: UIViewController {
        _navVC
    }
    
    private var _navVC: UINavigationController
    
    init() {
        let viewModel = MapViewModel()
        let vc = MapViewController(model: viewModel)
        
        let navVC = UINavigationController(rootViewController: vc)
        _navVC = navVC
        
        viewModel.mapPoiSelected = { [weak self] in self?.showDetails(mapPoi: $0) }
    }
    
    func showDetails(mapPoi: MapPoi) {
        let vc = MapPoiDetailsViewController(mapPoi: mapPoi)
        vc.openUrl = { [weak self] in self?.openUrl($0) }
        _navVC.present(vc, animated: true)
    }
    
    func openUrl(_ url: URL) {
        if ["http", "https"].contains(url.scheme.orEmpty) {
            let webView = SFSafariViewController(url: url)
            _navVC.presentedViewController?.present(webView, animated: true)
        } else {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
