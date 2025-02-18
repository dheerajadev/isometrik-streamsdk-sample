//
//  CustomAddProductListViewProvider.swift
//  isometrik-example
//
//  Created by Appscrip 3Embed on 06/11/24.
//

import UIKit
import IsometrikStreamUI

class CustomAddProductListViewProvider: GoliveAddProductListViewProvider {
    
    private var customView: UIView?
    
    func customAddProductListView() -> UIView {
        let view = MyCustomView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
        return view
    }
    
    func updateAddProductListView(with data: Any) {
        // Use the data to update the view's contents
        if let productData = data as? [String: Any] {
            // Assume productData has relevant keys and values
            // Update customView as needed, e.g., setting labels, images, etc.
        }
    }
    
}


class MyCustomView: UIView {
    
    // MARK: - PROPERTIES
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue.withAlphaComponent(0.2)
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
        addSubview(cardView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
}
