//
//  WordCell.swift
//  W&S
//
//  Created by Adis Mulabdic on 29.07.2021..
//

import UIKit

class WordCell: UITableViewCell {

    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(_ word: Word) {
        self.word.text = word.name
        
        let synonyms = word.synonyms
        stackView.removeAllSubviews()
        var tempArr = [UILabel]()
        
        for (x, item) in synonyms.enumerated() {
            let label = PaddingLabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.backgroundColor = .labelBg
            label.text = item.name
            label.layer.cornerRadius = 6
            label.textAlignment = .center
            label.layer.masksToBounds = true
            tempArr.append(label)
            if tempArr.count > 3 {
                add(labels: tempArr)
                tempArr.removeAll()
                continue
            } else {
                if x == synonyms.endIndex - 1 {
                    add(labels: tempArr)
                }
            }
        }
    }
    
    private func add(labels: [UILabel]) {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 10
        for item in labels {
            hStackView.addArrangedSubview(item)
        }
        if hStackView.arrangedSubviews.count < 3 {
            hStackView.addArrangedSubview(UILabel())
            hStackView.addArrangedSubview(UILabel())
        }
        stackView.addArrangedSubview(hStackView)
    }
}

