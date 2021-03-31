//
//  MapViewController.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import UIKit
import Combine

class MapViewController: UIViewController {
    
    let model: MapViewModel
    var set: Set<AnyCancellable> = []
    init(model: MapViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.insertContainer
            .sink { [weak self] inView in
                self?.view.addSubview(inView)
                self?.view.sendSubviewToBack(inView)
                self?.view.addFullscreenConstraints(for: inView)
            }
            .store(in: &set)
        
        model.isLoading
            .sink { [weak self] isLoading in        
                if isLoading {
                    let activityIndicator = UIActivityIndicatorView()
                    activityIndicator.startAnimating()
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
                } else {
                    let activityIndicator = UIActivityIndicatorView()
                    activityIndicator.startAnimating()
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(MapViewController.reload))
                }
            }
            .store(in: &set)

        model.viewLoaded()
    }
    
    @objc func reload() {
        model.reloadAction.send()
    }
}
