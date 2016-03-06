//
//  ViewController.swift
//  NCMBPushPractice
//
//  Created by 井上 龍一 on 2016/03/01.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "username:\(NCMBUser.currentUser().userName)\ncreateData:\(NCMBUser.currentUser().createDate)\nupdateDate:\(NCMBUser.currentUser().updateDate)\n"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

