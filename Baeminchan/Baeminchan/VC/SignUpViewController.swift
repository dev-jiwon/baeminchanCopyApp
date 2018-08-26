//
//  SignUpViewController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let urlString = "https://server.yeojin.me/api/users/create/"
    
    let baeminColor = UIColor(red: 0.1843, green: 0.7255, blue: 0.7020, alpha: 1)   //초록색빛 기본 배민 색
    let toolBar = UIToolbar()   //툴바
    // 기본적으로 적용되는 값들
    var safeAreaTop:CGFloat = 0
    var safeAreaBottom:CGFloat = 0
    var defaultMinX:CGFloat = 0
    var defaultWidth:CGFloat = 0
    var defaultHeight:CGFloat = 0
    var betweenWithTop:CGFloat = 0
    
    //picker데이터
    var optionsYear: [String] = []
    var optionsMonth: [String] = []
    var optionsDay: [String] = []
    
    // 사용되는 뷰들
    let scrollView = UIScrollView()
    let emailTextField = SignUpTextField()
    let PWTextField = SignUpTextField()
    let PW2TextField = SignUpTextField()
    let nameTextField = SignUpTextField()
    let phoneNumberTextField = SignUpTextField()
    let getMMSButton = UIButton()
    let viewForPickers = UIView()   //Picker를 모두 담을 뷰
    let ageConditionCheckView = UIView() //나이 제한 있음을 알려주는 뷰
    let marketingConditionCheckView = UIView() //마케팅 정보 수신 체크박스 항목
    let lastConditionCheckView = LastConditionCheckView()
    let postButton = UIButton()
    
    //picker들
    let yearPickerTextField = PickerTextField()
    let monthPickerTextField = PickerTextField()
    let dayPickerTextField = PickerTextField()
    //picker에 필요한 데이터들
    var picker : UIPickerView!
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
    
    // 오류상황시 뷰를 올리고 내릴때 확인하기 위해
    var isNotiLabelHidden = [false, false, false]  //email, pw, pw확인 순으로 알림 label이 숨겨져있는 상태인지
    
    // 모든 이동해야할 뷰들 생성
    var allOfView: [UIView] = []
    
    // 오류 상황시 보여질 Label들
    let emailNotiLabel = SignUpNotiUILabel()
    let pwNotiLabel = SignUpNotiUILabel()
    let pw2NotiLabel = SignUpNotiUILabel()
    
    // 나이 제한 관련 글
    let ageConditionCheckLabel = smallCheckConditionLabel()
    let ageConditionCheckButton = UIButton()
    
    //scroll상태에 관련된것들
    let goToTopButton = UIButton()
    var isGoToTopButtonOn = false
    
    //회원가입 양식 준비 완료됐는지 확인
    var isItReadyToSignup = [false, false, false, false, false, false, false]   //이메일, 비밀번호, 이름, 폰번호, 생일, 이용약관, 개인정보 수집
    
    var birthday:String = ""
    var isPhoneNumOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(isPhoneNumOKNoti(notification:)), name: Notification.Name("isPhoneNumCheckOK"), object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setToolbar()
        setScrollViewAndNavigationBar()
        setDefaultValues()
        setTextFields()
        setButtons()
        setPickers()
        setAgeConditionCheck()
        setmarketingConditionCheck()
        LastConditionCheck()
        setPostButton()
        setGoToTopButton()
        scrollView.contentSize = CGSize(width: view.frame.width, height: allOfView[allOfView.count-1].frame.maxY + 150)
    }
    
    //View들의 위치를 잡을때 사용할만한 변수들을 지정
    func setDefaultValues() {
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let navigationBarHeight = navigationController?.navigationBar.frame.height
        safeAreaTop = topPadding! + navigationBarHeight!    //네비게이션바 바로 아래 위치
        safeAreaBottom = (window?.safeAreaInsets.bottom)!
        defaultMinX = 20
        defaultWidth = view.frame.width - defaultMinX * 2
        defaultHeight = 48
        betweenWithTop = 8
        allOfView = [emailTextField, PWTextField, PW2TextField, nameTextField, phoneNumberTextField, getMMSButton, viewForPickers, ageConditionCheckView, marketingConditionCheckView, lastConditionCheckView, postButton]
    }
    
    func returnViewMinY(beforeView: UIView) -> CGFloat{
        return beforeView.frame.maxY + betweenWithTop
    }
    
}

