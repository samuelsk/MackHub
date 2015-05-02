//
//  RepositoriesTableViewCell.swift
//  MackHub
//
//  Created by Rafael Fernandes de Oliveira Carvalho on 4/29/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class RepositoriesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var language: UILabel!
    
    var cellIsSelected = false {
        didSet {
            if !cellIsSelected {
                updatedAt.alpha = 0
                language.alpha = 0
            } else {
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.updatedAt.alpha = 1
                    self.language.alpha = 1
                })
            }
        }
    }
    
    

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
