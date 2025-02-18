//
//  DemoUserViewController.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 18/07/24.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI

class LoginUserViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: UserViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "Login"
        view.headerTitle.font = appearance.font.getFont(forTypo: .h3)
        view.headerTitle.textColor = .black
        view.headerTitle.textAlignment = .center
        view.backgroundColor = .white
        
        return view
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var userNameView: FormTextWithTitleView = {
        
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "Email"
        view.formTitleLabel.textColor = .black
        
        view.formTextView.inputTextField.autocapitalizationType = .none
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter email",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!
            ]
        )
        
        return view
    }()
    
    lazy var passwordView: FormTextWithTitleView = {
        
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "Password"
        view.formTitleLabel.textColor = .black
        
        view.formTextView.copyButton.isHidden = false
        view.formTextView.copyButton.setImage(appearance.images.eye.withRenderingMode(.alwaysTemplate), for: .normal)
        view.formTextView.copyButton.imageView?.tintColor = .darkGray
        
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        view.formTextView.inputTextField.isSecureTextEntry = true
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!
            ]
        )
        
        view.formTextView.copyButton.addTarget(self, action: #selector(showPasswordKeyTapped), for: .touchUpInside)
        
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = appearance.colors.appGray
        button.addTarget(self, action: #selector(signupUser), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.ismTapFeedBack()
        return button
    }()
    
    let optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var userOne: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Demo User: 1 (Monikahi)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.backgroundColor = appearance.colors.appLightGray
        button.layer.cornerRadius = 5
        button.tag = 0
        button.addTarget(self, action: #selector(toggleUser(_:)), for: .touchUpInside)
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var userTwo: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Demo User: 2 (Krutin)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.backgroundColor = appearance.colors.appLightGray
        button.layer.cornerRadius = 5
        button.tag = 1
        button.addTarget(self, action: #selector(toggleUser(_:)), for: .touchUpInside)
        button.ismTapFeedBack()
        return button
    }()
    
    lazy var userThree: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Demo User: 3 (Firen)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.backgroundColor = appearance.colors.appLightGray
        button.layer.cornerRadius = 5
        button.tag = 2
        button.addTarget(self, action: #selector(toggleUser(_:)), for: .touchUpInside)
        button.ismTapFeedBack()
        return button
    }()
    
    // MARK: MAIN -
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(userNameView)
        contentStackView.addArrangedSubview(passwordView)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        view.addSubview(optionStackView)
        optionStackView.addArrangedSubview(userOne)
        optionStackView.addArrangedSubview(userTwo)
        optionStackView.addArrangedSubview(userThree)
        
        ism_hideKeyboardWhenTappedAround()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            
            userNameView.heightAnchor.constraint(equalToConstant: 80),
            passwordView.heightAnchor.constraint(equalToConstant: 80),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 30),
            
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            
            optionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            optionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            optionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            userOne.heightAnchor.constraint(equalToConstant: 50),
            userTwo.heightAnchor.constraint(equalToConstant: 50),
            userThree.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func toggleUser(_ sender: UIButton){
        
        var userData: UserData?
        userData = demoUsers[sender.tag]
        
        guard let userData else { return }
        let userIdentifier = userData.userIdentifier
        let password = userData.password
        
        viewModel.userName = userIdentifier
        viewModel.password = password
        
        viewModel.loginUser { success, error in
            if success {
                self.dismiss(animated: false)
                self.viewModel.action_callback?()
            } else {
                self.ism_showAlert("Error", message: "\(error!)")
            }
        }
        
    }
    
    @objc func loginUser(){
        
        let userIdentifier = userNameView.formTextView.inputTextField.text ?? ""
        let password = passwordView.formTextView.inputTextField.text ?? ""
        
        if userIdentifier.isEmpty {
            ism_showAlert("Error", message: "email can't be empty!")
            return
        }
        
        if password.isEmpty {
            ism_showAlert("Error", message: "password can't be empty!")
            return
        }
        
        viewModel.userName = userIdentifier
        viewModel.password = password
        
        viewModel.loginUser { success, errorMessage in
            if success {
                self.dismiss(animated: false)
                self.viewModel.action_callback?()
            } else {
                self.ism_showAlert("Error", message: "\(errorMessage!)")
            }
        }
        
    }
    
    @objc func signupUser(){
        let viewModel = UserViewModel()
        viewModel.action_callback = { [weak self] in
            self?.viewModel.action_callback?()
        }
        let controller = SignupViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func showPasswordKeyTapped(){
        viewModel.secureEntry = !viewModel.secureEntry
        passwordView.formTextView.inputTextField.isSecureTextEntry = viewModel.secureEntry
        
        if viewModel.secureEntry {
            passwordView.formTextView.copyButton.imageView?.tintColor = .lightGray.withAlphaComponent(0.6)
        } else {
            passwordView.formTextView.copyButton.imageView?.tintColor = .darkGray
        }
    }


}
