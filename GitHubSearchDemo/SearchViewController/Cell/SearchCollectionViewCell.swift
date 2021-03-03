//
//  SearchCollectionViewCell.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    let userImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .lightGray
        return imgView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        userImgView.image = nil
    }
}
extension SearchCollectionViewCell{
    func setUpUI(){
        
        self.backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(userImgView)
        contentView.addSubview(userNameLabel)
        
        userImgView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.75)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userImgView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    func config(dto: SearchUserItem){
        guard let name = dto.username, let urlString = dto.profileImageUrl else {return}
        userNameLabel.text = name
        if let url = URL(string: urlString){
            userImgView.setUpImage(with: url, placeholder: UIImage(), errorPlaceholder: UIImage(), completeBlock: nil)
        }
    }
}
