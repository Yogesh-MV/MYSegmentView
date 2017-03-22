//
//  MYSegmentView.swift
//  MYSegmentView
//
//  Created by Yogesh Murugesh on 21/03/17.
//  Copyright © 2017 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

public protocol MYSegmentViewDelegate {
    /// Adds the image to the cache with the given identifier.
    func segmentSelected(atIndex: Int)
    
}

let kDefaultTagValue = 1000

enum MYSegmentType {
    case line
    case bottomArrow
}

class MYSegmentView: UIView {

    var titlesArray = [String]()
    var font: UIFont?
    var normalTextColor: UIColor?
    var selectionTextColor: UIColor?
    var normalBGColor: UIColor?
    var selectionBGColor: UIColor?
    var selectionLineColor: UIColor?
    var sepratorLineColor: UIColor?
    var selectedIndex = 0
    var delegate: MYSegmentViewDelegate?
    var type: MYSegmentType = MYSegmentType.line
    var arrowImage = UIImage(named: "arrow")
    
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeAttributes()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        splitSegmentView()
    }
    
    // MARK: - Custom methods
    
    
    private func customizeAttributes () {
        font = UIFont.systemFont(ofSize: 17.0)
        normalTextColor = UIColor.black
        selectionLineColor = UIColor.red
        sepratorLineColor = UIColor.lightGray
        selectionTextColor = UIColor.white
        normalBGColor = UIColor.white
        selectionBGColor = UIColor(red: 0/255, green: 132/255, blue: 173/255, alpha: 1.0)
    }

    private func addTopAndBottomView() {
        let topLineView = UIView()
        topLineView.backgroundColor = sepratorLineColor
        topLineView.frame.origin = CGPoint(x: 0, y: 0)
        topLineView.frame.size = CGSize(width: frame.size.width, height: 1.0)
        addSubview(topLineView)
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = sepratorLineColor
        bottomLineView.frame.origin = CGPoint(x: 0, y: (frame.size.height) - 1.0)
        bottomLineView.frame.size = CGSize(width: frame.size.width, height: 1.0)
        addSubview(bottomLineView)
    }
    
    private func sepratorLine(segmentButton: SegmentButton) {
        // Add a seprator line view
        let sepratorLineView = UIView()
        sepratorLineView.backgroundColor = sepratorLineColor
        sepratorLineView.frame.origin = CGPoint(x: segmentButton.frame.origin.x + segmentButton.frame.size.width, y: 0)
        sepratorLineView.frame.size = CGSize(width: 1.0, height: segmentButton.frame.size.height)
        addSubview(sepratorLineView)
    }
    
    private func splitSegmentView() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        if type == .bottomArrow {
            addTopAndBottomView()
        }
        
        let segmentWidth = frame.size.width / CGFloat(titlesArray.count)
        var originX: CGFloat = 0.0
        var index = kDefaultTagValue
        let sepratorLineWidth: CGFloat = type == .line ? 0 : 0.5
        
        for segmentTitle in titlesArray {
            //Add a button
            let segmentButton = SegmentButton(frame: CGRect(x: originX, y: sepratorLineWidth, width: segmentWidth, height: frame.size.height - (sepratorLineWidth * 2)))
            segmentButton.setTitle(segmentTitle, for: .normal)
            segmentButton.titleLabel?.font = font
            segmentButton.setTitleColor(normalTextColor, for: .normal)
            segmentButton.addTarget(self, action: #selector(segmentButtonPressed(button:)), for: .touchUpInside)
            segmentButton.tag = index
            segmentButton.clipsToBounds = false
            
            //Add a view Selection view
            let width = type == .line ? segmentButton.intrinsicContentSize.width : arrowImage?.size.width
            let height = type == .line ? 1 : arrowImage?.size.height
            let yPostition = type == .line ? segmentButton.frame.size.height - 10 : segmentButton.frame.size.height
            let lineView = UIImageView()
            lineView.frame.origin = CGPoint(x: segmentButton.frame.size.width / 2 - width!/2, y: yPostition)
            lineView.frame.size = CGSize(width: width!, height: height!)
            lineView.isHidden = true
            segmentButton.selectionView = lineView
            segmentButton.addSubview(lineView)
            addSubview(segmentButton)
            
            if type == .bottomArrow {
                lineView.image = arrowImage
                sepratorLine(segmentButton: segmentButton)
                lineView.backgroundColor = UIColor.clear
            } else {
                lineView.backgroundColor = selectionLineColor
            }
            
            //Change X position
            originX += segmentWidth + sepratorLineWidth
            
            // Change Button tag
            index += 1
        }
        
        // if title is greater than the by default select the first segment
        if titlesArray.count > 0 {
            segmentButtonPressed(button: viewWithTag(kDefaultTagValue) as! SegmentButton)
        }
    }
    
    private func handleArrowType(button: SegmentButton) {
        // Get previous selected view
        let previousSelectionButton = viewWithTag(selectedIndex + kDefaultTagValue) as! SegmentButton
        previousSelectionButton.backgroundColor = normalBGColor
        previousSelectionButton.selectionView?.isHidden = true
        previousSelectionButton.setTitleColor(normalTextColor, for: .normal)
        
        // Change selected index
        selectedIndex = button.tag - kDefaultTagValue
        button.backgroundColor = selectionBGColor
        button.setTitleColor(selectionTextColor, for: .normal)
        button.selectionView?.isHidden = false
    }
    
    private func handleLineType(button: SegmentButton) {
        // Get previous selected view
        let previousSelectionButton = viewWithTag(selectedIndex + kDefaultTagValue) as! SegmentButton
        previousSelectionButton.selectionView?.isHidden = true
        
        // Change selected index
        selectedIndex = button.tag - kDefaultTagValue
        button.selectionView?.isHidden = false
    }
    
    @objc private func segmentButtonPressed(button: SegmentButton) {
        if type == .line {
            handleLineType(button: button)
        } else {
            handleArrowType(button: button)
        }
        // If delegate is added the call then call the delgate method
        if let _ = delegate {
            delegate?.segmentSelected(atIndex: selectedIndex)
        }
    }
    
    func addTitles(withTitles: [String]) {
        titlesArray = withTitles
    }

}

class SegmentButton: UIButton {
    
    var selectionView: UIImageView?
    
}
