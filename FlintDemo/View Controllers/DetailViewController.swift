//
//  DetailViewController.swift
//  FlintDemo
//
//  Created by Marc Palmer on 06/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import UIKit
import FlintCore

class DetailViewController: UIViewController, DocumentEditingPresenter {

    @IBOutlet weak var bodyTextView: UITextView!

    var document: Document? {
        didSet {
            DocumentEditSession.shared.currentDocumentBeingEdited = document
        }
    }

    var documentRef: DocumentRef? {
        didSet {
            loadDocument()
            configureView()
        }
    }


    func loadDocument() {
        if let info = documentRef {
            document = DocumentStore.shared.load(info.name)
        } else {
            document = nil
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let document = document {
            navigationItem.title = document.name
            if let textView = bodyTextView {
                textView.text = document.body
            }
        } else {
            navigationItem.title = "No document"
            if let textView = bodyTextView {
                textView.text = ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    // Save the current document before leaving
    override func viewWillDisappear(_ animated: Bool) {
        if let document = document {
            DocumentManagementFeature.closeDocument.perform(using: self, with: document)
        }
        super.viewWillDisappear(animated)
    }
    
    // MARK: IB Actions
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        guard let document = document else {
            fatalError("There's no document")
        }
        
        if let request = DocumentSharingFeature.request(DocumentSharingFeature.share) {
            request.perform(using: self, with: document)
        } else {
            let alertController = UIAlertController(title: "Purchase required!", message: "Sorry by sharing is a premium feature. Please purchase to unlock this feature.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }

    // MARK: Data mechanics
    
    func saveChanges() {
        if var document = document {
            document.body = bodyTextView.text
            document.modifiedDate = Date()
            DocumentManagementFeature.saveDocument.perform(using: self, with: document)
        }
    }

    // MARK: DocumentPresenter conformance
    
    func share(_ document: Document) {
        let text = document.body
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    func didSaveChanges(to document: Document, wasFirstSave: Bool) {
        // Get the list presenter for this view controller so we can tell it about the changes
        let primaryNavigationController = splitViewController!.viewControllers.first as! UINavigationController
        let masterViewController = primaryNavigationController.viewControllers.first as! MasterViewController
        let listPresenter: DocumentListPresenter = masterViewController

        if wasFirstSave {
            listPresenter.didInsertNew(documentInfo: document.info)
        } else {
            listPresenter.didUpdate(documentInfo: document.info)
        }

    }
    
    func closeDocument(_ document: Document) {
        saveChanges()
    }
}