//스크롤뷰, 네비게이션바 세팅
extension SignUpViewController {
    func setScrollViewAndNavigationBar() {
        navigationItem.title = "회원가입"
        //뒤로가기 버튼 커스터마이징
        let myImage = UIImage(named: "backBlack")
        let backBTNImage = myImage?.withRenderingMode(.alwaysTemplate)
        let backBTN = UIBarButtonItem(image: backBTNImage,
                                      style: .done,
                                      target: self,
                                      action: #selector(postAlert))
        backBTN.tintColor = .black
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        scrollView.frame = view.frame
        scrollView.backgroundColor = UIColor(red: 0.9412, green: 0.9412, blue: 0.9412, alpha: 1)
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
}

//TextField 관련 Class들
extension SignUpViewController {
    func setTextFields() {
        setTextFieldFrame(textField: emailTextField, y: 15, placeHoldText: "이메일")
        emailTextField.keyboardType = .emailAddress
        
        setTextFieldFrame(textField: PWTextField, y: returnViewMinY(beforeView: emailTextField), placeHoldText: "비밀번호 (8-16자리 영문, 숫자 조합)")
        PWTextField.isSecureTextEntry = true
        
        setTextFieldFrame(textField: PW2TextField, y: returnViewMinY(beforeView: PWTextField), placeHoldText: "비밀번호 확인")
        PW2TextField.isSecureTextEntry = true
        
        setTextFieldFrame(textField: nameTextField, y: returnViewMinY(beforeView: PW2TextField), placeHoldText: "이름")
        
        setTextFieldFrame(textField: phoneNumberTextField, y: returnViewMinY(beforeView: nameTextField), placeHoldText: "휴대 전화 번호 (숫자만 입력해주세요)")
        phoneNumberTextField.keyboardType = .phonePad
        
        setNotiLabel(notiLabel: emailNotiLabel, from: emailTextField)
        setNotiLabel(notiLabel: pwNotiLabel, from: PWTextField)
        setNotiLabel(notiLabel: pw2NotiLabel, from: PW2TextField)
        
        emailTextField.inputAccessoryView = toolBar
        PWTextField.inputAccessoryView = toolBar
        PW2TextField.inputAccessoryView = toolBar
        nameTextField.inputAccessoryView = toolBar
        phoneNumberTextField.inputAccessoryView = toolBar
        
        emailTextField.delegate = self
        PWTextField.delegate = self
        PW2TextField.delegate = self
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        for i in 0...3 {
            (allOfView[i] as! SignUpTextField).addTarget(self, action: #selector(SignUpViewController.isItOk(_:)), for: UIControlEvents.editingDidEnd)
            (allOfView[i] as! SignUpTextField).addTarget(self, action: #selector(SignUpViewController.editBegin(_:)), for: UIControlEvents.editingDidBegin)
        }
    }
    
    func setTextFieldFrame(textField: SignUpTextField, y: CGFloat, placeHoldText: String ) {
        textField.frame = CGRect(x: defaultMinX, y: y, width: defaultWidth, height: defaultHeight)
        textField.placeholder = placeHoldText
        textField.returnKeyType = .go
        scrollView.addSubview(textField)
    }
    
    func setNotiLabel(notiLabel: SignUpNotiUILabel, from: UIView) {
        notiLabel.frame = CGRect(x: defaultMinX, y: from.frame.maxY + 5, width: from.frame.width, height: 20)
        scrollView.addSubview(notiLabel)
        notiLabel.isHidden = true
    }
    
    @IBAction func isItOk(_ sender: UITextField) {
        guard sender.text != "" else {return}
        switch sender {
        case emailTextField:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let resultBool = emailTest.evaluate(with: sender.text!)
            if resultBool { //메일 형식에 맞는지 확인
                isItReadyToSignup[0] = true
            } else {
                emailNotiLabel.text = "이메일 형식을 확인해 주세요."
                emailNotiLabel.isHidden = false
                isNotiLabelHidden[0] = true
                viewsMakeDown(from: 1)
                pwNotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PWTextField.frame.maxY + 5)
                pw2NotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PW2TextField.frame.maxY + 5)
            }
            
        case PWTextField:
            //8~16자리, 영문, 숫자 조합
            let password = PWTextField.text!
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,16}")
            let resultBool = passwordTest.evaluate(with: password)
            if resultBool {
                isItReadyToSignup[1] = true
                if !pw2NotiLabel.isHidden, PWTextField.text! == PW2TextField.text! {
                    pw2NotiLabel.isHidden = true
                    isNotiLabelHidden[2] = false
                    viewsMakeUp(from: 3)
                } else if pw2NotiLabel.isHidden {
                    pw2NotiLabel.text = "비밀번호와 확인 비밀번호가 다릅니다."
                    pw2NotiLabel.isHidden = false
                    isNotiLabelHidden[2] = true
                    viewsMakeDown(from: 3)
                    pw2NotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PW2TextField.frame.maxY + 5)
                }
            } else {
                pwNotiLabel.text = "8~16글자 사이의 영문, 숫자 조합만으로 이루어져야합니다."
                pwNotiLabel.isHidden = false
                isNotiLabelHidden[1] = true
                viewsMakeDown(from: 2)
                pwNotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PWTextField.frame.maxY + 5)
                pw2NotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PW2TextField.frame.maxY + 5)
            }
            
