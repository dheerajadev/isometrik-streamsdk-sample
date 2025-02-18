//
//  StreamListViewModel.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 18/04/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import Foundation
import IsometrikStream
import IsometrikStreamUI

enum StreamFilters: String, CaseIterable {
    case isLive = "Live"
    case isScheduled = "Scheduled"
    case isPK = "PK"
    case isPaid = "Paid"
    case isRecorded = "Recorded"
    case hdBroadcast = "HD"
    case isRestream = "Restream"
    
    private static let indexMapping: [StreamFilters: Int] = [
        .isLive: 0,
        .isPK: 1,
        .isPaid: 2,
        .isRecorded: 3,
        .hdBroadcast: 4,
        .isRestream: 5,
        .isScheduled: 6
    ]
    
    var getIndex: Int {
        return StreamFilters.indexMapping[self]!
    }
}

class StreamListViewModel {
    
    var isometrik: IsometrikSDK
    var streams: [ISMStream] = []
    var skip = 0
    var limit = 10
    var totalStreams: Int = 0
    var selectedFilter: StreamFilters = .isLive
    var walletViewModel: ISMWalletViewModel
    
    var changeUser_actionCallback: (()->Void)?
    
    init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
        walletViewModel = ISMWalletViewModel(isometrik: self.isometrik)
    }
    
    func fetchLiveStream(completion: @escaping(_ error: String?) -> Void){
        
        var streamParam = StreamQuery(limit: self.limit, skip: self.skip)
        
        switch selectedFilter {
        case .isPK:
            streamParam += StreamQuery(isLive: true, isPK: true)
            break
        case .isRecorded:
            streamParam += StreamQuery(isRecorded: true)
            break
        case .hdBroadcast:
            streamParam += StreamQuery(isLive: true, isHDbroadcast: true)
            break
        case .isRestream:
            streamParam += StreamQuery(isLive: true, isRestream: true)
            break
        case .isPaid:
            streamParam += StreamQuery(isLive: true, isPaid: true)
            break
        case .isLive:
            streamParam += StreamQuery(isLive: true)
            break
        case .isScheduled:
            streamParam += StreamQuery(sortOrder: SortOrder.descending.rawValue, isScheduledStream: true)
            break
        }
        
        isometrik.getIsometrik().fetchStreams(streamParam: streamParam) { streamData in
            
            self.totalStreams = streamData.totalCount ?? 0
            
            if self.streams.count.isMultiple(of: self.limit) {
                self.skip += self.limit
            }
            
            if self.streams.count > 0 {
                self.streams.append(contentsOf: streamData.streams ?? [])
            } else {
                self.streams = streamData.streams ?? []
            }
            
            completion(nil)
            
        } failure: { error in
            CustomLoader.shared.stopLoading()
            DispatchQueue.main.async {
                completion("\(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchScheduledStream(streamParam: StreamQuery, completion: @escaping(_ error: String?) -> Void){
        
        isometrik.getIsometrik().fetchScheduledStreams(streamParam: streamParam) { streamData in
            
            CustomLoader.shared.stopLoading()
            
            self.totalStreams = streamData.totalCount ?? 0
            
            if self.streams.count.isMultiple(of: self.limit) {
                self.skip += self.limit
            }
            
            if self.streams.count > 0 {
                self.streams.append(contentsOf: streamData.streams ?? [])
            } else {
                self.streams = streamData.streams ?? []
            }
            
            completion(nil)
            
        } failure: { error in
            CustomLoader.shared.stopLoading()
            DispatchQueue.main.async {
                completion("\(error.localizedDescription)")
            }
        }
        
    }
    
    func resetData(){
        skip = 0
        streams = []
        totalStreams = 0
    }
    
}
