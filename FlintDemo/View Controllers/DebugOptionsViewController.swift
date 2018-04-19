//
//  DebugOptionsViewController.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/03/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import UIKit
import FlintUI

class DebugOptionsViewController: UITableViewController {
    enum DebugOption: Int {
        case actionHistory
        case actionActionStacks
        case browseFeatures
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
        
        let vc: UIViewController
        
        switch option {
            case .actionHistory:
                vc = TimelineViewController.instantiate()
            case .actionActionStacks:
                vc = ActionStackListViewController.instantiate()
            case .browseFeatures:
                vc = FeatureBrowserViewController.instantiate()
        }
        
        navigationController!.pushViewController(vc, animated: true)
    }

    // MARK: Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
