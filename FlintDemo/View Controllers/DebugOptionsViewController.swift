//
//  DebugOptionsViewController.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/03/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import UIKit
import FlintCore
import FlintUI

class DebugOptionsViewController: UITableViewController {
    enum DebugOption: Int {
        case timeline
        case actionStacks
        case browseFeatures
        case browsePurchases
        case browseFocusLogs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = DebugOption(rawValue: indexPath.row) else {
            preconditionFailure()
        }
        
        switch option {
            case .timeline:
                if let request = TimelineBrowserFeature.show.request() {
                    request.perform(withPresenter: navigationController ?? self)
                }
            case .actionStacks:
                if let request = ActionStackBrowserFeature.show.request() {
                    request.perform(withPresenter: navigationController ?? self)
                }
            case .browseFeatures:
                if let request = FeatureBrowserFeature.show.request() {
                    request.perform(withPresenter: navigationController ?? self)
                }
            case .browsePurchases:
                if let request = PurchaseBrowserFeature.show.request() {
                    request.perform(withPresenter: navigationController ?? self)
                }
            case .browseFocusLogs:
                if let request = LogBrowserFeature.show.request() {
                    request.perform(withPresenter: navigationController ?? self)
                }
        }
    }

    @objc public func shareReport() {
        let url = DebugReporting.gatherReportZip(options: [])
        let shareViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareViewController.completionWithItemsHandler = { _, _, _, _ in
            try? FileManager.default.removeItem(at: url)
        }
        present(shareViewController, animated: true)
    }

    // MARK: Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exportReportTapped(_ sender: Any) {
        shareReport()
    }
}
