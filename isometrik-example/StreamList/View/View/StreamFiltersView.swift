//
//  StreamFiltersView.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 31/07/24.
//

import UIKit
import IsometrikStream
import IsometrikStreamUI

protocol StreamFilterTypeActionDelegate {
    func didFilterTypeTapped(filter: StreamFilters)
}

class StreamFiltersView: UIView {

    // MARK: - PROPERTIES
    
    var delegate: StreamFilterTypeActionDelegate?
    
    var filterData: [StreamFilters] = [] {
        didSet {
            self.filterCollectionView.reloadData()
        }
    }
    
    lazy var filterCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StreamFilterCollectionViewCell.self, forCellWithReuseIdentifier: "StreamFilterCollectionViewCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        backgroundColor = .white
        addSubview(filterCollectionView)
        addSubview(dividerView)
    }
    
    func setUpConstraints(){
        filterCollectionView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }

}

extension StreamFiltersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StreamFilterCollectionViewCell", for: indexPath) as! StreamFilterCollectionViewCell
        cell.categoryLabel.text = filterData[indexPath.row].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let filterName = filterData[indexPath.row].rawValue
        let font = ISMAppearance.default.font.getFont(forTypo: .h8)!
        let estimateWidth = filterName.ism_widthOfString(usingFont: font)
        
        return CGSize(width: estimateWidth + 25 + 12, height: 35)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.filterCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let filter = filterData[indexPath.row]
        delegate?.didFilterTypeTapped(filter: filter)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

