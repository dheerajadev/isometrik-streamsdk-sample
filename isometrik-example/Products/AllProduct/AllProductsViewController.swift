//
//  AllProductsViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 23/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI

class AllProductsViewController: UIViewController, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var productViewModel: ProductViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Add Products"
        view.headerTitle.textColor = .black
        view.headerTitle.font = appearance.font.getFont(forTypo: .h3)
        view.headerTitle.textAlignment = .center
        view.dividerView.isHidden = true
        return view
    }()
    
    lazy var toggleActionView: ProductToggleView = {
        let view = ProductToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.myStoreButton.addTarget(self, action: #selector(myStoreButtonTapped), for: .touchUpInside)
        view.otherStoreButton.addTarget(self, action: #selector(otherStoreButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy var selectedProductHeaderView: SelectedProductCustomHeaderView = {
        let view = SelectedProductCustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    lazy var productTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: "ProductListTableViewCell")
        tableView.register(StoreListTableViewCell.self, forCellReuseIdentifier: "StoreListTableViewCell")
        tableView.separatorColor = .lightGray.withAlphaComponent(0.4)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: ism_windowConstant.getBottomPadding + 70, right: 0)
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    lazy var defaultView: ProductDefaultPlaceholderView = {
        let view = ProductDefaultPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    let bottomCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Continue", for: .normal)
//        Fonts.setFont(button.titleLabel!, fontFamiy: .monstserrat(.SemiBold), size: .custom(14), color: .white)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.3
        button.ismTapFeedBack()
        return button
    }()
    
    // MARK: - MAIN
    
    init(viewModel: ProductViewModel) {
        self.productViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        manageUI()
        manageData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        defaultView.isHidden = true
        productTableView.isHidden = true
        
        self.toggleActionView.updateUI(activeButton: .myStore)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.defaultView.playAnimation(for: self.appearance.json.emptyBoxAnimation)
            self.defaultView.defaultLabel.text = "There are no products available to tag"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(productTableView)
        view.addSubview(defaultView)
        
        view.addSubview(headerView)
        view.addSubview(toggleActionView)
        view.addSubview(bottomCoverView)
        view.addSubview(continueButton)
        view.addSubview(selectedProductHeaderView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            toggleActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toggleActionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toggleActionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            toggleActionView.heightAnchor.constraint(equalToConstant: 60),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.topAnchor.constraint(equalTo: view.topAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            productTableView.topAnchor.constraint(equalTo: toggleActionView.bottomAnchor),
            
            selectedProductHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedProductHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedProductHeaderView.bottomAnchor.constraint(equalTo: continueButton.topAnchor),
            
            bottomCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCoverView.heightAnchor.constraint(equalToConstant: ism_windowConstant.getBottomPadding + 50),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        productViewModel.selectedProductHeaderHeightConstraint = selectedProductHeaderView.heightAnchor.constraint(equalToConstant: 0) // 140
        productViewModel.selectedProductHeaderHeightConstraint?.isActive = true
    }
    
    func updateSelectedProductView(){
        
        let estimatedBottomOffset = 120 + ism_windowConstant.getBottomPadding + 60
        
        // selected product count
        let selectedProductCount = productViewModel.selectedProductList.count
        if selectedProductCount > 0 {
            selectedProductHeaderView.isHidden = false
            productViewModel.selectedProductHeaderHeightConstraint?.constant = 140
            productTableView.contentInset.bottom = estimatedBottomOffset
            
            self.continueButton.isEnabled = true
            self.continueButton.alpha = 1
        } else {
            selectedProductHeaderView.isHidden = true
            productViewModel.selectedProductHeaderHeightConstraint?.constant = 0
            productTableView.contentInset.bottom = 0
            
            self.continueButton.isEnabled = false
            self.continueButton.alpha = 0.3
        }
        
        // update header data collection
        selectedProductHeaderView.productData = productViewModel.selectedProductList
        
    }
    
    func manageData(){
        
        productViewModel.productList.removeAll()
        self.productTableView.reloadData()
        
        self.defaultView.isHidden = true
        
        if productViewModel.productList.isEmpty || productViewModel.selectedProductList.isEmpty {
            
            DispatchQueue.main.async {
                CustomLoader.shared.startLoading()
            }

            productViewModel.fetchProducts { success, error in
                
                CustomLoader.shared.stopLoading()
                
                if success {
                    let _ = self.productViewModel.totalProducts
                    
                    self.productTableView.isHidden = false
                    self.defaultView.isHidden = true
                    
                    // if Selected list is not empty replace the product in all list
                    if !self.productViewModel.selectedProductList.isEmpty {
                        self.productViewModel.updateAllProductListFromSelectedProduct {
                            self.productTableView.isHidden = false
                            self.defaultView.isHidden = true
                            self.updateSelectedProductView()
                            self.productTableView.reloadData()
                        }
                    }
                    
                    self.productTableView.reloadData()
            
                } else {
                    self.defaultView.isHidden = false
                    print(error ?? "")
                }
            }
            
        } else {
            DispatchQueue.main.async {
                CustomLoader.shared.startLoading()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                
                guard let self else { return }
                
                CustomLoader.shared.stopLoading()
                self.productTableView.isHidden = false
                self.defaultView.isHidden = true
                self.updateSelectedProductView()
                self.productTableView.reloadData()
                
            }
        }
        
    }
    
    func manageOtherStoreData(){
        
        productViewModel.storesList.removeAll()
        self.productTableView.reloadData()
        
        self.defaultView.isHidden = true
    
        DispatchQueue.main.async {
            CustomLoader.shared.startLoading()
        }
    
        productViewModel.fetchAllStores() { success, error in
            CustomLoader.shared.stopLoading()
            if success {
                if self.productViewModel.storesList.isEmpty {
                    self.defaultView.isHidden = false
                    self.productTableView.isHidden = true
                } else {
                    self.defaultView.isHidden = true
                    self.productTableView.isHidden = false
                }
                self.productTableView.reloadData()
            } else {
                self.defaultView.isHidden = false
                self.productTableView.isHidden = true
            }
        }
        
    }
    
    func manageUI(){
        
        switch productViewModel.routeType {
        case .present:
            
            headerView.trailingActionButton.isHidden = false
            headerView.trailingActionButton.setImage(appearance.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
            headerView.trailingActionButton.imageView?.tintColor = .black
            headerView.trailingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
            break
        case .push:
            
            headerView.leadingActionButton.isHidden = false
            headerView.leadingActionButton.setImage(appearance.images.back, for: .normal)
            headerView.leadingActionButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
            break
        }
        
    }
    
    func navigateBack(){
        
        switch productViewModel.routeType {
        case .present:
            
            if !productViewModel.isFromLive {
                let selectedProducts = productViewModel.selectedProductList
                let allProducts = productViewModel.productList
                
                if !(selectedProducts.count > 0)  { return }
                
                productViewModel.product_Callback?(selectedProducts, allProducts)
            }
            
            self.dismiss(animated: true)
        case .push:
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - ACTION TAPPED
    
    @objc func backButtonTapped(){
        switch productViewModel.routeType {
        case .present:
            self.dismiss(animated: true)
        case .push:
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func continueButtonTapped(){
        
        if productViewModel.isFromLive {
            
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
                CustomLoader.shared.startLoading()
            }
            // create offers for change in products
            productViewModel.createOfferAndTagProductToLiveStream { success, error in
                if success {
                    group.leave()
                } else {
                    CustomLoader.shared.stopLoading()
                    self.ism_showAlert("Error", message: "\(error ?? "")")
                }
            }
            
            group.notify(queue: .main){
                self.productViewModel.removeTaggedProducts { success, error in
                    CustomLoader.shared.stopLoading()
                    if success {
                        self.backButtonTapped()
                    } else {
                        self.ism_showAlert("Error", message: "\(error ?? "")")
                    }
                }
            }
        
        } else {
            self.navigateBack()
        }
        
    }
    
    @objc func myStoreButtonTapped(){
        toggleActionView.updateUI(activeButton: .myStore)
        productViewModel.myStore = true
        manageData()
    }
    
    @objc func otherStoreButtonTapped(){
        toggleActionView.updateUI(activeButton: .otherStore)
        productViewModel.myStore = false
        manageOtherStoreData()
    }

}
