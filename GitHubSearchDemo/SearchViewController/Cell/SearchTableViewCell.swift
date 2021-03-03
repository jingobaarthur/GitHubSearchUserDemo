//
//  SearchTableViewCell.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
extension SearchTableViewCell{
    func setUpUI(){
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(userImgView)
        contentView.addSubview(userNameLabel)
        userImgView.snp.makeConstraints { (maker) in
            maker.size.equalTo(50)
            maker.left.equalToSuperview().offset(16)
        }
        userNameLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().offset(-8)
            maker.left.equalTo(userImgView.snp.right).offset(8)
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
