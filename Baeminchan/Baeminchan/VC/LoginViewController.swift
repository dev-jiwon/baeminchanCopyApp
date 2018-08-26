//
//  LoginViewController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: LoginTextField!
    @IBOutlet var passwdTextField: LoginTextField!
    @IBOutlet var alartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        alartLabel.isHidden = true
        setNavigationItem()
    }
    
    @IBAction func SignUpButtonTouched(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") //Storyboard ID를 설정해줘야 한다.
        show(signUpViewController, sender: nil)
    }
    
    func setNavigationItem() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        })
        let myImage = UIImage(named: "backBlack")
        let backBTNImage = myImage?.withRenderingMode(.alwaysTemplate)
        let backBTN = UIBarButtonItem(image: backBTNImage,
                                      style: .done,
                                      target: self,
                                      action: #selector(dismissThisView))
        backBTN.tintColor = .black
        navigationItem.leftBarButtonItem = backBTN
    }
    
    @objc func dismissThisView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.popViewController(animated: true)
    }
}
// 일반 로그인
extension LoginViewController {
    @IBAction func normalLogin(_ sender: UIButton) {
        if !isItEmail(value: idTextField.text ?? ""){
            alartLabel.text = "아이디를 확인해 주세요."
            alartLabel.isHidden = false
            print("no id")
        } else if !isItPasswd(value: passwdTextField.text ?? "") {
            alartLabel.text = "비밀번호를를 확인해 주세요."
            alartLabel.isHidden = false
            print("no pw")
        } else {
            alartLabel.isHidden = true
            let urlString = "https://server.yeojin.me/api/users/auth-token/"
            let idData = idTextField.text?.data(using: .ascii)
            let pwData = passwdTextField?.text?.data(using: .ascii)
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(idData!, withName: "username")
                    multipartFormData.append(pwData!, withName: "password")
            },
                to: urlString,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                if json["detail"].stringValue == "" {
                                    print("로그인 성공입니다아ㅏㅏ")
                                    UserDefaults.standard.set(json["token"].stringValue, forKey: "userToken")
                                    self.dismissThisView()
                                } else if json["token"].stringValue == "" {
                                    print("로그인 실패입니다아아ㅏ")
                                    self.postAlert()
                                }
                            case .failure(let error):
                                print("nooooo")
                                print(error)
                            }
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            })
        }
    }
    
    func isItEmail(value: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let resultBool = emailTest.evaluate(with: value)
        return resultBool
    }
    
    func isItPasswd(value: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,16}")
        let resultBool = passwordTest.evaluate(with: value)
        return resultBool
    }
    
    func postAlert() {
        let alertController = UIAlertController(title: "아이디/비밀번호가 잘못되었습니다.",message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        //UIAlertActionStye.destructive 지정 글꼴 색상 변경
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            print("액션입니당")
        }
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
}

//카카오 로그인
extension LoginViewController {
    //아마 카카오 로그인 되게 했는데 로그인을 할때 id 값을 보내주면 될듯 싶다
    @IBAction func kakaoLogin(_ sender: UIButton) {
        let urlString = "https://server.yeojin.me/api/users/kakao/"
        guard let session = KOSession.shared() else {return}
        
        //close old session
        session.isOpen() ? session.close() : ()
        
        session.open { (error) in
            if !session.isOpen() {
                if let error = error as NSError? {
                    switch error.code {
                    case Int(KOErrorCancelled.rawValue):
                        print("Canceled")
                    default:
                        print(error.localizedDescription)
                    }
                }
            } else {
                print("Login Success")
                //                print(session.appKey)
                KOSessionTask.userMeTask { (error, userMe) in
                    guard error == nil else {return}
                    //                    print(userMe!.id!)
                    //                    print(session.token.accessToken)
                    let parameters: Parameters = [
                        "access_token" : session.token.accessToken,
                        ]
                    Alamofire
                        .request(urlString, method: .post, parameters: parameters)
                        .validate(statusCode: 200..<400)
                        .responseJSON(completionHandler: { (response) in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                print(json["token"].stringValue)            //이 데이터를 가져와서 사용하면 된다
                                UserDefaults.standard.set(json["token"].stringValue, forKey: "userToken")
                                self.dismissThisView()
                            case .failure(let error):
                                print(error)
                            }
                        })
                    
                }
            }
        }
    }
}

