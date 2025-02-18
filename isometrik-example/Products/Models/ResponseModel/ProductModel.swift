//
//  StreamProductModel.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/05/24.
//

import Foundation
import IsometrikStream

public struct ProductDetailModelData: Codable {
    public let data: ProductDetailData?
}

public struct ProductDetailData: Codable {
    public let productData: ProductData?
}

public struct ProductData: Codable {
    public let data: [ProductModel]?
}

public struct ProductModelData: Codable {
    
    public let message: String?
    public let count: Int?
    public let data: [ProductModel]?
    public let statusCode: Int?
    public let status: String?

    enum CodingKeys: String, CodingKey {
        case message, count, data
        case statusCode = "status_code"
        case status
    }
    
}

public struct ProductModel: Codable {
    public var storeId: String?
    public var parentProductID, childProductID: String?
    public var images, mobileImage: [ProductImage]?
    public var liveStreamfinalPriceList: ProductFinalPriceList?
    public var finalPriceList: ProductFinalPriceList?
    public var productName: String?
    public var brandName: String?
    public var brandId: String?
    public var currency: String?
    public var currencySymbol: String?
    public var categoryJson: [ProductCategoryJson]?
    
    public var unitId: String?
    public var supplier: ProductSupplier?
    public var availableQuantity: Int?
    public var productOfferId: String?
    public var offers: [ProductOffers]?
    public var offer: ProductOffers?
    public var outOfStock: Bool?
    
    // commission
    public var resellerCommission: Double?
    public var resellerCommissionType: Int?
    public var resellerFixedCommission: Double?
    public var resellerPercentageCommission: Double?
    
    public var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case storeId
        case parentProductID = "parentProductId"
        case childProductID = "childProductId"
        case images, mobileImage
        case liveStreamfinalPriceList
        case productName, brandName, brandId, currency, currencySymbol
        case categoryJson
        case unitId
        case supplier
        case availableQuantity
        case productOfferId
        
        case productId
        case finalPriceList
        case categoryList
        case offers = "liveStreamoffer"
        case offer
        case outOfStock
        
        case resellerCommission
        case resellerCommissionType
        case resellerFixedCommission
        case resellerPercentageCommission
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        parentProductID = try container.decodeIfPresent(String.self, forKey: .parentProductID)
        if parentProductID == nil {
            parentProductID = try container.decodeIfPresent(String.self, forKey: .productId)
        }
        
        childProductID = try? container.decodeIfPresent(String.self, forKey: .childProductID)
        images = try container.decodeIfPresent([ProductImage].self, forKey: .images)
        mobileImage = try container.decodeIfPresent([ProductImage].self, forKey: .mobileImage)
        
        liveStreamfinalPriceList = try container.decodeIfPresent(ProductFinalPriceList.self, forKey: .liveStreamfinalPriceList)
        if liveStreamfinalPriceList == nil {
            liveStreamfinalPriceList = try container.decodeIfPresent(ProductFinalPriceList.self, forKey: .finalPriceList)
        }
        
        categoryJson = try container.decodeIfPresent([ProductCategoryJson].self, forKey: .categoryJson)
        if categoryJson == nil {
            categoryJson = try container.decodeIfPresent([ProductCategoryJson].self, forKey: .categoryList)
        }
            
        finalPriceList = try container.decodeIfPresent(ProductFinalPriceList.self, forKey: .finalPriceList)
        
        storeId = try container.decodeIfPresent(String.self, forKey: .storeId)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
        brandName = try container.decodeIfPresent(String.self, forKey: .brandName)
        brandId = try container.decodeIfPresent(String.self, forKey: .brandId)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        unitId = try container.decodeIfPresent(String.self, forKey: .unitId)
        supplier = try container.decodeIfPresent(ProductSupplier.self, forKey: .supplier)
        availableQuantity = try container.decodeIfPresent(Int.self, forKey: .availableQuantity)
        
        productOfferId = try container.decodeIfPresent(String.self, forKey: .productOfferId)
        offers = try container.decodeIfPresent([ProductOffers].self, forKey: .offers)
        offer = try container.decodeIfPresent(ProductOffers.self, forKey: .offer)
        outOfStock = try container.decodeIfPresent(Bool.self, forKey: .outOfStock)
        
