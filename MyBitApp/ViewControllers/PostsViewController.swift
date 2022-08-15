//
//  ViewController.swift
//  MyBitApp
//
//  Created by admin on 08.08.2022.
//

import UIKit
import CoreData

class PostsViewController: UITableViewController, PostTableViewCellDelegate {

    var networkService: NetworkService?

    var fetchedResultsController: NSFetchedResultsController<CDPost>?

    private let coreData = CoreDataService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension

        if coreData.isDataBaseEmpty {
            networkService?.loadJson(with: .post)
            networkService?.loadJson(with: .comment)
        }
        loadSavedData()
    }
    
    func showComments(_ post: CDPost) {
        let sender: [String: Any?] = ["text": post.text, "id": post.id]
        self.performSegue(withIdentifier: "PostsComments", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PostsComments") {
            guard let commentsView = segue.destination as? CommentsViewController else {
                return
            }
            let post = sender as! [String: Any?]
            commentsView.text = post["text"] as? String
            commentsView.postId = post["id"] as? Int16
        }
    }

    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<CDPost>(entityName: "CDPost")
            request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
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
        let posts = fetchedResultsController?.sections![section]
        return posts?.numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.post = fetchedResultsController?.object(at: indexPath)
        return cell
    }
}


extension PostsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch (type) {
        case .insert:
            if newIndexPath != nil && (newIndexPath?.row)! < (controller.fetchedObjects?.count)! {
                tableView.insertRows(at: [newIndexPath!], with: .left)
            }
            break;

        case .update:
            if indexPath != nil && (indexPath?.row)! < (controller.fetchedObjects?.count)! {
                self.tableView.reloadRows(at: [indexPath!], with: .left)
            }
            break;

        case .delete:
            if indexPath != nil && (indexPath?.row)! < (controller.fetchedObjects?.count)! {
                self.tableView.deleteRows(at: [indexPath!], with: .left)
            }
            break;

        case .move:
            if indexPath != nil && (indexPath?.row)! < (controller.fetchedObjects?.count)! {
                print("type.move: shouldn't get in here!")
            }
            break;

        @unknown default:
            break
        }
    }
}
