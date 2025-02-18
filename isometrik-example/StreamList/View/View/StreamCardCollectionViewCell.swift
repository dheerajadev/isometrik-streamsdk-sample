//
//  StreamCardCollectionViewCell.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 18/04/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI
import SkeletonView

class StreamCardCollectionViewCell: UICollectionViewCell, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.isSkeletonable = true
        return view
    }()
    
    let streamImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.isSkeletonable = true
        return stackView
    }()
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.isSkeletonable = true
        view.isHiddenWhenSkeletonIsActive = true
        return view
    }()
    
    lazy var streamStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h8)
        button.layer.cornerRadius = 3
        button.backgroundColor = appearance.colors.appColor
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        button.isSkeletonable = true
        button.skeletonCornerRadius = 3
        return button
    }()
    
    lazy var streamTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textColor = .white
        label.numberOfLines = 2
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 2
        label.lastLineFillPercent = 40
        label.linesCornerRadius = 3
        return label
    }()
    
    // streamer profile view
    
    let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        return view
    }()
    
    let streamerProfileView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17.5
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 17.5
        return imageView
    }()
    
    lazy var defaultProfileView: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 17.5
        view.layer.borderWidth = 1
        view.layer.borderColor = appearance.colors.appColor.cgColor
        view.isSkeletonable = true
        view.skeletonCornerRadius = 17.5
        return view
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h6)
        label.isSkeletonable = true
        return label
    }()
    
    //:
    
    // Paid flag
    
    lazy var paidFlag: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.coin, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        button.backgroundColor = .white
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 5
        button.isSkeletonable = true
        button.isHiddenWhenSkeletonIsActive = true
        return button
    }()
    
    //:
    
    // player button
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(appearance.images.play, for: .normal)
        button.isHidden = true
        button.isSkeletonable = true
        button.isHiddenWhenSkeletonIsActive = true
        return button
    }()
    
    //:
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        streamImageStackView.ism_removeFullyAllArrangedSubviews()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        contentView.addSubview(cardView)
        cardView.addSubview(streamImageStackView)
        cardView.addSubview(backCoverView)
        cardView.addSubview(streamTitleLabel)
        
        cardView.addSubview(streamStatusButton)
        
        cardView.addSubview(profileView)
        profileView.addSubview(defaultProfileView)
        profileView.addSubview(streamerProfileView)
        profileView.addSubview(userNameLabel)
        
        cardView.addSubview(paidFlag)
        cardView.addSubview(playButton)
    }
    
    func setUpConstraints(){
        cardView.ism_pin(to: self)
        streamImageStackView.ism_pin(to: cardView)
        backCoverView.ism_pin(to: cardView)
        NSLayoutConstraint.activate([
            streamStatusButton.heightAnchor.constraint(equalToConstant: 18),
            streamStatusButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            streamStatusButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
                    
            streamTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            streamTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            streamTitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            
            profileView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: streamTitleLabel.topAnchor, constant: -4),
            profileView.heightAnchor.constraint(equalToConstant: 40),
            
            defaultProfileView.widthAnchor.constraint(equalToConstant: 35),
            defaultProfileView.heightAnchor.constraint(equalToConstant: 35),
            defaultProfileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            defaultProfileView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
            streamerProfileView.widthAnchor.constraint(equalToConstant: 35),
            streamerProfileView.heightAnchor.constraint(equalToConstant: 35),
            streamerProfileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            streamerProfileView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: defaultProfileView.trailingAnchor, constant: 8),
            userNameLabel.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -8),
            
            paidFlag.centerYAnchor.constraint(equalTo: centerYAnchor),
            paidFlag.centerXAnchor.constraint(equalTo: centerXAnchor),
            paidFlag.heightAnchor.constraint(equalToConstant: 35),
            
            playButton.widthAnchor.constraint(equalToConstant: 45),
            playButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func configureData(streamData: ISMStream?, withfilter: StreamFilters = .isLive){
        
        guard let streamData else { return }
        
        let streamStatus = LiveStreamStatus(rawValue: streamData.status.unwrap)
        let isPKStream = streamData.isPkChallenge.unwrap
        let isRecorded = streamData.isRecorded.unwrap
        let isScheduledStream = streamData.isScheduledStream.unwrap
        
        switch streamStatus {
        case .ended:
            streamStatusButton.setTitle("ended".uppercased(), for: .normal)
            streamStatusButton.backgroundColor = appearance.colors.appRed
            streamStatusButton.setTitleColor(.white, for: .normal)
        case .started:
            streamStatusButton.setTitle("live".uppercased(), for: .normal)
            streamStatusButton.backgroundColor = appearance.colors.appColor
            streamStatusButton.setTitleColor(appearance.colors.appSecondary, for: .normal)
        case .scheduled:
            streamStatusButton.setTitle("schedule".uppercased(), for: .normal)
            streamStatusButton.backgroundColor = appearance.colors.appColor
            streamStatusButton.setTitleColor(appearance.colors.appSecondary, for: .normal)
        default:
            streamStatusButton.setTitle("-", for: .normal)
            break
        }
        
        // unhide if stream is recorded enabled
        if withfilter == .isRecorded {
            playButton.isHidden = isRecorded ? false : true
        } else {
            playButton.isHidden = true
        }
        
        
        if isPKStream {
            streamStatusButton.isHidden = false
            streamStatusButton.setTitle("PK", for: .normal)
            
            streamImageStackView.ism_removeFullyAllArrangedSubviews()
            let streamImageOne = streamData.firstUserDetails?.streamImage ?? ""
            let streamImageTwo = streamData.secondUserDetails?.streamImage ?? ""
            
            let imageOne = UIImageView()
            imageOne.contentMode = .scaleAspectFill
            imageOne.isSkeletonable = true
            imageOne.clipsToBounds = true
            
            let imageTwo = UIImageView()
            imageTwo.contentMode = .scaleAspectFill
            imageTwo.isSkeletonable = true
            imageTwo.clipsToBounds = true
            
            if let streamImageOneURL = URL(string: streamImageOne) {
                imageOne.kf.setImage(with: streamImageOneURL)
            }
            
            if let streamImageTwoURL = URL(string: streamImageTwo) {
                imageTwo.kf.setImage(with: streamImageTwoURL)
            }
            
            streamImageStackView.addArrangedSubview(imageOne)
            streamImageStackView.addArrangedSubview(imageTwo)
            
        } else if isScheduledStream {
            
            let scheduleStartDate = Date(timeIntervalSince1970: Double(streamData.scheduleStartTime.unwrap))
            let scheduleDateString = scheduleStartDate.ism_getCustomMessageTime(dateFormat: "d MMM, hh:mm a").uppercased()
            
            streamStatusButton.isHidden = false
            streamStatusButton.setTitle("\(scheduleDateString)", for: .normal)
            
            streamImageStackView.ism_removeFullyAllArrangedSubviews()
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            
            if let streamImageURL = URL(string: streamData.streamImage.unwrap) {
                imageView.kf.setImage(with: streamImageURL)
            }
            
            streamImageStackView.addArrangedSubview(imageView)
            
        } else  {
            
            streamStatusButton.isHidden = true
            
            streamImageStackView.ism_removeFullyAllArrangedSubviews()
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            
            if let streamImageURL = URL(string: streamData.streamImage.unwrap) {
                imageView.kf.setImage(with: streamImageURL)
            }
            
            streamImageStackView.addArrangedSubview(imageView)
            
        }
        
        streamTitleLabel.text = streamData.streamDescription.unwrap
        
        let firstName = streamData.userDetails?.firstName
        let lastName = streamData.userDetails?.lastName
        let userName = streamData.userDetails?.userName
        let profilePic = streamData.userDetails?.userProfile
        
        let defaultImageUrl = UserDefaultsProvider.shared.getIsometrikDefaultProfile()
        
        if let profilePic, profilePic != defaultImageUrl, let profileImageURL = URL(string: profilePic) {
            streamerProfileView.kf.setImage(with: profileImageURL)
        } else {
            streamerProfileView.image = UIImage()
        }
        
        if let firstName, let lastName {
            let initialText = "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased()
            defaultProfileView.initialsText.text = initialText
        }
        
        if let userName {
            let initialText = "\(userName.prefix(2))".uppercased()
            defaultProfileView.initialsText.text = initialText
            userNameLabel.text = userName
        }
        
        let paidStream = streamData.isPaid.unwrap
        let paymentAmount = streamData.amount.unwrap
        let paymentAmountLabel = Int64(paymentAmount).ism_roundedWithAbbreviations
        let isBought = streamData.isBuy.unwrap
        
        if paidStream && !isBought {
            paidFlag.isHidden = false
            paidFlag.setTitle(" " + "\(paymentAmountLabel)", for: .normal)
        } else {
            paidFlag.isHidden = true
        }
        
    }
    
}
