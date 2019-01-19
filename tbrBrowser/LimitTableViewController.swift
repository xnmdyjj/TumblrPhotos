//
//  TagSearchLimitTableViewController.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/14.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol LimitTableViewControllerDelegate: class {
    func refresh(limit: Int)
}

class LimitTableViewController: UITableViewController {
    let limitList = [10, 20, 30, 40, 50]
    weak var delegate: LimitTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "请求条目数量"
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return limitList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "\(limitList[indexPath.row])条"
        
        if limitList[indexPath.row] == Defaults[.limit] {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.refresh(limit: limitList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

}
