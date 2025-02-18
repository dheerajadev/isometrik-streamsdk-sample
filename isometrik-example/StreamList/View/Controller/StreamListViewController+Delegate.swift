//
//  StreamListViewController+Delegate.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 18/04/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI
import SkeletonView


extension StreamListViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "StreamCardCollectionViewCell"
    }
    
}

extension StreamListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.streams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StreamCardCollectionViewCell", for: indexPath) as! StreamCardCollectionViewCell
        let streamData = viewModel.streams[indexPath.row]
        cell.configureData(streamData: streamData, withfilter: viewModel.selectedFilter)
        
        // pagination logic
        if indexPath.row == viewModel.streams.count - 2 {
            if viewModel.streams.count < viewModel.totalStreams {
                self.loadData(isRefreshing: false)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StreamCardCollectionViewCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.cardView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StreamCardCollectionViewCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.cardView.transform = .identity
            }
        }
    }
    
    func configureCompositionalLayout() {
            
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) in
            
            let fraction: CGFloat = 1 / 2
            let inset: CGFloat = 4
            let postRatio: CGFloat = 5/4
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction * postRatio))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            return section
            
        }
        
        streamListCollectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
}


extension StreamListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard viewModel.streams.count > 0
        else { return }
        
        let isometrik = viewModel.isometrik
        
        if !(isometrik.getMqttSession().isConnected) {
            self.view.showToast(message: "connection is broken!")
            return
        }
        
        isometrik.getUserSession().setUserType(userType: .viewer)
        var streamsData = viewModel.streams
        var streamData = viewModel.streams[indexPath.row]
        
        // stream status is nil setting to `STARTED`
        if streamData.status == nil {
            streamData.status = "STARTED"
        }
        
        // updating above changes to the array
        streamsData[indexPath.row] = streamData
        
        let isPaidStream = streamData.isPaid.unwrap
        let isBought = streamData.isBuy.unwrap
        let amountToPay = streamData.amount.unwrap
        let isRecorded = streamData.isRecorded.unwrap
        let isScheduledStream = streamData.isScheduledStream.unwrap
        
        if isRecorded && viewModel.selectedFilter == .isRecorded {
            self.openRecordPlayer(indexPath: indexPath)
            return
        }
        
        if isPaidStream && !isBought && !isScheduledStream {
            
            // buy stream and proceed
            let paidStreamViewModel = PaidStreamViewModel(amountToPay: Int(amountToPay), isometrik: isometrik, streamData: streamData)
            paidStreamViewModel.response = { [weak self] response in
                guard let self else { return }
                switch response {
                case .success:
                    goToStream()
                    break
                case let .failed(errorString):
                    self.ism_showAlert("Error", message: errorString)
                }
            }
            
            let controller = BuyPaidStreamViewController(viewModel: paidStreamViewModel)
            
            if let sheet = controller.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    // Configure the custom detent
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return 150 + ism_windowConstant.getBottomPadding
                    }
                    sheet.detents = [customDetent]
                    sheet.selectedDetentIdentifier = customDetent.identifier
                    sheet.preferredCornerRadius = 0
                } else {
                    // Fallback on earlier versions
                    sheet.preferredCornerRadius = 0
                    sheet.detents = [.medium()]
                }
            }
            
            present(controller, animated: true, completion: nil)
            
        } else {
            // proceed with stream
            goToStream()
        }
        
        func goToStream(){
            let viewModel = StreamViewModel(isometrik: isometrik, streamsData: streamsData, delegate: self)
            
            let currentUserId = isometrik.getUserSession().getUserId()
            viewModel.streamUserType = .viewer
            
            let selectedIndex = IndexPath(row: indexPath.row, section: 0)
            viewModel.selectedStreamIndex = selectedIndex
            
            ISMLogManager.shared.logCustom(category: "streamlist", message: "selectedIndex -> \(selectedIndex)")
            
            let streamController = StreamViewController(viewModel: viewModel)
            
            let navVC = UINavigationController(rootViewController: streamController)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
    }
    
}

extension StreamListViewController: StreamFilterTypeActionDelegate {
    
    func didFilterTypeTapped(filter: StreamFilters) {
        viewModel.selectedFilter = filter
        viewModel.resetData()
        self.streamListCollectionView.reloadData()
        loadData()
    }
    
    func openRecordPlayer(indexPath: IndexPath){
        let viewModel = RecordedStreamViewModel(isometrik: viewModel.isometrik, streamsData: viewModel.streams)
        viewModel.selectedIndex = indexPath
        let controller = RecordedStreamPlayerViewController(viewModel: viewModel)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
}
