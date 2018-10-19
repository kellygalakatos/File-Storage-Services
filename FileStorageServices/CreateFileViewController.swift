//
//  CreateFileViewController.swift
//  FileStorageServices
//
//  Created by Kelly Galakatos on 10/18/18.
//  Copyright © 2018 Kelly Galakatos. All rights reserved.
//

import Foundation
import UIKit

class CreateFileViewController: UIViewController {
    
    @IBOutlet weak var fileName: UITextField!
    @IBOutlet weak var fileContent: UITextView!
    var isicloud: Bool?
    
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
        if fileName.text != "" {
//                FileManager.default.createFile(atPath: fileName.text!, contents: fileContent.text.data(using: String.Encoding.utf8), attributes: nil)
//                print("reached")
            
           
            if isicloud == false {
                do {
                try fileContent.text.write(to: FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false).appendingPathComponent(fileName.text!), atomically: true, encoding: .utf8)
                } catch {
                    print(error)
                }
            } else {
                
                
                do {
                    guard let testest = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent(fileName.text!)
                    
                        else {return}
                    try fileContent.text.write(to: testest, atomically: true, encoding: .utf8)
                    
                } catch {
                    print(error)
                }
                
                
            }
            
            
          //  FileManager.default.createFile(atPath: <#T##String#>, contents: <#T##Data?#>, attributes: <#T##[FileAttributeKey : Any]?#>)
//                FileManager.default.createFile(atPath: FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).stringByAppendingPathComponent(fileName.text), contents: fileContent.text, attributes: nil)
//                let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//
//                let content = fileContent.text.data(using: String.Encoding.utf8)
//
//                try content?.write(to: directory.appendingPathExtension(fileName.text!))
            
            performSegue(withIdentifier: "segue2", sender: nil)

        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(isicloud)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}
