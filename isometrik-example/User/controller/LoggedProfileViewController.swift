//
//  LoggedProfileViewController.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 24/07/24.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI

class LoggedProfileViewController: UIViewController, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var viewModel: UserViewModel
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let defaultProfileView: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h4)
        label.textColor = .black
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.ismTapFeedBack()
        button.backgroundColor = .lightGray.withAlphaComponent(0.2)
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward"), for: .normal)
        button.imageView?.tintColor = .red
        button.layer.cornerRadius = 22.5
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
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
        setupUI()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        
        view.addSubview(cardView)
        cardView.addSubview(defaultProfileView)
        cardView.addSubview(profilePicture)
        cardView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)

        cardView.addSubview(logoutButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cardView.topAnchor.constraint(equalTo: view.topAnchor),
            
            defaultProfileView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            defaultProfileView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            defaultProfileView.heightAnchor.constraint(equalToConstant: 50),
            defaultProfileView.widthAnchor.constraint(equalToConstant: 50),
            
            profilePicture.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            profilePicture.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            profilePicture.heightAnchor.constraint(equalToConstant: 50),
            profilePicture.widthAnchor.constraint(equalToConstant: 50),
            
            infoStackView.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 12),
            infoStackView.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: 30),
            infoStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 45),
            logoutButton.heightAnchor.constraint(equalToConstant: 45),
            logoutButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupUI(){
        
        if let profilePic = UserDefaults.standard.object(forKey: "PROFILEURL") as? String {
            if let url = URL(string: profilePic) {
                profilePicture.kf.setImage(with: url)
            }
        }
        
        if let userName = UserDefaults.standard.object(forKey: "USERNAME") as? String {
            defaultProfileView.initialsText.text = "\(userName.prefix(2))".uppercased()
            subtitleLabel.text = userName
        }
        
        if let name = UserDefaults.standard.object(forKey: "NAME") as? String {
            titleLabel.text = name
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func logoutTapped(){
        self.dismiss(animated: true)
        viewModel.resetUserDefaults()
        viewModel.logout_callback?()
        IsometrikSDK.getInstance().onTerminate()
    }


}
