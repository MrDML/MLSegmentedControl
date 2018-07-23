//
//  ViewController.swift
//  MLSegmentedControl
//
//  Created by MrDML on 06/15/2018.
//  Copyright (c) 2018 MrDML. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray:[String] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = ["文本类型(TextType)","图片类型(ImageType)","文本+图片类型(ImageTextType)"]
     
        configTableView()
    }
    
    
    
    func configTableView(){
        self.tableView.rowHeight = 44
    }
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell =  tableView.dequeueReusableCell(withIdentifier: "identifire")
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "identifire")
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell!
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
      let storyboard =  UIStoryboard.init(name: "Main", bundle: Bundle.init(identifier: "storyboard"))
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        if indexPath.row == 0{
            detailsVC.type = .text
        }else if indexPath.row == 1{
            detailsVC.type = .image
        }else if indexPath.row == 2{
            detailsVC.type = .textImage
        }
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
    }

    
}









