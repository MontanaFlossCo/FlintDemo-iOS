//
//  SiriFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 11/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import Intents
import FlintCore


class SiriFeature: Feature {
    static let description = "Siri access to documents"

    @available(iOS 12, *)
    static let getNote = action(GetNoteAction.self)

    static func prepare(actions: FeatureActionsBuilder) {
        if #available(iOS 12, *) {
            actions.declare(getNote)
        }
    }
}

// Siri Intent stuff

protocol SiriResultPresenter {
    associatedtype ResponseType: INIntentResponse
    func showResult(response: ResponseType)
}

@available(iOS 12, *)
class GetNoteSiriPresenter: SiriResultPresenter {
    var result: GetNoteIntentResponse?
    
    func showResult(response: GetNoteIntentResponse) {
        result = response
    }
}

protocol SiriIntentAction: Action {
}

extension SiriIntentAction {
    static var queue: DispatchQueue { return intentsQueue }
    static var defaultSession: ActionSession? { return intentActionSession }
}
