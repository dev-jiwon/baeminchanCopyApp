//
//  ProductCategory.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import Foundation

//enum CategoryOfProductCategory: String{
//
//
//    case parentCategory = "parent_category"
//    case category
//}

//상위 카테고리
enum parentCategory: String {
    case 추천 = "good"
    case 밑반찬 = "side-dish"
    case 국 = "soup"
    case 메인반찬 = "main-courses"
    case 아이반찬 = "kids"
    case 정기반찬 = "set-of-side"
    case 간편식 = "fresh"
    case 간식 = "refreshment"
}
enum 추천: String {
    case 아무거나
}

enum 밑반찬: String {
    case 무침, 나물무침, 볶음, 조림, 김치, 전, 장아찌·피클, 젓갈·장·소스, 세트
}

enum 국: String {
    case 국, 찌개, 탕, 전골, 세트
}

enum 메인반찬: String {
    case 고기반찬, 해산물반찬, 생선반찬, 덮밥, 튀김, 면, 양식, 아시아식, 분식, 죽, 세트
}

enum 아이반찬: String {
    case 이유식초기중기 = "이유식 초기/중기"
    case 이유식후기완료기 = "이유식 후기/완료기"
    case 아이반찬, 어린이반찬, 간식·음료
}

enum 정기반찬: String {
    case 전체보기, 아이반찬
    case 일이인 = "1~2인"
    case 삼사인 = "3~4인"
}

enum 간편식: String {
    case 간편반찬, 간편국찌개, 간편식
}

enum 간식: String {
    case 베이커리, 과일, 주스, 스무디, 유제품·커피, 기타간식
}
let categoryNameArr = ["배민찬 추천", "밑반찬", "메인반찬", "국.찌개", "간식", "아이반찬", "정기반찬", "간편식"]
let categoryStringDic: [parentCategory:[String]] = [.밑반찬:[밑반찬.무침.rawValue, 밑반찬.나물무침.rawValue, 밑반찬.볶음.rawValue, 밑반찬.조림.rawValue, 밑반찬.김치.rawValue, 밑반찬.전.rawValue, 밑반찬.장아찌·피클.rawValue, 밑반찬.젓갈·장·소스.rawValue, 밑반찬.세트.rawValue],
                                                    .메인반찬:[메인반찬.고기반찬.rawValue, 메인반찬.해산물반찬.rawValue, 메인반찬.생선반찬.rawValue, 메인반찬.덮밥.rawValue, 메인반찬.튀김.rawValue, 메인반찬.면.rawValue, 메인반찬.양식.rawValue, 메인반찬.아시아식.rawValue, 메인반찬.분식.rawValue, 메인반찬.죽.rawValue, 메인반찬.세트.rawValue],
                                                    .국:[국.국.rawValue, 국.찌개.rawValue, 국.탕.rawValue, 국.전골.rawValue, 국.세트.rawValue],
                                                    .간식:[간식.베이커리.rawValue, 간식.과일.rawValue, 간식.주스.rawValue, 간식.스무디.rawValue, 간식.유제품·커피.rawValue, 간식.기타간식.rawValue],
                                                    .아이반찬:[아이반찬.이유식초기중기.rawValue, 아이반찬.이유식후기완료기.rawValue, 아이반찬.아이반찬.rawValue, 아이반찬.어린이반찬.rawValue, 아이반찬.간식·음료.rawValue],
                                                    .정기반찬:[정기반찬.전체보기.rawValue, 정기반찬.아이반찬.rawValue, 정기반찬.일이인.rawValue, 정기반찬.삼사인.rawValue],
                                                    .간편식:[간편식.간편반찬.rawValue, 간편식.간편국찌개.rawValue, 간편식.간편식.rawValue]
]

let parentCategoryArr: [parentCategory] = [.추천, .밑반찬, .메인반찬, .국, .간식, .아이반찬, .정기반찬, .간편식]
let 밑반찬Arr: [밑반찬] = [.무침, .나물무침, .볶음, .조림, .김치, .전, .장아찌·피클, .젓갈·장·소스, .세트]
let 메인반찬Arr: [메인반찬] = [.고기반찬, .해산물반찬, .생선반찬, .덮밥, .튀김, .면, .양식, .아시아식, .분식, .죽, .세트]
let 국Arr: [국] = [.국, .찌개, .탕, .전골, .세트]
let 간식Arr: [간식] = [.베이커리, .과일, .주스, .스무디, .유제품·커피, .기타간식]
let 아이반찬Arr: [아이반찬] = [.이유식초기중기, .이유식후기완료기, .아이반찬, .어린이반찬, .간식·음료]
let 정기반찬Arr: [정기반찬] = [.전체보기, .아이반찬, .일이인, .삼사인]
let 간편식Arr: [간편식] = [.간편반찬, .간편국찌개, .간편식]
//let categoryDic: [parentCategory:[Any]] = [.밑반찬:[밑반찬.무침, 밑반찬.나물무침, 밑반찬.볶음, 밑반찬.조림, 밑반찬.김치, 밑반찬.전, 밑반찬.장아찌·피클, 밑반찬.젓갈·장·소스, 밑반찬.세트],
//                                  .메인반찬:[메인반찬.고기반찬, 메인반찬.해산물반찬, 메인반찬.생선반찬, 메인반찬.덮밥, 메인반찬.튀김, 메인반찬.면, 메인반찬.양식, 메인반찬.아시아식, 메인반찬.분식, 메인반찬.죽, 메인반찬.세트],
//                                  .국:[국.국, 국.찌개, 국.탕, 국.전골, 국.세트],
//                                  .간식:[간식.베이커리, 간식.과일, 간식.주스, 간식.스무디, 간식.유제품·커피, 간식.기타간식],
//                                  .아이반찬:[아이반찬.이유식초기중기, 아이반찬.이유식후기완료기, 아이반찬.아이반찬, 아이반찬.어린이반찬, 아이반찬.간식·음료],
//                                  .정기반찬:[정기반찬.전체보기, 정기반찬.아이반찬, 정기반찬.일이인, 정기반찬.삼사인],
//                                  .간편식:[간편식.간편반찬, 간편식.간편국찌개, 간편식.간편식]
//]
