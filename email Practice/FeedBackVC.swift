//
//  FeedBackVC.swift
//  email Practice
//
//  Created by Tariq Almazyad on 6/2/20.
//  Copyright © 2020 ARMobileApps. All rights reserved.
//

import UIKit
import Combine
import Loaf
import MBProgressHUD
import SendGrid

struct FeedBackCategory {
    var name: String!
    init(name: String) {
        self.name = name
    }
}

class FeedBackVC: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var feedBackCategory = [FeedBackCategory(name  : "Event FeedBack"),
                            FeedBackCategory(name  : "Ticket Enquriy"),
                            FeedBackCategory(name  : "Report a Bug"),
                            FeedBackCategory(name  : "Feature Request")]
    private var emailManager = EmailManager()
    
    
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 9
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let categoryTextView : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Request Update"
        textField.adjustsFontForContentSizeCategory = true
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor.copy(alpha: 0.3)
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let commentsLabel : UILabel = {
          let label = UILabel()
          label.text = "Comments"
          label.numberOfLines = 0
          label.textAlignment = .left
          label.adjustsFontSizeToFitWidth = true
          label.minimumScaleFactor = 9
          label.font = UIFont.systemFont(ofSize: 20)
          label.textColor = .black
          return label
      }()
    
    let commentsTextView : UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textColor = .black
        textView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.black.cgColor.copy(alpha: 0.3)
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleSendTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var toolBarView: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: 0))
        toolBar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                         target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(handleDismissPickerView))
        toolBar.setItems([flexButton,doneButton], animated: true)
        
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupTextField()
        setupDismissKeyBoardGesture()
    }
    
    private func setupDismissKeyBoardGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func handleDismissKeyboard(){
        view.endEditing(true)
    }
    
    func setupTextField(){
        categoryTextView.delegate = self
        commentsTextView.delegate = self
        categoryTextView.inputView = pickerView
        categoryTextView.inputAccessoryView = toolBarView
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if categoryTextView.isFirstResponder {
            categoryTextView.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.commentsTextView.becomeFirstResponder()
            }
        }
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        // detect if both comments and category has text
        if commentsTextView.hasText, categoryTextView.hasText {
            // then enable the button and change its tint color
            sendButton.isEnabled = true
            sendButton.tintColor = .black
            // exit the function
            return
        }
        // disable sendButton if both comments and category are empty
        sendButton.isEnabled  = false
        sendButton.tintColor = .lightGray
    }
    
    
   
    func setupUI(){
        sendButton.isEnabled = false
        sendButton.tintColor = .lightGray
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "FeedBack"
        
        view.addSubview(categoryLabel)
        categoryLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil,
                             right: nil, paddingTop: 150, paddingLeft: 20,
                             paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        view.addSubview(categoryTextView)
        categoryTextView.anchor(top: categoryLabel.bottomAnchor, left: view.leftAnchor, bottom: nil,
                        right: view.rightAnchor, paddingTop: 10, paddingLeft: 20,
                        paddingBottom: 0, paddingRight: 20, width: 0, height: 60)
        categoryTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.addSubview(commentsLabel)
        commentsLabel.anchor(top: categoryTextView.bottomAnchor, left: view.leftAnchor, bottom: nil,
                             right: nil, paddingTop: 10, paddingLeft: 20,
                             paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        commentsLabel.centerXAnchor.constraint(equalTo: self.categoryLabel.centerXAnchor).isActive = true
        view.addSubview(commentsTextView)
        commentsTextView.anchor(top: commentsLabel.bottomAnchor, left: view.leftAnchor, bottom: nil,
                                right: view.rightAnchor, paddingTop: 10, paddingLeft: 20,
                                paddingBottom: 0, paddingRight: 20, width: 0, height: 200)
        view.addSubview(sendButton)
        sendButton.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 40, height: 30)
        sendButton.centerYAnchor.constraint(equalTo: self.categoryLabel.centerYAnchor).isActive = true
        
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return feedBackCategory.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return feedBackCategory[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextView.text = feedBackCategory[row].name
    }
    
    @objc func handleDismissPickerView(){
        categoryTextView.endEditing(true)
    }
    
    
    
    @objc func handleSendTapped(){
        self.commentsTextView.endEditing(true)
        guard let category = self.categoryTextView.text ,
              let comments = self.commentsTextView.text else { return  }
        self.handleDismissKeyboard()
        let form = FeedBackForm(category: category, comments: comments)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        emailManager.send(form: form) { (result) in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                switch result {
                case .success:
                    Loaf("This is success!", state: .success, sender: self).show()
                case .failure(let error):
                    Loaf("There is an error!!!! \(error.localizedDescription)", state: .error, sender: self).show()
                    print(error.localizedDescription)
                }
                self.clearForm()
            }
        }
    }
    
    private func clearForm(){
        commentsTextView.text = ""
        categoryTextView.text = ""
        // when clicl on the picker view , we show the first row again
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
}




struct FeedBackForm {
    let category : String?
    let comments : String?
}


struct EmailManager {
    
    func send(form: FeedBackForm,  completion:  @escaping (Result<Void, Error>)  -> Void) {
        
        let companyEmail = "datiy99963@qortu.com"
        let senderAddress = "teigan.khayden@andyes.net"
        guard let myApiKey = ProcessInfo.processInfo.environment["SG_API_KEY"] else { return  }
        let session = Session()
        session.authentication = Authentication.apiKey(myApiKey)
        let personalization = Personalization(recipients: companyEmail)

        let htmlContent = """
                <h1> hello world</h1>
                <p> Hello there my friend</p>
                """
        let htmlText = Content(contentType: .htmlText, value: htmlContent)
        
        let from = Address(email: senderAddress)
        
        let email = Email(personalizations: [personalization], from: from, content: [htmlText], subject: "This is a test email")
        
        do {
            try session.send(request: email, completionHandler: { (result) in
                switch result {
                case .success(let response):
                    print("response: \(response.statusCode)")
                    completion(.success(()))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            })
        } catch (let error) {
            completion(.failure(error))
        }
       
    }
}
