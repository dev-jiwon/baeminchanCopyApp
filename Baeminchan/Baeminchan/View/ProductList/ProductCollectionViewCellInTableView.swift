//
//  ProductCollectionViewCellInTableView.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCollectionViewCellInTableView: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var productArr: [ListProductModel] = []
    var nowPageCategoryName = "배민찬 추천"
    let MyCollectionViewCellId: String = "ProductCollectionViewCell"
    let MyMoreButtonCellId: String = "ProductListMoreCollectionViewCell"
    let singleContentHeight:CGFloat = 290
    let betweenContentSize:CGFloat = 10
    let betweenTwoContent: CGFloat = 30
    let moreButtonHeight: CGFloat = 40
    var numOfContent = 30
    var nowPage = 0
    //    lazy var contentHeight:CGFloat = (singleContentHeight + betweenTwoContent) * CGFloat(numOfContent)
    
    static var aaaa:CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        setCollectionView()
        collectionView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("notiSetMainData"), object: nil)   //noti2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ProductCollectionViewCellInTableView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionView() {
        let productNibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        collectionView.register(productNibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        let moreNibCell = UINib(nibName: MyMoreButtonCellId, bundle: nil)
        collectionView.register(moreNibCell, forCellWithReuseIdentifier: MyMoreButtonCellId)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return productArr.count
        case 1:
            return 1
        default:
            return 1
        }
        
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
        switch indexPath.section {
        case 0:
            //        let cellHeight = (view.frame.width - 20) * 296.281 / 500 + 21 + 16 + 15 + 23 + 20 //이미지, 타이틀, 서브타이틀, 별점, 가격, 기타
            return CGSize.init(width: UIScreen.main.bounds.width - 20, height: singleContentHeight) //수정요구
        case 1:
            return CGSize.init(width: UIScreen.main.bounds.width - 20, height: moreButtonHeight)
        default:
            return CGSize.init(width: UIScreen.main.bounds.width - 20, height: moreButtonHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
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
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMoreButtonCellId, for: indexPath) as! ProductListMoreCollectionViewCell
            cell.categoryName.text = nowPageCategoryName
            cell.aboutPageNum = nowPage
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMoreButtonCellId, for: indexPath) as! ProductListMoreCollectionViewCell
            return cell
        }
    }
}

//text 커스터마이징
extension ProductCollectionViewCellInTableView {
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
extension ProductCollectionViewCellInTableView {
    @objc func notificationReceived(notification: Notification) {
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
        guard let notificationUserInfo = notification.userInfo as? [String: Any],
            let myDataArr = notificationUserInfo["dataArr"] as? [ListProductModel], //서버에서 받아온 데이터 arr
            let myNowPage = notificationUserInfo["numberOfItem"] as? Int else { return }    //현제 페이지
        nowPage = myNowPage
        print(">>>>>\(nowPage)<<<<<")
        switch myNowPage {
        case 0:
            nowPageCategoryName = "배민찬 추천"
        case 1:
            nowPageCategoryName = "밑반찬"
        case 2:
            nowPageCategoryName = "메인반찬"
        case 3:
            nowPageCategoryName = "국·찌개"
        case 4:
            nowPageCategoryName = "간식"
        default:
            nowPageCategoryName = "error"
        }
        numOfContent = myDataArr.count
        productArr = myDataArr
        collectionView.reloadData()
        //아래 코드에 문제가 있음
        //        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
        //                                          at: .top,
        //                                          animated: false)
    }
}

