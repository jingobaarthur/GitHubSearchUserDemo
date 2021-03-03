//
//  ViewController.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    
    fileprivate let viewModel = SearchViewModel()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Please search..."
        searchBar.showsCancelButton = true
        searchBar.barTintColor = .white
        searchBar.tintColor = .white
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = .white
        } else {
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.backgroundColor = UIColor.white
        }
        
        return searchBar
    }()
    
    lazy var collectionView = UICollectionView()
    var layout = UICollectionViewFlowLayout()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .gray
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.viewModel.fetchUserData(q: "Arthur", page: 1)
    }
    override func setUpUI() {
        super.setUpUI()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.addSubview(searchBar)
        
        searchBar.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        setUpCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    override func setBind() {
        super.setBind()
        
        viewModel.didFinishFetchUserData.bind(to: collectionView.rx.items(cellIdentifier: "SearchCollectionViewCell")){ row, searchItems, cell in
            guard let cell = cell as? SearchCollectionViewCell else {return}
            cell.config(dto: searchItems)
        }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.subscribe { [weak self](text) in
            guard let strongSelf = self, let text = text.element else {return}
            strongSelf.viewModel.currentQ = text
            print(text)
        }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe { [weak self](_) in
            guard let strongSelf = self else {return}
            print("Search")
            strongSelf.searchBar.resignFirstResponder()
            strongSelf.viewModel.fetchUserData()
        }.disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe { [weak self](_) in
            guard let strongSelf = self else {return}
            print("Cancel")
            strongSelf.searchBar.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)
    }
    
    func setUpCollectionView(){
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 10, height: (UIScreen.main.bounds.width / 2) + 15)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 5)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = nil
        
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundView?.isHidden = true
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
    }
}

//MARK: UIScrollViewmdelegate
extension SearchViewController: UIScrollViewDelegate, UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > collectionView.frame.height else {return}
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10 && viewModel.isNeedLoadMore{
            print("Pull up to load more")
            viewModel.currentPage += 1
            viewModel.fetchUserData()
        }
    }
}
