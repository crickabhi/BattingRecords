//
//  PlayerDetailViewController.swift
//  BattingRecords
//
//  Created by Abhinav Mathur on 11/03/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerViewTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerDescription: UITextView!
    var playerDetail : Dictionary<String,AnyObject> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player Detail"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(PlayerInformationViewController.shareDetails))

        self.headerView.layer.cornerRadius = 10
        self.headerView.clipsToBounds = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.layer.borderWidth = 1.5
        self.tableView.layer.borderColor = UIColor.blue.cgColor
        self.tableView.layer.cornerRadius = 10
        self.tableView.clipsToBounds = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        self.playerDescription.layer.borderWidth = 1.5
        self.playerDescription.layer.borderColor = UIColor.blue.cgColor
        self.playerDescription.layer.cornerRadius = 10
        self.playerDescription.clipsToBounds = true

        self.headerViewTitle.text = self.playerDetail["name"] as? String
        if  self.playerDetail["image"] != nil
        {
            self.playerImage.sd_setImage(with: NSURL(string:(self.playerDetail["image"])! as! String)! as URL, placeholderImage: UIImage(named:"player"))
        }
        else
        {
            self.playerImage.image = UIImage(named: "player")
        }
        self.playerDescription.text = self.playerDetail["description"] as! String
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "players") as! PlayerTableViewCell
        
        if indexPath.row == 0
        {
            cell.playerName.text = self.playerDetail["country"] as? String
            cell.playerImage.image = UIImage(named: "home")
        }
        else if indexPath.row == 1
        {
            cell.playerName.text = (self.playerDetail["total_score"] as? String)! + " Runs"
            cell.playerImage.image = UIImage(named: "cricket")
            
        }
        else if indexPath.row == 2
        {
            cell.playerName.text = (self.playerDetail["matches_played"] as? String)! + " Matches"
            cell.playerImage.image = UIImage(named: "battsman-miss")
            
        }
        else if indexPath.row == 3
        {
            let value = FavouritesHandling().returnFavouriteInformation(info : self.playerDetail as AnyObject)
            if value == true
            {
                cell.playerName.text = "My Favourite"
                cell.playerImage.image = UIImage(named: "star")
            }
            else
            {
                cell.playerName.text = "My Favourite"
                cell.playerImage.image = UIImage(named: "borderStar")
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
