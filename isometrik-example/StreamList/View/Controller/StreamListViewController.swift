//
//  LiveHomeViewController.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 18/04/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI
import SkeletonView

class StreamListViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var viewModel: StreamListViewModel
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Live Streams"
        view.headerTitle.textColor = .black
        view.headerTitle.textAlignment = .center
        
        view.dividerView.isHidden = true
        
        view.leadingActionButton.isHidden = false
        view.leadingActionButton.layer.cornerRadius = 17.5
        view.leadingActionButton.addTarget(self, action: #selector(changeUserTapped), for: .touchUpInside)
        
        view.trailingActionButton2.isHidden = false
        view.trailingActionButton2.setImage(appearance.images.coin, for: .normal)
        view.trailingActionButton2.backgroundColor = appearance.colors.appLightGray
        view.trailingActionButton2.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        view.trailingActionButton2.setTitleColor(.black, for: .normal)
        view.trailingActionButton2.addTarget(self, action: #selector(buyCoinsButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    lazy var streamFilterView: StreamFiltersView = {
        let view = StreamFiltersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var streamListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(StreamCardCollectionViewCell.self, forCellWithReuseIdentifier: "StreamCardCollectionViewCell")
        collectionView.delaysContentTouches = false
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        return control
    }()
    
    lazy var goLiveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Live", for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h3)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.backgroundColor = appearance.colors.appColor
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        button.addTarget(self, action: #selector(didGoLiveTapped), for: .touchUpInside)
        return button
    }()
    
    // Default View
    
    let defaultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var placeHolderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.noLiveStream
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No live streams"
        label.textColor = appearance.colors.appSecondary
        label.font = appearance.font.getFont(forTypo: .h3)
        label.textAlignment = .center
        return label
    }()
    
    //:
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        configureCompositionalLayout()
        loadData()
        setupWallet()
    }
    
    init(viewModel: StreamListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setupHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        
        view.addSubview(defaultView)
        defaultView.addSubview(placeHolderImage)
        defaultView.addSubview(placeHolderLabel)
        
        view.addSubview(headerView)
        view.addSubview(streamFilterView)
        view.addSubview(streamListCollectionView)
        view.addSubview(goLiveButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            streamFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            streamFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            streamFilterView.heightAnchor.constraint(equalToConstant: 50),
            streamFilterView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            defaultView.topAnchor.constraint(equalTo: streamFilterView.bottomAnchor),
        
            streamListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            streamListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            streamListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            streamListCollectionView.topAnchor.constraint(equalTo: streamFilterView.bottomAnchor),
            
            goLiveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            goLiveButton.heightAnchor.constraint(equalToConstant: 50),
            goLiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeHolderImage.widthAnchor.constraint(equalToConstant: 120),
            placeHolderImage.heightAnchor.constraint(equalToConstant: 120),
            placeHolderImage.centerXAnchor.constraint(equalTo: defaultView.centerXAnchor),
            placeHolderImage.centerYAnchor.constraint(equalTo: defaultView.centerYAnchor, constant: -15),
            
            placeHolderLabel.leadingAnchor.constraint(equalTo: defaultView.leadingAnchor, constant: 16),
            placeHolderLabel.trailingAnchor.constraint(equalTo: defaultView.trailingAnchor, constant: -16),
            placeHolderLabel.topAnchor.constraint(equalTo: placeHolderImage.bottomAnchor, constant: 20)
        ])
    }
    
    func setupHeader(){
        
        let leadingActionButton = headerView.leadingActionButton
        
        // header leading button
        
        leadingActionButton.backgroundColor = appearance.colors.appColor
        leadingActionButton.layer.borderColor = appearance.colors.appSecondary.cgColor
        leadingActionButton.layer.borderWidth = 1.5
        leadingActionButton.clipsToBounds = true
        leadingActionButton.setTitle("UN", for: .normal)
        leadingActionButton.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        leadingActionButton.setTitleColor(appearance.colors.appSecondary, for: .normal)
        
        if let userName = UserDefaults.standard.object(forKey: "USERNAME") as? String {
            leadingActionButton.setTitle("\(userName.prefix(2))".uppercased(), for: .normal)
        }
        
        if let userProfile = UserDefaults.standard.object(forKey: "PROFILEURL") as? String, !userProfile.isEmpty {
            if let imageUrl = URL(string: userProfile) {
                leadingActionButton.kf.setImage(with: imageUrl, for: .normal)
            }
        }
        
        streamFilterView.filterData = StreamFilters.allCases
        let filterIndex = viewModel.selectedFilter.getIndex
        DispatchQueue.main.async {
            self.streamFilterView.filterCollectionView.selectItem(at: IndexPath(row: filterIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
        
    }
    
    func loadData(isRefreshing: Bool = false){
        
        self.defaultView.isHidden = true
        
        if isRefreshing {
            viewModel.skip = 0
            viewModel.streams.removeAll()
            self.streamListCollectionView.reloadData()
        }
        
        if viewModel.skip == 0 {
            self.streamListCollectionView.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.25))
        }
        
        viewModel.fetchLiveStream { error in
            
            self.streamListCollectionView.hideSkeleton(transition: .crossDissolve(0.25))
            
            if self.viewModel.streams.count == 0 {
                self.defaultView.isHidden = false
            } else {
                self.defaultView.isHidden = true
            }
            
            if error == nil {
                self.streamListCollectionView.reloadData()
            }
        }
    }

    func setupWallet(){
        
        let trailingActionButton = headerView.trailingActionButton2
        
        viewModel.walletViewModel.getWalletBalance(currencyType: .coin) { _,_ in
            let balance = UserDefaultsProvider.shared.getWalletBalance(currencyType: ISMWalletCurrencyType.coin.getValue)
            
            if balance == 0 {
                trailingActionButton.setTitle(" Buy", for: .normal)
            } else {
                let formattedBalance = "\(Int64(balance))"
                trailingActionButton.setTitle(" \(formattedBalance)", for: .normal)
            }
        }
        
    }

    // MARK: - ACTIONS
    
    @objc func didPullToRefresh(_ sender: Any) {
        loadData(isRefreshing: true)
        self.refreshControl.endRefreshing()
    }
    
    @objc func didGoLiveTapped() {
        
        let goliveViewModel = GoLiveViewModel(
            isometrik: viewModel.isometrik,
            delegate: self,
            addProductListViewProvider: CustomAddProductListViewProvider()
        )
        
        let controller = GoLiveViewController(viewModel: goliveViewModel)
        
        let navVC = UINavigationController(rootViewController: controller)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
        
    }
    
    @objc func buyCoinsButtonTapped(){
        let controller = ISMWalletViewController(viewModel: viewModel.walletViewModel)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func changeUserTapped(){
        
        let viewModel = UserViewModel()
        viewModel.logout_callback = { [weak self] in
            guard let self else { return }
            self.dismiss(animated: false)
            self.viewModel.changeUser_actionCallback?()
        }
        
        let controller = LoggedProfileViewController(viewModel: viewModel)
        
        if let sheet = controller.sheetPresentationController {
            
            if #available(iOS 16.0, *) {
                let fixedHeightDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixedHeight")) { _ in
                    return 80 + ism_windowConstant.getBottomPadding
                }
                sheet.detents = [fixedHeightDetent]
            } else {
                // Fallback on earlier versions
                sheet.detents = [.medium()]
            }
            sheet.preferredCornerRadius = 0
            
        }
        
        present(controller, animated: true, completion: nil)
        
    }
    
}

