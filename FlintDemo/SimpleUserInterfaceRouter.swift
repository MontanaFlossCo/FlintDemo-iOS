//
//  SimplePresentationRouter.swift
//  FlintDemo
//
//  Created by Marc Palmer on 07/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This class is used to provide the UI
class SimplePresentationRouter: PresentationRouter {
    let mainNavigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        mainNavigationController = navigationController
    }
    
    func presentation<FeatureType, ActionType>(for actionBinding: StaticActionBinding<FeatureType, ActionType>,
                                               with state: ActionType.InputType) -> PresentationResult<ActionType.PresenterType> {
        if ActionType.PresenterType.self == DocumentCreatePresenter.self {
            if let masterVC = mainNavigationController.topViewController as? MasterViewController {
                return .appReady(presenter: masterVC as! ActionType.PresenterType)
            } else {
                return .appCancelled
            }
        } else if ActionType.PresenterType.self == DocumentPresenter.self {
            if let masterVC = mainNavigationController.topViewController as? MasterViewController {
                return .appReady(presenter: masterVC as! ActionType.PresenterType)
            } else {
                return .appCancelled
            }
        } else {
            return .unsupported
        }
    }
 
    func presentation<FeatureType, ActionType>(for conditionalActionBinding: ConditionalActionBinding<FeatureType, ActionType>,
                                               with state: ActionType.InputType) -> PresentationResult<ActionType.PresenterType> {
        return .unsupported
    }
}
