//
//  SynonymCell.swift
//  W&S
//
//  Created by Adis Mulabdic on 29.07.2021..
//

import UIKit

class SynonymCell: UICollectionViewCell {

    @IBOutlet weak var synonymName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ synonym: Synonym) {
        synonymName.text = synonym.name
    }
}
