//
//  DocumentStore.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation

/// This is a trivial data store to load and save documents, so we can test spotlight
class DocumentStore {
    let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    
    static let shared = DocumentStore()
    
    func listDocuments() -> [DocumentInfo] {
        let contents = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil,
            options: [.skipsPackageDescendants, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
        guard let foundContents = contents else {
            return []
        }
        return foundContents.map { url in
            guard let resources = try? url.resourceValues(forKeys: [URLResourceKey.contentModificationDateKey, URLResourceKey.creationDateKey, URLResourceKey.nameKey]),
                let lastModified = resources.contentModificationDate ?? resources.creationDate,
                let name = resources.name else {
                    preconditionFailure("Failed to get resource attributes for: \(url)")
            }
            return DocumentInfo(name: name, modifiedDate: lastModified)
        }
    }
    
    func load(_ name: String) -> Document? {
        let documentURL = url(for: name)
        let body = try? String(contentsOf: documentURL, encoding: .utf8)
        guard let bodyContent = body else {
            return nil
        }
        guard let resources = try? documentURL.resourceValues(forKeys: [URLResourceKey.contentModificationDateKey, URLResourceKey.creationDateKey, URLResourceKey.nameKey]),
            let lastModified = resources.contentModificationDate ?? resources.creationDate else {
                preconditionFailure("Failed to get resource attributes for: \(documentURL)")
        }
        let document = Document(name: name, modifiedDate: lastModified, body: bodyContent)
        return document
    }

    /// Save the document, overwriting if it already exists
    /// - return: `true` if the document is new, i.e. it did not already exist
    func save(_ document: Document) -> Bool {
        let documentURL = url(for: document.name)
        do {
            let existed = FileManager.default.fileExists(atPath: documentURL.path)
            try document.body.write(to: documentURL, atomically: false, encoding: .utf8)
            return !existed
        } catch let e {
            fatalError("Failed to save document: \(e)")
        }
    }

    /// Save the document, overwriting if it already exists
    /// - return: `true` if the document is new, i.e. it did not already exist
    func delete(_ documentRef: DocumentRef) {
        let documentURL = url(for: documentRef.name)
        do {
            try FileManager.default.removeItem(at: documentURL)
        } catch {
            /// !!! TODO: Contextual logging
        }
    }

    // Internals
    
    private func url(for documentName: String) -> URL {
        let safeName = documentName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let result = URL(string: safeName, relativeTo: documentsURL)
        return result!
    }
}
