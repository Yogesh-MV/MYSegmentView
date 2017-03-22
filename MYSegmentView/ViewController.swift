//
//  ViewController.swift
//  MYSegmentView
//
//  Created by Yogesh Murugesh on 21/03/17.
//  Copyright © 2017 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MYSegmentViewDelegate {

    @IBOutlet var segmentView: MYSegmentView!
    @IBOutlet var arrowSegmentView: MYSegmentView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentView.addTitles(withTitles: ["Segment 1", "Segment 2", "Segment 3"])
        segmentView.delegate = self
        
        arrowSegmentView.addTitles(withTitles: ["Segment 1", "Segment 2", "Segment 3"])
        arrowSegmentView.type = .bottomArrow
        arrowSegmentView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - SegmentView Delegate Methods
    
    func segmentSelected(atIndex: Int) {
        //Handle segment selected
    }

}

