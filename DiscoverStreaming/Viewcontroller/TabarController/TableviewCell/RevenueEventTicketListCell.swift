//
//  RevenueEventTicketListCell.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 28/08/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class RevenueEventTicketListCell: UITableViewCell {

    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var ticketBuyerName_Lbl: UILabel!
    @IBOutlet weak var purchaseDate_Lbl: UILabel!
    @IBOutlet weak var numOfTickets_Lbl: UILabel!
    @IBOutlet weak var proceessFee_Lbl: UILabel!
    @IBOutlet weak var totalAmount_Lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
