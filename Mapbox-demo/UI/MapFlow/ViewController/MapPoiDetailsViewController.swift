//
//  MapPoiDetailsViewController.swift
//  Mapbox-demo
//
//  Created by Sander on 31.03.2021.
//

import Foundation
import UIKit

class MapPoiDetailsViewController: UITableViewController {
    
    static let labelCellClassName = "SingleLabelTableViewCell"
    static let webCellClassName = "WebViewTableViewCell"
    
    enum CellType: Hashable {
        case title(String)
        case description(String)
    }
    
    private var datasource: UITableViewDiffableDataSource<String, CellType>!
    private let mapPoi: MapPoi
    private var webViewHeight: CGFloat = 1
    
    var openUrl: ((URL) -> Void)?
    
    init(mapPoi: MapPoi) {
        self.mapPoi = mapPoi
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: MapPoiDetailsViewController.labelCellClassName, bundle: nil), forCellReuseIdentifier: MapPoiDetailsViewController.labelCellClassName)
        tableView.register(UINib(nibName: MapPoiDetailsViewController.webCellClassName, bundle: nil), forCellReuseIdentifier: MapPoiDetailsViewController.webCellClassName)
        tableView.separatorStyle = .none
        
        datasource = UITableViewDiffableDataSource<String, CellType>(tableView: tableView) { [weak self] (tableView, indexPath, cellItem) -> UITableViewCell? in
            switch cellItem {
            case let .title(title):
                let cell = tableView.dequeueReusableCell(withIdentifier: MapPoiDetailsViewController.labelCellClassName, for: indexPath) as! SingleLabelTableViewCell
                cell.label.text = title
                cell.label.textAlignment = .center
                cell.label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
                return cell
            case let .description(description):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: MapPoiDetailsViewController.webCellClassName, for: indexPath) as! WebViewTableViewCell
                cell.delegate = self
                cell.htmlContent = description
                cell.webViewHeight.constant = self?.webViewHeight ?? 1
                cell.openUrl = self?.openUrl
                return cell
            }
        }
        
        var items: [CellType] = []
        if let title = mapPoi.title, !title.isEmpty {
            items.append(.title(title))
        }
        if let description = mapPoi.description, !description.isEmpty {
            items.append(.description(description))
        }
        var snapshot = NSDiffableDataSourceSnapshot<String, CellType>()
        snapshot.appendSections([""])
        snapshot.appendItems(items, toSection: "")
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

extension MapPoiDetailsViewController: ContentHeightUpdatable {
    func updateContentHeight(_ height: CGFloat, cellTag: Int) {
        if height > webViewHeight {
            webViewHeight = height
            tableView.reloadData()
        }
    }
}
