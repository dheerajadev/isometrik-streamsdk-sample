//
//  ProductRequest.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/05/24.
//

import IsometrikStream
import IsometrikStreamUI

/**
    Isometrik `Product` Requests
 */

class ProductRequest {
    
    static let shared = ProductRequest()
    
    func removeTaggedProduct(bodyData: RemoveTaggedProducts, showLoader: Bool = false, completionHandler: @escaping (RemoveTaggedProductModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest(endPoint: ProductRouter.removeTaggedProductFromStream, requestBody:bodyData)
        
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<RemoveTaggedProductModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
        
    }
    
    func createProductOffer(bodyData: CreateLiveStreamOffers, showLoader: Bool = false, completionHandler: @escaping (StreamPinProductModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest(endPoint: ProductRouter.createProductOffer, requestBody:bodyData)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamPinProductModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func getTaggedProductsInStream(streamId: String, skip: Int, limit: Int = 10, query: String?, showLoader: Bool = false, completionHandler: @escaping (ProductModelData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let parameters = ProductRequestParameter(limit: limit, skip: skip, query: query)
        let request =  ISMLiveAPIRequest<Any>(endPoint: ProductRouter.getTaggedProductsInStream(streamId: streamId, requestParameter: parameters), requestBody:nil)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ProductModelData, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func getProductDetails(productId: String, showLoader: Bool = false, completionHandler: @escaping (ProductDetailModelData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ProductRouter.getProductDetails(productId: productId), requestBody: nil)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<ProductDetailModelData, ISMLiveAPIError>) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func getAllStores(storeId: String, isBusiness: Int = 1, showLoader: Bool = false, completionHandler: @escaping (StreamStoreModelData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ProductRouter.getAllStores(currentStoreId: storeId, isBusiness: isBusiness), requestBody: nil)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamStoreModelData, ISMLiveAPIError>) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func fetchStoreProducts(storeId: String, page:Int, showLoader: Bool = false, completionHandler: @escaping (StreamStoreProductModelData)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ProductRouter.getStoreProducts(storeId: storeId, page: page), requestBody:nil)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamStoreProductModelData, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
        
    }
    
    public func pinProductStream(bodyData: StreamPinProductBodyModel, showLoader: Bool = false, completionHandler: @escaping (StreamPinProductModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest(endPoint: ProductRouter.pinProductInStream, requestBody:bodyData)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamPinProductModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func getPinnedProduct(streamId: String, showLoader: Bool = false, completionHandler: @escaping (StreamPinProductModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest<Any>(endPoint: ProductRouter.getPinnedProductInStream(streamId: streamId), requestBody:nil)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamPinProductModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
        
    }
    
    public func updateProductOffer(bodyData: UpdateOfferModel, showLoader: Bool = false, completionHandler: @escaping (StreamPinProductModel)->(), failure : @escaping (ISMLiveAPIError) -> ()){
        
        let request =  ISMLiveAPIRequest(endPoint: ProductRouter.updateProductOffer, requestBody:bodyData)
        if showLoader {
            CustomLoader.shared.startLoading()
        }
        
        ISMLiveAPIManager.sendRequest(request: request) { (result :ISMLiveResult<StreamPinProductModel, ISMLiveAPIError> ) in
            CustomLoader.shared.stopLoading()
            switch result{
            case .success(let productResponse, _) :
                completionHandler(productResponse)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
}
