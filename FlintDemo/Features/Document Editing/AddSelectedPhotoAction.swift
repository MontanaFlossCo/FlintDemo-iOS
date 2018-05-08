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
    typealias PresenterType = PhotoSelectionPresenter

    static func perform(with context: ActionContext<InputType>, using presenter: PhotoSelectionPresenter, completion: @escaping (ActionPerformOutcome) -> Void) {
        presenter.showAssetFetchProgress()
        PhotosManager.fetchData(context.input.asset) { data, uti in
            presenter.hideAssetFetchProgress()
            if let data = data, let uti = uti {
                context.input.document.attachMedia(data, uti: uti)
                completion(.success(closeActionStack: true))
            } else {
                completion(.failure(error: PhotosManager.Err.fetchFailed, closeActionStack: true))
            }
        }
    }
}

class PhotosManager {
    enum Err: Error {
        case fetchFailed
    }
    
    static func fetchData(_ asset: PHAsset, completion: @escaping (_ data: Data?, _ uti: String?) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.version = .current
        options.resizeMode = .fast
        PHImageManager.default().requestImageData(for: asset, options: options) { data, uti, orientation, info in
            completion(data, uti)
        }
    }
}
