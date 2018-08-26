//
//  SearchTableViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 20..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Cosmos

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var starPointView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func itemSelected(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController //Storyboard ID를 설정해줘야 한다.
        secondViewController.itemID = itemButton.tag
        self.window?.rootViewController?.show(secondViewController, sender: nil)
        print(itemButton.tag)
    }
}
