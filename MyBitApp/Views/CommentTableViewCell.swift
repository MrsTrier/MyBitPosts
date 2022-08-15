//
//  CommentTableViewCell.swift
//  MyBitApp
//
//  Created by admin on 11.08.2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    var comment: CDComment? {
        didSet {
            self.updateUI()
        }
    }

    private func updateUI() {
        guard let comment = comment else {
            return
        }
        commentBody?.text = comment.commentText
    }

    @IBOutlet weak var commentBody: UILabel!
    
}
