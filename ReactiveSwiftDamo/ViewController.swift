//
//  ViewController.swift
//  ReactiveSwiftDamo
//
//  Created by 王垒 on 2017/3/10.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import enum Result.NoError




public let WLWindowWidth = UIScreen.main.bounds.size.width

public let WLWindowHeight = UIScreen.main.bounds.size.height

public func RGB(r:CGFloat,_ g:CGFloat,_ b: CGFloat) -> UIColor{
    
    return UIColor (red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}



class ViewController: UIViewController,UITextFieldDelegate {

    var userNameTF       : UITextField!
    var passWordTF       : UITextField!
    var loginBtn         : UIButton!
    var phoneNumberLabel : UILabel!
    var passWordLabel    : UILabel!
    
    private var userNameIsValid : Bool{
    
        return userNameTF.text!.characters.count == 11 && self.isTelNumber(num: userNameTF.text!)
    }
    
    private var passWordIsValid : Bool{
    
        return passWordTF.text!.characters.count >= 8 && self.isTruePassWord(num: passWordTF.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.creatUI()
        self.checkTextInputValid()
    }

    func creatUI(){
    
        self.userNameTF = UITextField()
        self.userNameTF.frame = CGRect (x: 20, y: 80, width: WLWindowWidth - 40, height: 45)
        self.userNameTF.borderStyle = .roundedRect
        self.userNameTF.placeholder = "请输入你的手机号"
        self.userNameTF.delegate = self
        self.userNameTF.keyboardType = .numberPad
        self.userNameTF.textAlignment = .left
        self.userNameTF.adjustsFontSizeToFitWidth = true
        self.userNameTF.minimumFontSize = 14
        self.view.addSubview(self.userNameTF)
        
        
        self.phoneNumberLabel = UILabel()
        self.phoneNumberLabel.frame = CGRect (x: 20, y: 80+55, width: WLWindowWidth - 40, height: 21)
        self.phoneNumberLabel.backgroundColor = UIColor.white
        self.phoneNumberLabel.textColor = UIColor.red
        self.phoneNumberLabel.font = UIFont.systemFont(ofSize: 15)
        self.phoneNumberLabel.textAlignment = .left
        self.phoneNumberLabel.text = "请输入正确的手机号"
        self.view.addSubview(self.phoneNumberLabel)
        
        
        self.passWordTF = UITextField()
        self.passWordTF.frame = CGRect (x: 20, y: 80+55+21+10, width: WLWindowWidth - 40, height: 45)
        self.passWordTF.borderStyle = .roundedRect
        self.passWordTF.delegate = self
        self.passWordTF.placeholder = "密码为字母加数字8～16位"
        self.passWordTF.keyboardType = .default
        self.passWordTF.textAlignment = .left
        self.passWordTF.returnKeyType = .done
        self.passWordTF.adjustsFontSizeToFitWidth = true
        self.passWordTF.minimumFontSize = 14
        self.view.addSubview(self.passWordTF)
        
        
        self.passWordLabel = UILabel()
        self.passWordLabel.frame = CGRect (x: 20, y: 80+55+21+10+10+45, width: WLWindowWidth - 40, height: 21)
        self.passWordLabel.backgroundColor = UIColor.white
        self.passWordLabel.textColor = UIColor.red
        self.passWordLabel.textAlignment = .left
        self.passWordLabel.font = UIFont.systemFont(ofSize: 15)
        self.passWordLabel.text = "密码为字母加数字8～16位"
        self.view.addSubview(self.passWordLabel)
        
        self.loginBtn = UIButton()
        self.loginBtn.frame = CGRect (x: 20, y: 80+55+21+10+10+45+21+20, width: WLWindowWidth - 40, height: 55)
        self.loginBtn.setTitleColor(UIColor.white, for: .normal)
        self.loginBtn.backgroundColor = UIColor.lightGray
        self.loginBtn.setTitle("登录", for: .normal)
        self.view.addSubview(self.loginBtn)

    }
    
    func checkTextInputValid(){
    
        self.userNameTF.reactive.continuousTextValues.map({
        
            text in
            return text?.characters.count
        }).filter({
        
            characterCount in
            return (characterCount == 11 && self.isTelNumber(num: self.userNameTF.text!))
        }).observeValues{
        
            characterCount in
            print(characterCount ?? "")
        }
        
        let userNameValidSignal = self.userNameTF.reactive.continuousTextValues.map({
        
            text in
            return self.userNameIsValid
        })
        
        userNameValidSignal.map({
        
            userNameIsValid in
        
            return  userNameIsValid ? UIColor.black : UIColor.red
        }).observeValues{
        
            textColor in
            
            self.userNameTF.textColor = textColor
            
            self.phoneNumberLabel.isHidden = self.userNameIsValid
            
            self.passWordTF.isUserInteractionEnabled = self.userNameIsValid
            
        }
        
        let passWordValidSignal = self.passWordTF.reactive.continuousTextValues.map({
        
            text in
            
            return self.passWordIsValid
        })
        
        passWordValidSignal.map({
        
            passWordIsValid in
            return passWordIsValid ? UIColor.black : UIColor.red
        }).observeValues{
        
           textColor in
            self.passWordTF.textColor = textColor
            self.passWordLabel.isHidden = self.passWordIsValid
        }
        
        
        let loginBtnValidSignal = Signal.combineLatest(userNameValidSignal, passWordValidSignal).map{
        
            (userNameIsValid,passWordIsValid) in
            
            return userNameIsValid && passWordIsValid
        }
        
        loginBtnValidSignal.map({
        
            loginBtnValidSignal in
            return loginBtnValidSignal ? UIColor.red : UIColor.lightGray
        }).observeValues({
        
            backgroundColor in
            self.loginBtn.backgroundColor = backgroundColor
        })
        
        let loginBtnEnabledProperty = Property (initial: false, then: loginBtnValidSignal)
        
        let action = Action <(String,String),Bool,NoError>(enabledIf: loginBtnEnabledProperty){
        
            (userNameStr,passWordStr) in
        
            return self.creatLoginSignalProducer(withUserName: userNameStr, andPassWord: passWordStr)
           
        }
        
       
        action.values.observeValues{
        
            success in
            if success{
            
                self.showAlert()
            }
        }
        
        self.loginBtn.reactive.pressed = CocoaAction<UIButton>(action){
        
            _ in
            (self.userNameTF.text!, self.passWordTF.text!)
        }
        
    }
    
    
    private func creatLoginSignalProducer(withUserName username: String, andPassWord passWord: String) -> SignalProducer<Bool, NoError>{
    
        let (loginSignal, observer) = Signal<Bool, NoError>.pipe()
        
        let loginSiganlProducer = SignalProducer<Bool, NoError>(_ :loginSignal)
        self.login(withUserName: self.userNameTF.text!, andPassWord: self.passWordTF.text!){
        
            success in
            observer.send(value: success)
            observer.sendCompleted()
        }
       
        return loginSiganlProducer
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.userNameTF.resignFirstResponder()
        self.passWordTF.resignFirstResponder()
    }

    
    func  login(withUserName userName: String, andPassWord passWord: String,completion: @escaping (Bool) -> Void) {
        let delay = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
        
            let success = true
            completion(success)
        }
        
    }
    
    
  public func isTelNumber(num:String)->Bool{
    
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: num) == true)
            || (regextestcm.evaluate(with: num)  == true)
            || (regextestct.evaluate(with: num) == true)
            || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }
        else
        {
            return false
            
        }
    }
    
   public func isTruePassWord(num:String) -> Bool {
        
        let passWord = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let regextestpassWord = NSPredicate(format: "SELF MATCHES %@",passWord)
        if regextestpassWord.evaluate(with: num) == true {
            return true
        }else{
            
            return false
        }
    }

    
    func showAlert(){
        let alertView = UIAlertView(
            
            title:"恭喜你",
            message:"登录成功",
            delegate:nil,
            cancelButtonTitle:"OK"
        )
        
        alertView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