        resellerCommission = try container.decodeIfPresent(Double.self, forKey: .resellerCommission)
        resellerCommissionType = try container.decodeIfPresent(Int.self, forKey: .resellerCommissionType)
        resellerFixedCommission = try container.decodeIfPresent(Double.self, forKey: .resellerFixedCommission)
        resellerPercentageCommission = try container.decodeIfPresent(Double.self, forKey: .resellerPercentageCommission)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(parentProductID, forKey: .parentProductID)
        try? container.encode(childProductID, forKey: .childProductID)
        try? container.encode(storeId, forKey: .storeId)
        try? container.encode(images, forKey: .images)
        try? container.encode(mobileImage, forKey: .mobileImage)
        try? container.encode(liveStreamfinalPriceList, forKey: .liveStreamfinalPriceList)
        try? container.encode(productName, forKey: .productName)
        try? container.encode(brandName, forKey: .brandName)
        try? container.encode(brandId, forKey: .brandId)
        try? container.encode(currency, forKey: .currency)
        try? container.encode(currencySymbol, forKey: .currencySymbol)
        try? container.encode(unitId, forKey: .currencySymbol)
        try? container.encode(supplier, forKey: .supplier)
        try? container.encode(availableQuantity, forKey: .availableQuantity)
        try? container.encode(categoryJson, forKey: .categoryJson)
        try? container.encode(productOfferId, forKey: .productOfferId)
        try? container.encode(categoryJson, forKey: .categoryList)
        try? container.encode(offers, forKey: .offers)
        try? container.encode(offer, forKey: .offer)
    }
    
}

// MARK: - OFFERS

public struct ProductOffers: Codable {
    public let offerID: String?
    public let offerFor: Int?
    public let offerName: StreamOfferName?
    public let images, webimages: StreamOfferImages?
    public let discountType: Int?
    public let discountValue: RelaxedString?
    public let status: Int?

    enum CodingKeys: String, CodingKey {
        case offerID = "offerId"
        case offerFor, offerName, images, webimages, discountType, discountValue, status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        offerID = try container.decodeIfPresent(String.self, forKey: .offerID)
        offerFor = try container.decodeIfPresent(Int.self, forKey: .offerFor)
        offerName = try container.decodeIfPresent(StreamOfferName.self, forKey: .offerName)
        images = try container.decodeIfPresent(StreamOfferImages.self, forKey: .webimages)
        webimages = try container.decodeIfPresent(StreamOfferImages.self, forKey: .webimages)
        discountType = try container.decodeIfPresent(Int.self, forKey: .discountType)
        discountValue = try container.decodeIfPresent(RelaxedString.self, forKey: .discountValue)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(offerID, forKey: .offerID)
        try? container.encode(offerFor, forKey: .offerFor)
        try? container.encode(offerName, forKey: .offerName)
        try? container.encode(webimages, forKey: .webimages)
        try? container.encode(discountType, forKey: .discountType)
        try? container.encode(discountValue, forKey: .discountValue)
        try? container.encode(status, forKey: .status)
    }
    
}

public struct StreamOfferName: Codable {
    public let en: String?
}

public struct StreamOfferImages: Codable {
    public let thumbnail, mobile, image: String?
}

//:

public struct ProductSupplier: Codable {
    public let id: String?
}

public struct ProductFinalPriceList: Codable {
    public var basePrice, finalPrice: Double?
    public var discountType: Int?
    public var discountPrice: Double?
    public var discountPercentage: Double?
    public var discount: Double?
    public var msrpPrice: Double?
    
    enum CodingKeys: CodingKey {
        case basePrice
        case finalPrice
        case discountPrice
        case discountType
        case discountPercentage
        
        case msrpPrice
        case discount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        finalPrice = try? container.decodeIfPresent(Double.self, forKey: .finalPrice)
        discountPercentage = try? container.decodeIfPresent(Double.self, forKey: .discountPercentage)
        discount = try? container.decodeIfPresent(Double.self, forKey: .discount)
        
        basePrice = try? container.decodeIfPresent(Double.self, forKey: .basePrice)
        msrpPrice = try? container.decodeIfPresent(Double.self, forKey: .msrpPrice)
        
        discountPrice = try? container.decodeIfPresent(Double.self, forKey: .discountPrice)
        
        discountType = try? container.decodeIfPresent(Int.self, forKey: .discountType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(finalPrice, forKey: .finalPrice)
        try? container.encode(discountPercentage, forKey: .discountPercentage)
        try? container.encode(basePrice, forKey: .basePrice)
        try? container.encode(discountPrice, forKey: .discountPrice)
        try? container.encode(discountType, forKey: .discountType)
        try? container.encode(msrpPrice, forKey: .msrpPrice)
    }
    
}

public struct ProductImage: Codable {
    public let small, large: String?
    public let altText: String?
    public let medium: String?
    public let filePath: String?
    public let extraLarge: String?
    public let seqID: Int?

    enum CodingKeys: String, CodingKey {
        case small, large, altText, medium, filePath, extraLarge
        case seqID = "seqId"
    }
}

public struct ProductCategoryJson: Codable {
    public var categoryName: String?
    public var categoryId: String?

    enum CodingKeys: String, CodingKey {
        case categoryName, categoryId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryName = try? container.decodeIfPresent(String.self, forKey: .categoryName)
        categoryId = try? container.decodeIfPresent(String.self, forKey: .categoryId)
    }
}
