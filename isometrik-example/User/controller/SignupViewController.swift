import UIKit
import IsometrikStreamUI

class SignupViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: UserViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "Signup"
        view.headerTitle.font = appearance.font.getFont(forTypo: .h3)
        view.headerTitle.textColor = .black
        view.headerTitle.textAlignment = .center
        
        view.leadingActionButton.isHidden = false
        view.leadingActionButton.setImage(appearance.images.back.withRenderingMode(.alwaysTemplate), for: .normal)
        view.leadingActionButton.imageView?.tintColor = .black
        view.leadingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
        return scrollView
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()

    lazy var userNameView: FormTextWithTitleView = {
        
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "User Name"
        view.formTitleLabel.textColor = .black
        
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.tag = SignupInputField.userName.rawValue
        view.formTextView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter name",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!
            ]
        )
        
        return view
    }()
    
    lazy var emailView: FormTextWithTitleView = {
        
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "UserIdentifier / Email"
        view.formTitleLabel.textColor = .black
        
        view.formTextView.inputTextField.autocapitalizationType = .none
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.tag = SignupInputField.email.rawValue
        view.formTextView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter userIdentifier or email",
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
        view.formTextView.copyButton.imageView?.tintColor = .lightGray.withAlphaComponent(0.6)
        
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        
        view.formTextView.inputTextField.isSecureTextEntry = true
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.tag = SignupInputField.password.rawValue
        view.formTextView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
    
    lazy var confirmPasswordView: FormTextWithTitleView = {
        
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "Confirm Password"
        view.formTitleLabel.textColor = .black
        
        view.formTextView.copyButton.isHidden = false
        view.formTextView.copyButton.setImage(appearance.images.eye.withRenderingMode(.alwaysTemplate), for: .normal)
        view.formTextView.copyButton.imageView?.tintColor = .lightGray.withAlphaComponent(0.6)
        
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        
        view.formTextView.inputTextField.isSecureTextEntry = true
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.tag = SignupInputField.confirmPassword.rawValue
        view.formTextView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Confirm password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                NSAttributedString.Key.font: appearance.font.getFont(forTypo: .h8)!
            ]
        )
        
        view.formTextView.copyButton.addTarget(self, action: #selector(showConfirmPasswordKeyTapped), for: .touchUpInside)
        
        return view
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.backgroundColor = appearance.colors.appColor
        button.addTarget(self, action: #selector(signupUser), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.5
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(userNameView)
        contentStackView.addArrangedSubview(emailView)
        contentStackView.addArrangedSubview(passwordView)
        contentStackView.addArrangedSubview(confirmPasswordView)
        
        view.addSubview(signupButton)
        
        ism_hideKeyboardWhenTappedAround()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            userNameView.heightAnchor.constraint(equalToConstant: 80),
            emailView.heightAnchor.constraint(equalToConstant: 80),
            passwordView.heightAnchor.constraint(equalToConstant: 80),
            confirmPasswordView.heightAnchor.constraint(equalToConstant: 80),
            
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.topAnchor.constraint(equalTo: confirmPasswordView.bottomAnchor, constant: 30)
            
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func showPasswordKeyTapped(){
        viewModel.secureEntry = !viewModel.secureEntry
        passwordView.formTextView.inputTextField.isSecureTextEntry = viewModel.secureEntry
        
        if viewModel.secureEntry {
            passwordView.formTextView.copyButton.imageView?.tintColor = .lightGray.withAlphaComponent(0.6)
        } else {
            passwordView.formTextView.copyButton.imageView?.tintColor = .darkGray
        }
    }
    
    @objc func showConfirmPasswordKeyTapped(){
        viewModel.confirmPassSecureEntry = !viewModel.confirmPassSecureEntry
        confirmPasswordView.formTextView.inputTextField.isSecureTextEntry = viewModel.confirmPassSecureEntry
        
        if viewModel.confirmPassSecureEntry {
            confirmPasswordView.formTextView.copyButton.imageView?.tintColor = .lightGray.withAlphaComponent(0.6)
        } else {
            confirmPasswordView.formTextView.copyButton.imageView?.tintColor = .darkGray
        }
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func signupUser(){
        viewModel.createUser() { success, errorString in
            if success {
                self.dismiss(animated: false)
                self.viewModel.action_callback?()
            } else {
                self.ism_showAlert("Error", message: "\(errorString ?? "Unknown error!")")
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let inputField = SignupInputField(rawValue: textField.tag)
        
        switch inputField {
        case .userName:
            viewModel.userName = userNameView.formTextView.inputTextField.text ?? ""
            break
        case .email:
            viewModel.userIdentifier = emailView.formTextView.inputTextField.text ?? ""
            break
        case .password:
            if let password = passwordView.formTextView.inputTextField.text {
                viewModel.password = password
                if let errorMessage = viewModel.validatePassword(password) {
                    viewModel.validPass = false
                    passwordView.infoTextLabel.isHidden = false
                    if !viewModel.password.isEmpty {
                        passwordView.infoTextLabel.text = "\(errorMessage)"
                    } else {
                        passwordView.infoTextLabel.text = ""
                    }
                } else {
                    passwordView.infoTextLabel.isHidden = true
                    passwordView.infoTextLabel.text = ""
                    viewModel.validPass = true
                }
            }
            break
        case .confirmPassword:
            if let confirmPassword = confirmPasswordView.formTextView.inputTextField.text {
                let password = viewModel.password
                if confirmPassword == password {
                    viewModel.validConfirmPass = true
                    confirmPasswordView.infoTextLabel.isHidden = true
                    confirmPasswordView.infoTextLabel.text = ""
                } else {
                    viewModel.validConfirmPass = false
                    confirmPasswordView.infoTextLabel.isHidden = false
                    confirmPasswordView.infoTextLabel.text = "Password is not matching"
                    if viewModel.password.isEmpty {
                        confirmPasswordView.infoTextLabel.text = ""
                    }
                }
            }
            break
        default: break
        }
        
        if viewModel.validPass && !viewModel.userName.isEmpty && !viewModel.userIdentifier.isEmpty && viewModel.validConfirmPass {
            signupButton.isEnabled = true
            signupButton.alpha = 1
        } else {
            signupButton.isEnabled = false
            signupButton.alpha = 0.5
        }
        
    }

}
