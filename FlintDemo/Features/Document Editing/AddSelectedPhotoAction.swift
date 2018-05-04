//
//  AddSelectedPhotoAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/05/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore
import Photos

struct AddAssetToDocumentRequest: CustomStringConvertible {
    let asset: PHAsset
    let document: Document
    
    var description: String {
        return "Asset: \(asset.localIdentifier), Document: \(document.name)"
    }
}

final class AddSelectedPhotoAction: Action {
    typealias InputType = AddAssetToDocumentRequest
    typealias PresenterType = DocumentEditingPresenter

    static func perform(with context: ActionContext<InputType>, using presenter: DocumentEditingPresenter, completion: @escaping (ActionPerformOutcome) -> Void) {
//        let imageData = PhotosManager.fetchData(context.input.asset)
//        document.attachMedia(imageData)
        completion(.success(closeActionStack: true))
    }
}

