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
import MobileCoreServices

struct AddAssetToDocumentRequest: FlintLoggable {
    let asset: PHAsset?
    let image: UIImage?
    let document: Document
    
    var loggingDescription: String {
        return "Asset: \(asset?.localIdentifier ?? "nil"), Image: \(String(describing: image)), Document: \(document.name)"
    }
    
    var loggingInfo: [String:String]? {
        var result: [String:String] = [
            "document": document.documentRef.loggingDescription
        ]
        if let asset = asset {
            result["imageSource"] = "asset \(asset.localIdentifier)"
        }
        if let _ = image {
            result["imageSource"] = "new photo"
        }
        return result
    }
}

final class AddSelectedPhotoAction: Action {
    typealias InputType = AddAssetToDocumentRequest
    typealias PresenterType = PhotoSelectionPresenter

    static func perform(with context: ActionContext<InputType>, using presenter: PhotoSelectionPresenter, completion: @escaping (ActionPerformOutcome) -> Void) {
        presenter.showAssetFetchProgress()
        
        if let asset = context.input.asset {
            PhotosManager.fetchData(asset) { data, uti in
                presenter.hideAssetFetchProgress()
                if let data = data, let uti = uti {
                    context.input.document.attachMedia(data, uti: uti)
                    completion(.success(closeActionStack: true))
                } else {
                    completion(.failure(error: PhotosManager.Err.fetchFailed, closeActionStack: true))
                }
            }
        } else if let image = context.input.image {
            guard let data = UIImageJPEGRepresentation(image, 0.7) else {
                preconditionFailure("Failed to JPEG encode captured image")
            }
            context.input.document.attachMedia(data, uti: kUTTypeJPEG as String)
            completion(.success(closeActionStack: true))

        } else {
            preconditionFailure("Expected an asset or data")
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
