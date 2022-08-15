//
//  PostTableViewCell.swift
//  MyBitApp
//
//  Created by admin on 10.08.2022.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func showComments(_ id: CDPost)
}

class PostTableViewCell: UITableViewCell {

    weak var delegate : PostTableViewCellDelegate?

    @IBOutlet weak var seeCommentButton: UIButton!

    @IBAction func seeComment(_ sender: Any) {
        if let delegate = delegate, let post = post {
          delegate.showComments(post)
      }
    }

    var post: CDPost? {
        didSet {
            self.updateUI()
        }
    }

    func updateUI() {
        if CoreDataService.shared.fetchComments(postId: post?.id ?? 0)?.count == 0 {
            seeCommentButton.isHidden = true
        }
        guard let post = post else {
            return
        }
        postTitle?.text = post.text
        id = post.id
    }

    var id: Int16?
    @IBOutlet weak var postTitle: UILabel!
}
