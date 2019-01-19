//
//  RepoItemComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import ReactComponentKit
import YYWebImage
import RxSwift

class RepoItemComponent: UIViewComponent {
    
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
        view.layer.cornerRadius = 16
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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var htmlUrlLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, htmlUrlLabel, infoLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()
    
    override var contentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: labelStackView.intrinsicContentSize.height)
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
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(32)
        }
        
        labelStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(avatarImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        clickView.onTap { [weak self] in
            guard let strongSelf = self, let htmlUrl = strongSelf.htmlUrl else { return }
            strongSelf.dispatch(action: ClickItemAction(htmlUrl: htmlUrl))
        }.disposed(by: disposeBag)
    }
    
    override func configure<Item>(item: Item, at indexPath: IndexPath) {
        guard let repoItem = item as? RepoItemModel else { return }
        self.htmlUrl = repoItem.repo.htmlUrl
        self.nameLabel.text = repoItem.repo.name
        self.descriptionLabel.text = repoItem.repo.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.htmlUrlLabel.text = repoItem.repo.htmlUrl
        self.infoLabel.text = "\(repoItem.repo.language ?? "Unknown") ⭐️\(repoItem.repo.starCount) 🐙\(repoItem.repo.forkCount) 🤩\(repoItem.repo.watcherCount)"
        if let avatarUrl = repoItem.repo.owner.avatarUrl {
            self.avatarImageView.yy_setImage(with: URL(string: avatarUrl), options: [.progressiveBlur, .setImageWithFadeAnimation])
        }
    }
}
