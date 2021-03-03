//
//  SearchViewModel.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import Foundation
import RxSwift
import RxCocoa
class SearchViewModel: BaseViewModel{
    
    var items: [SearchUserItem] = []
    
    var currentPage: Int = 1
    
    var currentQ: String = ""
    
    var isNeedLoadMore: Bool = false
    
    var didFinishFetchUserData: PublishSubject<[SearchUserItem]> = PublishSubject()
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func fetchUserData(){
        self.isLoading.accept(true)
        APIManager.share.fetchSearchUserData(q: currentQ, page: currentPage).subscribe { [weak self](dto) in
            guard let strongSelf = self else {return}
            
            strongSelf.isNeedLoadMore = !dto.items.isEmpty
            
            if strongSelf.currentPage == 1{
                strongSelf.items = dto.items
            }else{
                strongSelf.items += dto.items
            }
            
            strongSelf.isLoading.accept(false)
            strongSelf.didFinishFetchUserData.onNext(strongSelf.items)
        } onError: { [weak self](error) in
            guard let strongSelf = self else {return}
            print(error)
            strongSelf.isLoading.accept(false)
        }.disposed(by: disposeBag)
    }
}
