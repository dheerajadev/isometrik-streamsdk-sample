//
//  DemoFollowViewController.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 25/10/24.
//

import UIKit

class DemoFollowViewController: UIViewController {

    // MARK: - PROPERTIES
    
    var followActionCallback: ((Bool)->())?
    
    lazy var demoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Follow and leave", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(demoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .red
        view.addSubview(demoButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            demoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            demoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            demoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            demoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func demoButtonTapped(){
        followActionCallback?(true)
        self.dismiss(animated: true)
    }


}
