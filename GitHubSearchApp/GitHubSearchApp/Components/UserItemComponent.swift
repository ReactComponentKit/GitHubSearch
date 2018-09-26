//
//  UserItemComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import ReactComponentKit
import SnapKit
import RxSwift
import YYWebImage

class UserItemComponent: UIViewComponent {
    
    private var htmlUrl: String? = nil
    private let disposeBag = DisposeBag()
    
    private lazy var cardView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        
        let cornerRadius: CGFloat = 3
        let shadowOffsetWidth: Int = 0
        let shadowOffsetHeight: Int = 3
        let shadowColor: UIColor? = UIColor.black
        let shadowOpacity: Float = 0.5
        
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = false
        view.layer.shadowColor = shadowColor?.cgColor
        view.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        view.layer.shadowOpacity = shadowOpacity
        
        return view
    }()
    
    private lazy var clickView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var htmlUrlLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var repoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var followerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, htmlUrlLabel, repoLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override var contentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100 + 32 + 16)
    }
    
    override func setupView() {
        addSubview(cardView)
        addSubview(clickView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(labelStackView)
        
        cardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        clickView.snp.makeConstraints { (make) in
            make.edges.equalTo(cardView)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        labelStackView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.top.equalTo(avatarImageView)
        }
    
        clickView.onTap { [weak self] in
            guard let strongSelf = self, let htmlUrl = strongSelf.htmlUrl else { return }
            strongSelf.dispatch(action: ClickItemAction(htmlUrl: htmlUrl))
        }.disposed(by: disposeBag)
    }
    
    override func configure<Item>(item: Item) {
        guard let userItem = item as? UserItemModel else { return }
        self.htmlUrl = userItem.user.htmlUrl
        self.nameLabel.text = userItem.user.name ?? userItem.user.login
        self.htmlUrlLabel.text = userItem.user.htmlUrl
        self.repoLabel.text =
        """
        Repo: \(userItem.user.totalRepoCount ?? 0) / Gist: \(userItem.user.totalGistCount ?? 0)
        Follower: \(userItem.user.followerCount ?? 0)
        Following: \(userItem.user.followingCount ?? 0)
        """
        if let avatarUrl = userItem.user.avatarUrl {
            self.avatarImageView.yy_setImage(with: URL(string: avatarUrl), options: [.progressiveBlur, .setImageWithFadeAnimation])
        }
    }
}
