//
//  CustomTableViewCell.swift
//  MyFirebaseLoginBrave
//
//  Created by YONGKI LEE on 2020/02/08.
//  Copyright © 2020 Brave Lee. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let nibName = String(describing: classForCoder())
    
    @IBOutlet weak var uiImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}
