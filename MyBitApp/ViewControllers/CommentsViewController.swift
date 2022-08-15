//
//  CommentsViewController.swift
//  MyBitApp
//
//  Created by admin on 11.08.2022.
//

import UIKit
import CoreData

class CommentsViewController: UITableViewController {
    
    @IBOutlet weak var postText: UILabel!

    var text: String?
    var postId: Int16?

    private let coreData = CoreDataService.shared
    var fetchedResultsController: NSFetchedResultsController<CDComment>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        postText.text = text
        loadSavedData()
    }

    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<CDComment>(entityName: "CDComment")
            request.sortDescriptors = [NSSortDescriptor(key: "commentText", ascending: true)]
            guard let postId = postId else {
                return
            }
            request.predicate = NSPredicate(format: "postId = \(postId)")
            request.fetchBatchSize = 20

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreData.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
        }
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comments = fetchedResultsController?.sections![section]
        return (comments?.numberOfObjects ?? 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.comment = fetchedResultsController?.object(at: indexPath)
        return cell
    }
}


extension CommentsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch (type) {
        case .insert:
            if newIndexPath != nil && (newIndexPath?.row)! < (controller.fetchedObjects?.count)!{
                tableView.insertRows(at: [newIndexPath!], with: .left)
            }
            break;

        case .update:
            if indexPath != nil && (indexPath?.row)! < (controller.fetchedObjects?.count)!{
                self.tableView.reloadRows(at: [indexPath!], with: .left)
            }
            break;

        case .delete:
            if indexPath != nil && (indexPath?.row)! < (controller.fetchedObjects?.count)!{
                self.tableView.deleteRows(at: [indexPath!], with: .left)
            }
            break;

        case .move:
            if indexPath != nil && (indexPath?.row)! < (controller.fetchedObjects?.count)!{
                print("type.move: shouldn't get in here!")
            }
            break;

        }
    }
}
