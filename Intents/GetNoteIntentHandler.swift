//
//  GetNoteIntentHandler.swift
//  FlintDemoSiriIntent
//
//  Created by Marc Palmer on 11/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import Intents
import FlintCore

/// The intent handler for the GetNote intent.
///
/// We simply call in to Flint and pass the `intent` instance. Flint will dispatch the Action and
/// pass the presenter to the action so that it can provide results to Siri, or instruct it to open the app.
@objc
class GetNoteIntentHandler: NSObject, GetNoteIntentHandling {
    @objc(handleGetNote:completion:)
    func handle(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Void) {
        let presenter = IntentResponsePresenter(completion: completion)
        let outcome = SiriFeature.getNote.perform(intent: intent, presenter: presenter)
//        let outcome = SiriFeature.getNote.perform(intent: intent, completion: completion)
        assert(outcome == .success, "Intent failed: \(outcome)")
    }
    
//    @objc(confirmGetNote:completion:)
//    func confirm(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Swift.Void) {
//
//    }

}
