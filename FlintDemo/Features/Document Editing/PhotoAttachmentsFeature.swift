//
//  AddDocumentPhotoFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/05/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class PhotoAttachmentsFeature: ConditionalFeature {
    static func constraints(requirements: FeatureConstraintsBuilder) {
        requirements.iOSOnly = 10
        
        requirements.permission(.photos)
    }
    
    static var description: String = "Attach and remove a photo in a document"
    
    static let showPhotoSelection = action(ShowPhotoSelectionAction.self)
    static let cancelPhotoSelection = action(CancelPhotoSelectionAction.self)
    static let addSelectedPhoto = action(AddSelectedPhotoAction.self)
    static let removePhoto = action(RemovePhotoAction.self)

    static func prepare(actions: FeatureActionsBuilder) {
        actions.declare(showPhotoSelection)
        actions.declare(cancelPhotoSelection)
        actions.declare(addSelectedPhoto)
        actions.declare(removePhoto)
    }
}
