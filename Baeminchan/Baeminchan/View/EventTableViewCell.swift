//
//  EventTableViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var myPageControl = PageControlLabel()
    var imageArr: [UIImage] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeImageData()
        setUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func makeImageData(){
        for index in 1...10 {
            let imageName = "main_event_banner" + String(index)
            imageArr.append(UIImage(named: imageName)!)
        }
    }
    
    func setUI() {
        let height = 345 * scrollView.frame.width / 588
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        myPageControl = PageControlLabel(frame: CGRect(x: self.frame.maxX - 50, y: height - 30, width: 40, height: 20))   //
        imageArr.forEach(addPageToScrollView(with:))
        
        self.addSubview(myPageControl)
    }
    
    private func addPageToScrollView(with image: UIImage) {
        let height = 345 * scrollView.frame.width / 588
        let pageFrame = CGRect(
            origin: CGPoint(x: scrollView.contentSize.width, y: 0),
            size: CGSize(width: scrollView.frame.width, height: height)
        )
        print(scrollView.frame.height)
        let imageButtonView = UIButton(frame: pageFrame)
        imageButtonView.contentMode = .scaleAspectFill
        imageButtonView.setBackgroundImage(image, for: .normal)
        scrollView.addSubview(imageButtonView)
        
        scrollView.contentSize.width += self.frame.width
        myPageControl.numOfPages += 1
    }
}

extension EventTableViewCell {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        myPageControl.nowPage = page + 1
    }
}
