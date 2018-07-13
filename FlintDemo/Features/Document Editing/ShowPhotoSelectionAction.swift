//
//  ShowPhotoSelectionAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/05/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

protocol PhotoSelectionPresenter {
    func showPhotoSelection()
    func showAssetFetchProgress()
    func hideAssetFetchProgress()
    func dismissPhotoSelection()
}

final class ShowPhotoSelectionAction: Action {
    typealias InputType = NoInput
    
    typealias PresenterType = PhotoSelectionPresenter
    
    public static func perform(context: ActionContext<NoInput>, presenter: PresenterType, completion: @escaping (ActionPerformOutcome) -> Void) {
        presenter.showPhotoSelection()
        completion(.success(closeActionStack: false))
    }
}