        case PW2TextField:
            if isNotiLabelHidden[1] {
                pw2NotiLabel.text = "8~16글자 사이의 영문, 숫자 조합만으로 이루어져야합니다."
                pw2NotiLabel.isHidden = false
                isNotiLabelHidden[2] = true
                viewsMakeDown(from: 3)
                pw2NotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PW2TextField.frame.maxY + 5)
            } else if PWTextField.text != PW2TextField.text {
                pw2NotiLabel.text = "비밀번호와 확인 비밀번호가 다릅니다."
                pw2NotiLabel.isHidden = false
                isNotiLabelHidden[2] = true
                viewsMakeDown(from: 3)
                pw2NotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PW2TextField.frame.maxY + 5)
            }
            
        default:
            print("what")
        }
        
        
    }
    
    @IBAction func editBegin(_ sender: UITextField) {
        switch sender {
        case emailTextField:
            if isNotiLabelHidden[0], emailNotiLabel.text == "이메일 형식을 확인해 주세요."{
                emailNotiLabel.isHidden = true
                isNotiLabelHidden[0] = false
                viewsMakeUp(from: 1)
                pwNotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PWTextField.frame.maxY + 5)
                pw2NotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PW2TextField.frame.maxY + 5)
            }
        case PWTextField:
            if isNotiLabelHidden[1], pwNotiLabel.text == "8~16글자 사이의 영문, 숫자 조합만으로 이루어져야합니다." {
                pwNotiLabel.isHidden = true
                isNotiLabelHidden[1] = false
                viewsMakeUp(from: 2)
                pw2NotiLabel.frame.origin = CGPoint(x: defaultMinX, y: PW2TextField.frame.maxY + 5)
            }
        case PW2TextField:
            if isNotiLabelHidden[2], pw2NotiLabel.text == "8~16글자 사이의 영문, 숫자 조합만으로 이루어져야합니다." || pw2NotiLabel.text == "비밀번호와 확인 비밀번호가 다릅니다." {
                pw2NotiLabel.isHidden = true
                isNotiLabelHidden[2] = false
                viewsMakeUp(from: 3)
            }
        default:
            print("ohoho")
        }
    }
    
    
    func viewsMakeDown(from: Int) {
        for view in from..<allOfView.count {
            allOfView[view].frame.origin = CGPoint(x: allOfView[view].frame.minX, y: allOfView[view].frame.minY + defaultHeight + betweenWithTop - 20)
        }
    }
    
    func viewsMakeUp(from: Int) {
        for view in from..<allOfView.count {
            allOfView[view].frame.origin = CGPoint(x: allOfView[view].frame.minX, y: allOfView[view].frame.minY - defaultHeight - betweenWithTop + 20)
        }
    }
}

