//
//  Document.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

class Document: FlintLoggable {
    var name: String
    var modifiedDate: Date
    var body: String
    var hasAttachment: Bool {
        return attachmentData != nil
    }
    
    var info: DocumentInfo {
        return DocumentInfo(name: name, modifiedDate: modifiedDate)
    }

    var documentRef: DocumentRef {
        return DocumentRef(name: name)
    }

    var description: String {
        return name
    }
    
    var attachmentData: Data?
    var attachmentUTI: String?

    init(name: String, body: String, modifiedDate: Date, attachment: Data? = nil, attachmentUTI: String? = nil) {
        self.name = name
        self.body = body
        self.attachmentData = attachment
        self.attachmentUTI = attachmentUTI
        self.modifiedDate = modifiedDate
    }
    
    func attachMedia(_ media: Data, uti: String) {
        attachmentData = media
        attachmentUTI = uti
    }
    
    func removeAttachment() {
        attachmentData = nil
        attachmentUTI = nil
    }

    var loggingDescription: String {
        return "Document named \"\(name)\" with body: \"\(body)\" and attachment: \(attachmentData?.count ?? 0) bytes with UTI \(attachmentUTI ?? "<none>")"
    }
    
    var loggingInfo: [String : String]? {
        var result = [
            "name": name,
            "modified": modifiedDate.description,
            "body": body,
            "hasAttachment": hasAttachment.description,
        ]
        if let uti = attachmentUTI {
            result["attachmentUTI"] = uti
        }
        return result
    }
}

