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
    
    func presentation<F, A>(for actionBinding: StaticActionBinding<F, A>, with state: A.InputType) -> PresentationResult<A.PresenterType> {
        if A.PresenterType.self == DocumentCreatePresenter.self {
            if let masterVC = mainNavigationController.topViewController as? MasterViewController {
                return .appReady(presenter: masterVC as! A.PresenterType)
            } else {
                return .appCancelled
            }
        } else if A.PresenterType.self == DocumentPresenter.self {
            if let masterVC = mainNavigationController.topViewController as? MasterViewController {
                return .appReady(presenter: masterVC as! A.PresenterType)
            } else {
                return .appCancelled
            }
        } else {
            return .unsupported
        }
    }
 
    func presentation<F, A>(for conditionalActionBinding: ConditionalActionBinding<F, A>, with state: A.InputType) -> PresentationResult<A.PresenterType> {
        return .unsupported
    }
}
