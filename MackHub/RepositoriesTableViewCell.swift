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
                updatedAt.hidden = true
                language.hidden = true
            } else {
                updatedAt.hidden = false
                language.hidden = false
            }
        }
    }
    
    func hideInfo() {
        updatedAt.hidden = true
        language.hidden = true
        
        self.contentView.setNeedsDisplay()
        
    }
    
    func showInfo() {
        updatedAt.alpha = CGFloat(0.0)
        language.alpha = CGFloat(0.0)
        
        updatedAt.hidden = false
        language.hidden = false
        
        UIView.animateWithDuration(0.1, delay: 0.1, options: .CurveLinear, animations: { () -> Void in
            self.updatedAt.alpha = CGFloat(1.0)
            self.language.alpha = CGFloat(1.0)
        }, completion: nil)
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