//UIButton과 관련된 Class들
extension SignUpViewController {
    func setButtons() {
        getMMSButton.frame = CGRect(x: defaultMinX, y: returnViewMinY(beforeView: phoneNumberTextField), width: defaultWidth, height: defaultHeight)
        getMMSButton.setTitle("인증번호 받기", for: .normal)
        getMMSButton.setTitleColor(.white, for: .normal)
        getMMSButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        getMMSButton.backgroundColor = UIColor(red: 0.4078, green: 0.4078, blue: 0.4078, alpha: 1)
        getMMSButton.addTarget(self, action: #selector(SignUpViewController.getMMSAtion(_:)), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(getMMSButton)
    }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func setPickers() {
        makeDayData()
        let myWidth:CGFloat = defaultWidth / 3
        viewForPickers.frame = CGRect(x: 20, y: returnViewMinY(beforeView: getMMSButton), width: defaultWidth, height: defaultHeight)
        yearPickerTextField.frame = CGRect(x: 0, y: 0, width: myWidth, height: defaultHeight)
        monthPickerTextField.frame = CGRect(x: myWidth, y: 0, width: myWidth, height: defaultHeight)
        dayPickerTextField.frame = CGRect(x: myWidth * 2, y: 0, width: myWidth, height: defaultHeight)
        scrollView.addSubview(viewForPickers)
        viewForPickers.addSubview(yearPickerTextField)
        viewForPickers.addSubview(monthPickerTextField)
        viewForPickers.addSubview(dayPickerTextField)
        
        yearPickerTextField.delegate = self
        monthPickerTextField.delegate = self
        dayPickerTextField.delegate = self
    }
    
    func makeDayData() {
        for index in 1910...2003 {
            optionsYear.append(String(index))
        }
        for index in 1...12 {
            optionsMonth.append(String(format: "%02d", index))
        }
        for index in 1...31 {
            optionsDay.append(String(format: "%02d", index))
        }
    }
    
    // number of components in picekr view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // return number of elements in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // get number of elements in each pickerview
        switch activeTextField {
        case 1:
            return optionsYear.count
        case 2:
            return optionsMonth.count
        case 3:
            return optionsDay.count
        default:
            return 0
        }
    }
    
