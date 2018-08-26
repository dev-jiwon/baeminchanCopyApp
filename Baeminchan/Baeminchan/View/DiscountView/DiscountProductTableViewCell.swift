//
//  DiscountProductTableViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 17..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class DiscountProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var productArr: [ListProductModel] = []
    let MyCollectionViewCellId: String = "ProductCollectionViewCell"
    let singleContentHeight:CGFloat = 290
    let betweenContentSize:CGFloat = 10
    let betweenTwoContent: CGFloat = 30
    var numOfContent = 30
    lazy var contentHeight:CGFloat = (singleContentHeight + betweenTwoContent) * CGFloat(numOfContent)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("DiscountNotification"), object: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        setCollectionView()
        collectionView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DiscountProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionView() {
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CGFloat(betweenContentSize), CGFloat(betweenContentSize), CGFloat(betweenContentSize), CGFloat(betweenContentSize))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return betweenTwoContent
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let cellHeight = (view.frame.width - 20) * 296.281 / 500 + 21 + 16 + 15 + 23 + 20 //이미지, 타이틀, 서브타이틀, 별점, 가격, 기타
        return CGSize.init(width: UIScreen.main.bounds.width - 20, height: singleContentHeight) //수정요구
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! ProductCollectionViewCell
        let nowProduct = productArr[indexPath.row]
        let url = URL(string: nowProduct.thumbnailUrl)
        cell.imageView.kf.setImage(with: url)
        cell.mainTitle.text = nowProduct.rawName
        cell.subTitle.text = nowProduct.description
        cell.priceLabel.text = String(nowProduct.salePrice)
        cell.itemButton.tag = Int(nowProduct.id)!
        cell.cartButton.tag = Int(nowProduct.id)!
        cell.starReviewPoint.rating = Double(nowProduct.starPoint)
        cell.numOfReviews.text = String(nowProduct.numOfComment)
        
        //original가격 숨기거나 취소선을 이용해 보여주거나
        if nowProduct.price == 0 {
            cell.originalPriceLabel.isHidden = true
        } else {
            cell.originalPriceLabel.attributedText = myOriginalPrice(originalPrice: nowProduct.price)
        }
        
        if nowProduct.discountRate == 0 {
            cell.rangkingOrDiscountLabel.isHidden = true
        } else {
            cell.rangkingOrDiscountLabel.attributedText = myDiscountRate(discountRate: nowProduct.discountRate)
        }
        return cell
    }
}

//text 커스터마이징
extension DiscountProductTableViewCell {
    //원래 판매 가격에 취소선을 긋는다
    func myOriginalPrice(originalPrice: Int) -> NSMutableAttributedString {
        let originalPrice = String(originalPrice) + "원"
        let range = (originalPrice as NSString).range(of: originalPrice)
        let attributedString = NSMutableAttributedString(string: originalPrice)
        attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: 0, range: range)
        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: range)
        return attributedString
    }
    //할인률에 변화를 줌
    func myDiscountRate(discountRate: Int) -> NSMutableAttributedString {
        let myDiscountRate = String(discountRate) + "%"
        let font = UIFont.systemFont(ofSize: 11)
        let attributedString = NSMutableAttributedString(string: myDiscountRate)
        let range = (myDiscountRate as NSString).range(of: "%")
        attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        return attributedString
    }
}

//서버에서 데이터를 모두 받으면 실행됨
extension DiscountProductTableViewCell {
    @objc func notificationReceived(notification: Notification) {
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
        guard let notificationUserInfo = notification.userInfo as? [String: [ListProductModel]],
            let myDataArr = notificationUserInfo["dataArr"] else { return }
        numOfContent = myDataArr.count
        productArr = myDataArr
        collectionView.reloadData()
        print(myDataArr)
    }
}



