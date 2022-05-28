//
//  RegisterViewModel.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//
import UIKit

final class RegisterViewModel: ManagingViewModel{
    func requestPost(_ productsPost: ProductsPost, completion: @escaping () -> ()) {
        let endpoint = EndPointStorage.productsPost(productsPost)
        
        productsAPIServie.registerProduct(with: endpoint) { [weak self] result in
            switch result {
            case .success():
                completion()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.showAlertRequestError(with: error)
                }
            }
        }
    }
    
    func setUpDefaultImage() {
        guard let plus = UIImage(named: "plus")?.pngData() else { return }
        images.append(ImageInfo(fileName: "plusButton", data: plus, type: "png"))
        applySnapshot()
    }
    
    func insert(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        images.insert(ImageInfo(fileName: generateUUID(), data: data, type: "jpg"), at: 0)
        applySnapshot()
    }
    
    func removeLastImage() {
        images.removeLast()
    }
}