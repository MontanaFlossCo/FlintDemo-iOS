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
///
/// - Tag: getnote-intent
@objc
class GetNoteIntentHandler: NSObject, GetNoteIntentHandling {
    @objc(handleGetNote:completion:)
    func handle(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Void) {
        do {
            let outcome = try SiriFeature.getNote.perform(withIntent: intent, completion: completion)
            assert(outcome == .success, "Intent failed: \(outcome)")
        } catch {
            completion(.init(code: .failure, userActivity: nil))
        }
    }
}
