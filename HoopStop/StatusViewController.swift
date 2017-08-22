//
//  StatusViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 8/16/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import Firebase
import SVProgressHUD

class StatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    @IBOutlet weak var tableView: UITableView!
     var invitedAt = [String]()
    
    @IBOutlet weak var signedInAtLabel: UILabel!
    var t_count:Int = 0
    var lastCell: StackViewCell = StackViewCell()
    var button_tag:Int = -1
    let cellSpacingHeight: CGFloat = 5
    
    override func viewWillAppear(_ animated: Bool) {
        if(FIRAuth.auth()?.currentUser != nil) {
            ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with:  { (snapshot) in
                let value = snapshot.value
                let tempProfileInfoArray = value as! NSDictionary
                self.invitedAt = (tempProfileInfoArray["invitedAt"] as? [String])!
                self.signedInAtLabel.text = (tempProfileInfoArray["signedInAt"] as? String)!
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.frame.size.height = self.view.frame.height
        tableView.frame.origin.y += 0
        tableView.register(UINib(nibName: "StackViewCell", bundle: nil), forCellReuseIdentifier: "StackViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == button_tag {
            return 0.35*self.view.frame.height
        } else {
            return 0.08*self.view.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedAt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackViewCell", for: indexPath) as! StackViewCell
        if !cell.cellExists {
            cell.backgroundColor = UIColor.white
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
           // cell.textView.text = movies[indexPath.row]["Description"] as! String
           // cell.open.setTitle(movies[indexPath.row]["Title"] as? String, for: .normal)
            //let imageURL = movies[indexPath.row]["Photo"] as! String
            //cell.backgroundImage?.sd_setImage(with: URL(string: imageURL))
            cell.open.setTitle(    invitedAt[indexPath.row], for: .normal)
            cell.backgroundImage.image = UIImage.init(named: "facilityImage")
            cell.open.tag = t_count
            cell.open.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
            t_count += 1
            cell.cellExists = true
        }
        
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        return cell
    }
    func cellOpened(sender:UIButton) {
        self.tableView.beginUpdates()
        
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = StackViewCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            
            lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! StackViewCell
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
        }
        self.tableView.endUpdates()
    }
    
}
