//
//  PersistenceStoreService.swift
//  MyBitApp
//
//  Created by admin on 09.08.2022.
//

import Foundation
import CoreData

/// Protocol to work with a data in persistent store
protocol CoreDataMethodsProtocol {
    func savePost(newElement: PostModel)

    func saveComment(newElement: CommentModel)

    func fetchComments(postId: Int16) -> [CDComment]?
}

final class CoreDataService {

    private var _posts: [CDPost]?

    static let shared = CoreDataService()
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()
}

extension CoreDataService: CoreDataMethodsProtocol {

    var posts: [CDPost]? {
        set {
            _posts = newValue
        }
        get {
            if _posts == nil {
                _posts = self.fetchPosts()
            }
            return _posts
        }
    }
    
    private func fetchPosts() -> [CDPost]? {
        let context = container.viewContext
        let request = NSFetchRequest<CDPost>(entityName: "CDPost")

        request.fetchBatchSize = 20
        print("fetchPosts")

        let data = try? context.fetch(request)
        return data
    }
    
    func fetchComments(postId: Int16) -> [CDComment]? {
        let context = container.viewContext
        let request = NSFetchRequest<CDComment>(entityName: "CDComment")

        let predicate = NSPredicate(format: "postId = \(postId)")
        request.predicate = predicate
        request.fetchBatchSize = 20

        let data = try? context.fetch(request)
        return data
    }

    func savePost(newElement: PostModel) {
        let context = container.viewContext

        let entity = CDPost(context: context)
        entity.id = newElement.id
        entity.text = String(newElement.title)
        do {
            try context.save()
        }
        catch { }
    }

    var isDataBaseEmpty: Bool {
        let context = container.viewContext
        do {
            let request = NSFetchRequest<CDPost>(entityName: "CDPost")
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    var noComments: Bool {
        let context = container.viewContext
        do {
            let request = NSFetchRequest<CDComment>(entityName: "CDComment")
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }

    func saveComment(newElement: CommentModel) {
        let context = container.viewContext

        let entity = CDComment(context: context)
        entity.commentId = newElement.id
        entity.commentText = String(newElement.body)
        entity.postId = newElement.postId
        do {
            try context.save()
        }
        catch { }
    }
}

