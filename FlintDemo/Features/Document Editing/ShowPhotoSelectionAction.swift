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

final class ShowPhotoSelectionAction: UIAction {
    typealias InputType = NoInput
    
    typealias PresenterType = PhotoSelectionPresenter
    
    public static func perform(context: ActionContext<NoInput>, presenter: PresenterType, completion: Completion) -> Completion.Status {
        presenter.showPhotoSelection()
        return completion.completedSync(.success)
    }
}
