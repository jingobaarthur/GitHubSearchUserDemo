//
//  UIImageView+extension.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import UIKit
import Kingfisher
extension UIImageView{
    
    func setUpImage(
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        errorPlaceholder: UIImage? = nil,
        completeBlock:(() -> ())? = nil) {
        
        kf.cancelDownloadTask()
        kf.setImage(with: resource,
                    placeholder: placeholder,
                    options: nil, completionHandler:  { [weak self] result in
                        guard let strongSelf = self else { return }
                        switch result {
                        
                        case .success(let value):
                            
                            switch value.cacheType {
                            case .none:
                                return
                            case .memory, .disk:
                                strongSelf.kf.cancelDownloadTask()
                                //                                strongSelf.kf.setImage(with: resource, placeholder: value.image, options: [.forceRefresh])
                                if (completeBlock != nil)
                                {
                                    completeBlock!()
                                }
                            }
                            
                        case .failure:
                            if let errorPlaceholder = errorPlaceholder {
                                strongSelf.image = errorPlaceholder
                            }
                        }
                    })
    }
    
}


