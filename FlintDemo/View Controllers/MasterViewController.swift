//
//  MasterViewController.swift
//  FlintDemo
//
//  Created by Marc Palmer on 06/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import UIKit
import FlintCore
import FlintUI

class MasterViewController: UITableViewController, DocumentCreatePresenter, DocumentPresenter, DocumentSavePresenter, DocumentListPresenter {
    var detailViewController: DetailViewController? = nil
    var documentInfos = [DocumentInfo]()
    var selectedDocumentRef: DocumentRef?

    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewDocument(_:)))
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        reloadDocuments()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func createNewDocument(_ sender: Any) {
        ActionSession.main.perform( DocumentManagementFeature.createNew, using: self, with: .none)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let documentRef = selectedDocumentRef {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.documentRef = documentRef
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentInfos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let documentInfo = documentInfos[indexPath.row]
        cell.textLabel!.text = documentInfo.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let documentRef = documentInfos[indexPath.row].documentRef
            DocumentManagementFeature.deleteDocument.perform(using: self, with: documentRef)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let documentInfo = documentInfos[indexPath.row]
        DocumentManagementFeature.openDocument.perform(using: self, with: documentInfo.documentRef)
    }

    // MARK: Document Create Presenter
    
    func showCreate(suggestedTitle: String) {
        let alert = UIAlertController(title: "New document", message: "Please name your document", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let name = alert.textFields![0].text!
            let document = Document(name: name, modifiedDate: Date(), body: "New document")
            // Save the new document, but flag it as not user initiated so we don't think they actually chose to "Save",
            // otherwise every Create action also has a Save action
            DocumentManagementFeature.saveDocument.perform(using: self,
                                                           with: document,
                                                           userInitiated: false,
                                                           source: .application,
                                                           completion: { outcome in
                                                                if case .success = outcome {
                                                                    DocumentManagementFeature.openDocument.perform(using: self, with: document.documentRef)
                                                                }
                                                           })
        }))
        alert.addTextField { textField in
            textField.text = suggestedTitle
        }
        present(alert, animated: false)
    }

    // MARK: Document Create Presenter
    
    func didSaveChanges(to document: Document, wasFirstSave: Bool) {
        if wasFirstSave {
            didInsertNew(documentInfo: document.info)
        } else {
            didUpdate(documentInfo: document.info)
        }
    }
    
    // MARK: Document List Presenter

    func didInsertNew(documentInfo: DocumentInfo) {
        documentInfos.insert(documentInfo, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func didUpdate(documentInfo: DocumentInfo) {
        let indexOfOldDocument = documentInfos.index {
            return $0.name == documentInfo.name
        }
        guard let oldIndex = indexOfOldDocument else {
            fatalError()
        }
        var newDocumentInfos = documentInfos
        newDocumentInfos[oldIndex] = documentInfo
        newDocumentInfos = applySort(to: newDocumentInfos)
        let newIndex = newDocumentInfos.index(where: {
            return $0.name == documentInfo.name
        })!

        documentInfos = newDocumentInfos
        tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
    }
    
    func didRemove(documentRef: DocumentRef) {
        let indexOfOldDocument = documentInfos.index {
            return $0.name == documentRef.name
        }
        guard let oldIndex = indexOfOldDocument else {
            fatalError()
        }
        documentInfos.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .automatic)
    }
    
    // MARK: - Document Presenter
    
    func openDocument(_ documentRef: DocumentRef) {
        selectedDocumentRef = documentRef
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: Data model

    func reloadDocuments() {
        documentInfos = applySort(to: DocumentStore.shared.listDocuments())
    }
    
    func applySort(to infos: [DocumentInfo]) -> [DocumentInfo] {
        return infos.sorted(by: { (a, b) -> Bool in
            return a.modifiedDate >= b.modifiedDate
        })
    }


}