    // return "content" for picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // return correct content for picekr view
        switch activeTextField {
        case 1:
            return optionsYear[row]
        case 2:
            return optionsMonth[row]
        case 3:
            return optionsDay[row]
        default:
            return ""
        }
        
    }
    
    // get currect value for picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // set currect active value based on picker view
        switch activeTextField {
        case 1:
            activeValue = optionsYear[row]
        case 2:
            activeValue = optionsMonth[row]
        case 3:
            activeValue = optionsDay[row]
        default:
            activeValue = ""
        }
    }
    
    // start editing text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // set up correct active textField (no)
        activeTF = textField
        switch textField {
        case yearPickerTextField:
            activeTextField = 1
        case monthPickerTextField:
            activeTextField = 2
        case dayPickerTextField:
            if yearPickerTextField.text != "", monthPickerTextField.text != "", yearPickerTextField.text != "선택", monthPickerTextField.text != "선택"{
                let lastDay = giveMeLastDayOfThisMonth(year: Int(yearPickerTextField.text!)!, month: Int(monthPickerTextField.text!)!)
                optionsDay = []
                for index in 1...lastDay {
                    optionsDay.append(String(format: "%02d", index))
                }
            }
            activeTextField = 3
        default:
            return
        }
        
        // set active Text Field
        
        self.pickUpValue(textField: textField)
        
    }
    
    // show picker view
    func pickUpValue(textField: UITextField) {
        
        // create frame and size of picker view
        picker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 216)))
        
        // deletates
        picker.delegate = self
        picker.dataSource = self
        
        // if there is a value in current text field, try to find it existing list
        if let currentValue = textField.text {
            
            var row : Int?
            
            // look in correct array
            switch activeTextField {
            case 1:
                row = optionsYear.index(of: currentValue)
            case 2:
                row = optionsMonth.index(of: currentValue)
            case 3:
                row = optionsDay.index(of: currentValue)
            default:
                row = nil
            }
            
            // we got it, let's set select it
            if row != nil {
                picker.selectRow(row!, inComponent: 0, animated: true)
            }
        }
        textField.inputView = self.picker
        
        // toolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // buttons for toolBar
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneClick))
        let upButton = UIBarButtonItem(barButtonHiddenItem: .Up, target: self, action: nil)
        let downButton = UIBarButtonItem(barButtonHiddenItem: .Down, target: self, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([upButton, downButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    
    // done
    @objc func doneClick() {
        activeTF.text = activeValue
        activeTF.resignFirstResponder()
    }
    
    // cancel
    @objc func cancelClick() {
        activeTF.resignFirstResponder()
    }
}

//나이 제한 관련
extension SignUpViewController {
    func setAgeConditionCheck() {
        ageConditionCheckView.frame = CGRect(x: defaultMinX, y: returnViewMinY(beforeView: viewForPickers), width: defaultWidth, height: defaultHeight - 15)
        ageConditionCheckLabel.text = "만 14세 이상 가입 가능합니다."
        var textSize = ageConditionCheckLabel.text?.size(withAttributes: [.font: ageConditionCheckLabel.font]) ?? .zero
        ageConditionCheckLabel.frame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        let attributedString = NSMutableAttributedString(string: "내용보기")
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
        ageConditionCheckButton.setAttributedTitle(attributedString, for: .normal)
        textSize = ageConditionCheckButton.titleLabel?.text?.size(withAttributes: [.font: ageConditionCheckButton.titleLabel!.font]) ?? .zero
        ageConditionCheckButton.frame = CGRect(x: ageConditionCheckLabel.frame.maxX + 2, y: 0, width: textSize.width, height: textSize.height-2)
        ageConditionCheckButton.titleLabel?.textColor = .lightGray
        ageConditionCheckButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        ageConditionCheckView.addSubview(ageConditionCheckLabel)
        ageConditionCheckView.addSubview(ageConditionCheckButton)
        scrollView.addSubview(ageConditionCheckView)
        ageConditionCheckButton.addTarget(self, action: #selector(SignUpViewController.aboutAgeCondition(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func aboutAgeCondition(_ sender: UIButton) {
        let popup: DetailView = UINib(nibName: "DetailView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! DetailView
        popup.frame = self.view.frame // 팝업뷰를 화면크기에 맞추기
        let viewColor = UIColor.black
        popup.backgroundColor = viewColor.withAlphaComponent(0.3)
        self.view.addSubview(popup)
    }
}

//마케팅 정보 수신 관련 뷰
extension SignUpViewController {
    func setmarketingConditionCheck() {
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: defaultWidth, height: defaultHeight)
        titleLabel.text = "마케팅 정보 수신 (선택)"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        marketingConditionCheckView.addSubview(titleLabel)
        
        let myMarkettingConditionCheck = MarketingConditionCheckView()
        myMarkettingConditionCheck.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 2, width: defaultWidth, height: myMarkettingConditionCheck.myHeight)
        marketingConditionCheckView.addSubview(myMarkettingConditionCheck)
        
        let subContent = smallCheckConditionLabel()
        subContent.frame = CGRect(x: 5, y: myMarkettingConditionCheck.frame.maxY + 5, width: defaultWidth - 10, height: 50)
        subContent.numberOfLines = 0
        subContent.text = "1. App Push 수신동의 상태는 앱내 설정메뉴에서 별도로 변경할 수 있습니다.\n2. 상품 구매 정보는 수신 동의 여부와 관계없이 발송됩니다."
        marketingConditionCheckView.addSubview(subContent)
        
        marketingConditionCheckView.frame = CGRect(x: defaultMinX, y: returnViewMinY(beforeView: ageConditionCheckView), width: defaultWidth, height: subContent.frame.maxY)
        scrollView.addSubview(marketingConditionCheckView)
    }
}

//마지막에 있는 이용약관 동의 관련 뷰
extension SignUpViewController{
    func LastConditionCheck() {
        lastConditionCheckView.frame = CGRect(x: defaultMinX, y: returnViewMinY(beforeView: marketingConditionCheckView) + 20, width: defaultWidth, height: lastConditionCheckView.myHeight)
        lastConditionCheckView.backgroundColor = .white
        scrollView.addSubview(lastConditionCheckView)
        
    }
}

//마지막 회원가입 버튼
extension SignUpViewController{
    func setPostButton() {
        postButton.frame = CGRect(x: defaultMinX, y: returnViewMinY(beforeView: lastConditionCheckView), width: defaultWidth, height: defaultHeight + 5)
        postButton.setTitle("회원가입", for: .normal)
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        postButton.backgroundColor = baeminColor
        postButton.setTitleColor(.white, for: .normal)
        scrollView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(SignUpViewController.letsSignup(_:)), for: UIControlEvents.touchUpInside)
    }
}

extension SignUpViewController{
    func setToolbar(){
        // toolBar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // buttons for toolBar
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(cancelClick))
        let upButton = UIBarButtonItem(barButtonHiddenItem: .Up, target: self, action: nil)
        let downButton = UIBarButtonItem(barButtonHiddenItem: .Down, target: self, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([upButton, downButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
}

extension SignUpViewController: UIScrollViewDelegate{
    func setGoToTopButton() {
        goToTopButton.frame = CGRect(x: view.frame.maxX - 60, y: view.frame.maxY - safeAreaBottom - 60, width: 50, height: 50)
        goToTopButton.setImage(UIImage(named: "gotoTop"), for: .normal)
        goToTopButton.layer.cornerRadius = goToTopButton.frame.width/2
        goToTopButton.layer.masksToBounds = true
        goToTopButton.backgroundColor = .white
        view.addSubview(goToTopButton)
        goToTopButton.isHidden = true
        goToTopButton.addTarget(self, action: #selector(SignUpViewController.goToTopButtonClicked), for: UIControlEvents.touchUpInside)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isGoToTopButtonOn {
            if scrollView.bounds.minY > CGFloat(1) {
                isGoToTopButtonOn = true
                self.goToTopButton.isHidden = false
            }
        } else {
            if scrollView.bounds.minY < CGFloat(1) {
                isGoToTopButtonOn = false
                self.goToTopButton.isHidden = true
            }
        }
    }
    
    @objc func goToTopButtonClicked() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -safeAreaTop), animated: true)
    }
    
    
}

//키보드에서 toolbar 아래, 위 버튼을 쉽게 만들기 위해
extension UIBarButtonItem {
    enum HiddenItem: Int {
        case Arrow = 100
        case Back = 101
        case Forward = 102
        case Up = 103
        case Down = 104
    }
    
    convenience init(barButtonHiddenItem: HiddenItem, target: AnyObject?, action: Selector?) {
        let systemItem = UIBarButtonSystemItem(rawValue: barButtonHiddenItem.rawValue)
        self.init(barButtonSystemItem: systemItem!, target: target, action: action)
    }
}

extension SignUpViewController{
    func giveMeLastDayOfThisMonth(year: Int, month: Int) -> Int {
        var monthOfDay = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if year % 4 == 0 {
            monthOfDay[1] += 1
        }
        return monthOfDay[month - 1]
    }
}


extension SignUpViewController{
    @IBAction func letsSignup(_ sender: UIButton) {
        guard isItReadyToSignup[0] else { makeAlert(title: "이메일을 확인해주세요"); return }
        guard isItReadyToSignup[1], PWTextField.text! == PW2TextField.text! else { makeAlert(title: "비밀번호를 확인해주세요"); return }
        guard nameTextField.text! != "" else { makeAlert(title: "이름을 입력해주세요"); return  }
        guard isPhoneNumberOk() else { makeAlert(title: "전화번호를 확인해주세요"); return }
        guard isPhoneNumOK else { makeAlert(title: "전화번호를 인증해주세요"); return}
        guard isBirthdayOk() else { makeAlert(title: "생일을 확인해주세요"); return }
        guard lastConditionCheckView.conditionOption1.isItChecked else { makeAlert(title: "이용약관에 동의해주세요"); return }
        guard lastConditionCheckView.conditionOption2.isItChecked else { makeAlert(title: "개인정보 수집에 동의해주세요"); return }
        
        let parameters: Parameters = [
            "username" : emailTextField.text!,
            "password" : PWTextField.text!,
            "email" : emailTextField.text!,
            "fullname" : nameTextField.text!,
            "contact_phone" : makePhoneNumber(phoneNum: phoneNumberTextField.text!),
            "birthday" : birthday
        ]
        Alamofire
            .request(urlString, method: .post, parameters: parameters)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    self.navigationController?.setNavigationBarHidden(true, animated: false)
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                    print(value)
                case .failure(let error):
                    self.makeAlert(title: "다시한번 확인 부탁드립니다.")
                    print(error)
                }
            })
    }
    
    func makeAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelButton)
        self.present(alertController,animated: true,completion: nil)
    }
    
    func isPhoneNumberOk() -> Bool {
        let phoneNumber = phoneNumberTextField.text!
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{11,11}")
        return phoneNumberTest.evaluate(with: phoneNumber)
    }
    
    func isBirthdayOk() -> Bool {
        guard yearPickerTextField.text! != "" else { return false }
        guard monthPickerTextField.text! != "" else { return false }
        guard dayPickerTextField.text! != "" else { return false }
        birthday = "\(yearPickerTextField.text!)-\(monthPickerTextField.text!)-\(dayPickerTextField.text!)"
        print(birthday)
        return true
    }
    
    func makePhoneNumber(phoneNum: String) -> String {
        var myValue = phoneNum
        let first = myValue.index(myValue.startIndex, offsetBy: 3)
        myValue.insert("-", at: first)
        let second = myValue.index(myValue.startIndex, offsetBy: 8)
        myValue.insert("-", at: second)
        return myValue
    }
    
    @objc func postAlert() {
        let alertController = UIAlertController(title: "배민찬 회원가입을 취소하시겠습니까?",message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelButton = UIAlertAction(title: "아니오", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        alertController.addAction(okAction)
        
        self.present(alertController,animated: true,completion: nil)
    }
    
}

//폰 인증
extension SignUpViewController {
     @IBAction func getMMSAtion(_ sender: UIButton) {
        if isPhoneNumberOk() {
            getMMSAlamofire()
            
        } else {
            //Alert를 보냄
            let alertController = UIAlertController(title: "전화번호를 확인해주세요",message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: "예", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancelButton)
            self.present(alertController,animated: true,completion: nil)
        }
    }
    
    func getMMSAlamofire() {
        let url = "https://server.yeojin.me/api/users/phone/"
        let phoneNumber = makePhoneNumber(phoneNum: phoneNumberTextField.text!)
        let parameters: Parameters = ["contact_phone": phoneNumber]
        Alamofire
            .request(url, method: .post, parameters: parameters)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    print("폰될각이다")
                    let json = JSON(value)
                    let resultValue = json["auth_key"].stringValue
                    let popup: CheckMMSVIew = UINib(nibName: "CheckMMSVIew", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! CheckMMSVIew
                    popup.frame = self.view.frame // 팝업뷰를 화면크기에 맞추기
                    let viewColor = UIColor.black
                    popup.backgroundColor = viewColor.withAlphaComponent(0.3)
                    popup.textField.layer.borderWidth = 0.5
                    popup.textField.layer.borderColor = UIColor.lightGray.cgColor
                    popup.phoneNum = phoneNumber
                    popup.myKey = resultValue
                    self.view.addSubview(popup)
                    
                    print(value)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    @objc func isPhoneNumOKNoti(notification: Notification) {
        guard let notificationUserInfo = notification.userInfo as? [String: Bool],
            let isItOk = notificationUserInfo["isPhoneNumCheckOK"] else { return }
        isPhoneNumOK = isItOk
        if isItOk {
            getMMSButton.backgroundColor = baeminColor
            getMMSButton.setTitle("인증 완료", for: .normal)
            getMMSButton.isEnabled = false
        }
        print(isItOk)
    }
}
