//
//  LibraryController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 1/21/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit

class LibraryController: UIViewController {

    //UITableView
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpConstraints()

        // Do any additional setup after loading the view.
    }
    
    func setUpConstraints()
    {
        let tableViewBottomAnchor = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let tableViewTopAnchor = self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let tableViewWidthAnchor = self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let tableViewCXAnchor = self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        NSLayoutConstraint.activate([tableViewBottomAnchor, tableViewTopAnchor, tableViewWidthAnchor, tableViewCXAnchor])
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
