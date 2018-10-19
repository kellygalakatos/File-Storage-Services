//
//  StoredFilesTableViewController.swift
//  FileStorageServices
//
//  Created by Kelly Galakatos on 10/18/18.
//  Copyright © 2018 Kelly Galakatos. All rights reserved.
//

import UIKit

class StoredFilesTableViewController: UITableViewController {

    @IBOutlet weak var label: UILabel!
    var list: [String] = []
    var detailList: [Int] = []
    
    var isicloud: Bool = false
    
    func localDirFiles() {
        
        var files: [String] = []
        var sizes: [Int] = []
        
        do {
        
            let URLs = try FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
            
            for file in URLs {
                let fileName = file.lastPathComponent
                files.append(fileName)
                sizes.append(Int(try FileManager.default.attributesOfItem(atPath: file.path)[FileAttributeKey.size] as! UInt64))
            }
            
        } catch {
                print(error)
            }
        
        list = files
        detailList = sizes
//        print(list)
        tableView.reloadData()
        }
    
    func iCloudFiles() {
        
        var files: [String] = []
        var sizes: [Int] = []
        
        guard let testest = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            return
        }
        do {
            let URLs = try FileManager.default.contentsOfDirectory(at: testest, includingPropertiesForKeys: nil)
            for file in URLs {
                
                let fileName = file.lastPathComponent
                files.append(fileName)
                sizes.append(Int(try FileManager.default.attributesOfItem(atPath: file.path)[FileAttributeKey.size] as! UInt64))
                
            }
        } catch {
            print(error)
        }
        
        list = files
        detailList = sizes
        tableView.reloadData()
        
        
    }

    @IBAction func switchModesClicked(_ sender: UIBarButtonItem) {
        if isicloud == true {
            isicloud = false
            localDirFiles()
            label.text = "Document Files"
        } else {
            isicloud = true
            iCloudFiles()
            label.text = "iCloud Files"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localDirFiles()
        refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CreateFileViewController
        destinationVC.isicloud = isicloud 
    
    }

    @IBAction func clickAdd(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segue", sender: nil)
  
    }
    
    func refresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.blue
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshList() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        cell.detailTextLabel?.text = "\(detailList[indexPath.row]) bytes in file"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            list.remove(at: indexPath.row)
            
            if isicloud == false {
            do {
            let URLs = try FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
            try FileManager.default.removeItem(at: URLs[indexPath.row])
            } catch {
                print(error)
            }
            } else {
                
                guard let testest = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
                    return
                }
                do {
                    let URLs = try FileManager.default.contentsOfDirectory(at: testest, includingPropertiesForKeys: nil)
                    try FileManager.default.removeItem(at: URLs[indexPath.row])
                } catch {
                    print(error)
                }
                
                
                
                
                
                
            }
            
            
            tableView.reloadData()
        }
    }

    

}
