//
//  ViewController.swift
//  BattingRecords
//
//  Created by Abhinav Mathur on 11/03/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    
    // create swipe gesture
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()

    var playersArray        : Array<AnyObject>?
    var favPlayers          : Array<AnyObject>?
    var searchActive        : Bool = false
    var searching_data      : NSMutableArray = []
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.delegate = self
        searchBar.text = .none
        searchBar.showsCancelButton = false
        searchBar.returnKeyType = .default
        searchActive = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRecords()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.labelText = "Loading"
        
        let gImageView = UIView(frame: CGRect(x: 0,y: 0,width: 25,height: 25))
        let groupImage = UIImageView(frame: CGRect(x: 0,y: 0,width: 25,height: 25))
        groupImage.image = UIImage(named: "star.png")
        groupImage.contentMode = .scaleAspectFit
        groupImage.layer.masksToBounds = true
        groupImage.layer.cornerRadius = groupImage.frame.size.width / 2
        gImageView.addSubview(groupImage)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.showFavouritePlayers))
        gImageView.addGestureRecognizer(tapRecognizer)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: gImageView)

        // set gesture direction
        self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        self.swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        
        // add gesture target
        self.swipeGestureLeft.addTarget(self, action: #selector(ViewController.handleSwipeLeft(_:)))
        self.swipeGestureRight.addTarget(self, action: #selector(ViewController.handleSwipeRight(_:)))
        
        // add gesture in to view
        self.view.addGestureRecognizer(self.swipeGestureLeft)
        self.view.addGestureRecognizer(self.swipeGestureRight)
        // set current page number label.
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = false
        searchBar.text = .none
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty{
            searchActive = false
            tableView.reloadData()
        } else {
            print(" search text %@ ",searchBar.text! as NSString)
            searchActive = true
            searching_data.removeAllObjects()
            var totalValues : Int = 0
            let thresholdValue = self.pageController.numberOfPages * 10
            if ((self.pageController.currentPage + 1)*10) < thresholdValue
            {
                totalValues = 10
            }
            else
            {
                totalValues = (self.playersArray!.count - ((self.pageController.currentPage)*10))
            }
            for index in 0 ..< totalValues
            {
                let currentString = playersArray?[index + (self.pageController.currentPage * 10)].value(forKey: "name") as! String
                let countryString = playersArray?[index + (self.pageController.currentPage * 10)].value(forKey: "country") as! String
                if currentString.lowercased().range(of: searchText.lowercased())  != nil || countryString.lowercased().range(of: searchText.lowercased())  != nil{
                    searching_data.add(playersArray?[index + (self.pageController.currentPage * 10)])
                    
                }
            }
            tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive
        {
            return searching_data.count
        }
        else if favPlayers != nil && favPlayers!.count > 0
        {
            return favPlayers!.count
        }
        else if self.playersArray != nil && self.pageController.numberOfPages < 2
        {
            return self.playersArray!.count
        }
        else if self.playersArray != nil &&  self.pageController.numberOfPages > 1
        {
            let thresholdValue = self.pageController.numberOfPages * 10
            if ((self.pageController.currentPage + 1)*10) < thresholdValue
            {
               return 10
            }
            else
            {
                return (self.playersArray!.count - ((self.pageController.currentPage)*10))
            }
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "players") as! PlayerTableViewCell
        
        var playerInfo : AnyObject
        if searchActive
        {
            playerInfo = searching_data[indexPath.row + (self.pageController.currentPage * 10)] as AnyObject
        }
        else if favPlayers != nil && favPlayers!.count > 0
        {
            playerInfo = favPlayers?[indexPath.row] as AnyObject
        }
        else
        {
            playerInfo = (self.playersArray?[indexPath.row + (self.pageController.currentPage * 10)])!
        }

        cell.playerName.text = playerInfo.value(forKey: "name") as? String
        cell.playerCountry.text = playerInfo.value(forKey: "country") as? String
        if  playerInfo.value(forKey: "image") != nil
        {
            cell.playerImage.sd_setImage(with: NSURL(string:(playerInfo.value(forKey: "image") as? String)!)! as URL, placeholderImage: UIImage(named:"player"))
        }
        else
        {
            cell.playerImage.image = UIImage(named: "player")
        }
        cell.playerImage.layer.masksToBounds = true
        cell.playerImage.layer.cornerRadius = 25
        let value = FavouritesHandling().returnFavouriteInformation(info : playerInfo)
        if value == true
        {
            cell.favourite.setImage(UIImage(named: "star.png"), for: .normal)
        }
        else
        {
            cell.favourite.setImage(UIImage(named: "borderStar.png"), for: .normal)
        }
        cell.favourite.addTarget(self, action: #selector(ViewController.setFavouritePlayer), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row % 2) == 0
        {
            self.performSegue(withIdentifier: "playerInformation", sender: indexPath)
        }
        else
        {
            self.performSegue(withIdentifier: "playerDetails", sender: indexPath)
        }

        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "playerDetails"
        {
            if searchActive
            {
                let vc = segue.destination as! PlayerDetailViewController
                vc.playerDetail = self.playersArray?[(sender as! IndexPath).row] as! Dictionary<String, AnyObject>
            }
            else
            {
                let vc = segue.destination as! PlayerDetailViewController
                vc.playerDetail = self.playersArray?[(sender as! IndexPath).row] as! Dictionary<String, AnyObject>
            }
        }
        else if segue.identifier == "playerInformation"
        {
            if searchActive
            {
                let vc = segue.destination as! PlayerInformationViewController
                vc.playerDetail = self.searching_data[(sender as! IndexPath).row  + (self.pageController.currentPage * 10)] as! Dictionary<String, AnyObject>
            }
            else
            {
                let vc = segue.destination as! PlayerInformationViewController
                vc.playerDetail = self.playersArray?[(sender as! IndexPath).row  + (self.pageController.currentPage * 10)] as! Dictionary<String, AnyObject>
            }
        }
        
    }
    // MARK: - Utility function
    
    // increase page number on swift left
    func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        if self.pageController.currentPage < self.pageController.numberOfPages {
            self.pageController.currentPage += 1
            self.tableView.reloadData()
        }
    }
    
    // reduce page number on swift right
    func handleSwipeRight(_ gesture: UISwipeGestureRecognizer){
        
        if self.pageController.currentPage != 0 {
            self.pageController.currentPage -= 1
            self.tableView.reloadData()
        }
    }

    func getRecords()
    {
        let url = URL(string: "http://hackerearth.0x10.info/api/gyanmatrix?type=json&query=list_player")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.playersArray = ((json as AnyObject).value(forKey: "records") as! Array<AnyObject>)
            DispatchQueue.main.async(execute: { () -> Void in
                self.pageController.numberOfPages = (self.playersArray!.count/10 + 1)
                self.tableView.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            })
        }
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sortByMatches(_ sender: Any) {
        self.playersArray!.sort(by: {String(describing: $0.value(forKey: "matches_played")).compare(String(describing: $1.value(forKey: "matches_played"))) == .orderedAscending})
        self.tableView.reloadData()
    }

    @IBAction func sortByRuns(_ sender: Any) {
        self.playersArray!.sort(by: {String(describing: $0.value(forKey: "total_score")).compare(String(describing: $1.value(forKey: "total_score"))) == .orderedAscending})
         self.tableView.reloadData()
    }
    
    func setFavouritePlayer(sender: UIButton)
    {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath =   self.tableView.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            var playerInfo : AnyObject

            if searchActive
            {
                playerInfo = searching_data[indexPath!.row + (self.pageController.currentPage * 10)] as AnyObject
            }
            else
            {
                playerInfo = (self.playersArray?[indexPath!.row + (self.pageController.currentPage * 10)])!
            }
            FavouritesHandling().setFavouriteInformation(info: playerInfo)
        }
        self.tableView.reloadData()
    }
    
    func showFavouritePlayers()
    {
        self.favPlayers = FavouritesHandling().returnAllFavouritePlayers()
        self.tableView.reloadData()
    }
}

