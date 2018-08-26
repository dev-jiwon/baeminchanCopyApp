//
//  PageControlCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 14..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//


import UIKit

class PageControlCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var productslist: Products?
    let pageControl = UIPageControl()
    var imageNameArr: [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification(notification:)), name: Notification.Name("detailPageTopScrollNoti"), object: nil)

        self.window?.rootViewController?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.window?.rootViewController?.navigationController?.navigationBar.shadowImage = UIImage()
        self.window?.rootViewController?.navigationController?.navigationBar.isTranslucent = true
        self.window?.rootViewController?.navigationController?.view.backgroundColor = .clear
    }
    
    @objc func notification(notification: Notification){
        guard let notificationUserInfo = notification.userInfo as? [String: [String]],
            let productslist = notificationUserInfo["productThumnailUrl"] else { return }
        self.imageNameArr = productslist
        setUI()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
    func setUI() {
        let height = scrollView.frame.width
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        imageNameArr.forEach(addPageToScrollView(with:))
        pageControl.frame = CGRect(
            x: self.frame.midX - 20, y: height - 30, width: 40, height: 20
        )
        self.addSubview(pageControl)
    }
    
    private func addPageToScrollView(with image: String) {
        guard image != "" else { return }
        let pageFrame = CGRect(
            origin: CGPoint(x: scrollView.contentSize.width, y: 0),
            size: CGSize(width: scrollView.frame.width, height: scrollView.frame.width)
        )
//        print(scrollView.frame.height)
        let imageButtonView = UIButton(frame: pageFrame)
        imageButtonView.contentMode = .scaleAspectFill
        imageButtonView.imageView?.contentMode = .scaleAspectFill
        let url = URL(string: image)
//        imageButtonView.imageView?.kf.setImage(with: url)
        imageButtonView.kf.setImage(with: url, for: .normal)
//        imageButtonView.setBackgroundImage(image, for: .normal)
        scrollView.addSubview(imageButtonView)
        
        scrollView.contentSize.width += self.frame.width
        pageControl.numberOfPages += 1
    }
}

extension PageControlCell {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}