// MARK: - SDK EXTERNAL DELEGATES

extension StreamListViewController: ISMExternalDelegate {
    
    func didAddProductTapped(selectedProductsIds: [String]?, productIds: ([String]?) -> Void, root: UINavigationController) {
        
        let viewModel = ProductViewModel(routeType: .present)
        viewModel.product_Callback = { [weak self] (selectedProducts, allProducts) in
            // return desired results
        }
        
        let controller = AllProductsViewController(viewModel: viewModel)
        root.present(controller, animated: true)
    }
    
    func didStreamStoreOptionTapped(forUserType: StreamUserType, root: UINavigationController) {
        
        switch forUserType {
        case .viewer:
            break
        case .host:
            break
        default:
            break
        }
        
    }
    
    func didShareStreamTapped(streamData: SharedStreamData, root: UINavigationController) {
        
        // generate link
        let streamId = streamData.streamId
        let shareURL = URL(string: "https://appleconfig.livejet.app/stream/\(streamId)")!
        
        // open share activity controller
        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)

        // Exclude certain activity types if needed
        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo
        ]

        // Present the activity view controller
        root.present(activityViewController, animated: true, completion: nil)

    }
    
    func didCloseStreamTapped(memberData: ISMMember?, callback: @escaping (Bool) -> (), root: UINavigationController) {
        
        if let memberData, let memberMetaData = memberData.metaData, let memberId = memberMetaData.userID {
            print("USER ID: \(memberId)")
        }
        
        DispatchQueue.main.async {
            callback(true)
        }
        
//        let controller = DemoFollowViewController()
//        
//        controller.followActionCallback = { success in
//            if success {
//                DispatchQueue.main.async {
//                    callback(success)
//                }
//            }
//        }
//        
//        // Set up the sheet presentation controller for custom detent
//        if let sheet = controller.sheetPresentationController {
//            if #available(iOS 16.0, *) {
//                sheet.detents = [.custom { context in
//                    return context.maximumDetentValue * 0.6 // 60% of the available screen height
//                }]
//            } else {
//                // Fallback on earlier versions
//            }
//            sheet.prefersGrabberVisible = true // Optional: shows a grabber for better UX
//        }
//
//        // Present the controller as a sheet
//        root.present(controller, animated: true)
        
    }
    
}

