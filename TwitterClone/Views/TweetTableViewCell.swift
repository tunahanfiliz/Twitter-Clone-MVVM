//
//  TweetTableViewCell.swift
//  TwitterClone
//
//  Created by Ios Developer on 3.12.2022.
//

import UIKit

protocol TweetTableViewCellDelegate:AnyObject{
    func TweetTableViewCellDidTapReply()
    func TweetTableViewCellDidTapRetweet()
    func TweetTableViewCellDidTapLike()
    func TweetTableViewCellDidTapShare()
}

class TweetTableViewCell: UITableViewCell {

 
    static let identifier = "TweetTableViewCell"
    
    weak var delegate:TweetTableViewCellDelegate?
    
    private let spaceButton : CGFloat = 60
    
    private let avatarImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .red
        return imageView
        
    }()
    
    private let displayNameLabel: UILabel = {
       let label = UILabel()
        label.text = "tunahanfiliz"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
         label.text = "@tuna"
        label.textColor = .secondaryLabel
         label.font = .systemFont(ofSize: 16, weight: .regular)
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()

    private let tweetTextContentLabel: UILabel = {
        let label = UILabel()
         label.text = "i am ios developer. ---------------------------------aaaaaaaaaaaa.......bbbbbbbb...c.cc.cc.c.c.c "
         label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
         return label
     }()
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray2
        return button
     }()
    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .systemGray2
        return button
     }()
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray2
        return button
     }()
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemGray2
        return button
     }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        avatarImageViewConfigureContraints()
        displayLabelConfigureContraints()
        usernameLabelConfigureContraints()
        tweetTextConfigureContraints()
        replyButtonConfigureContraints()
        retweetButtonConfigureContraints()
        likeButtonConfigureContraints()
        shareButtonConfigureContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func avatarImageViewConfigureContraints(){
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 14),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        
        ])
        
    }
    
    @objc private func didTapReply(){
        delegate?.TweetTableViewCellDidTapReply()
    }
    @objc private func didTapRetweet(){
        delegate?.TweetTableViewCellDidTapRetweet()
    }
    @objc private func didTapLike(){
        delegate?.TweetTableViewCellDidTapLike()
    }
    @objc private func didTapShare(){
        delegate?.TweetTableViewCellDidTapShare()
    }
    
    private func configureButtons(){
        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapRetweet), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    private func displayLabelConfigureContraints(){
        contentView.addSubview(displayNameLabel)
        
        NSLayoutConstraint.activate([
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,constant: 20),
            displayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20)
        ])
    }

    private func usernameLabelConfigureContraints(){
        contentView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor,constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor)
        ])
    }

    private func tweetTextConfigureContraints(){
        contentView.addSubview(tweetTextContentLabel)
        
        NSLayoutConstraint.activate([
            tweetTextContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            tweetTextContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor,constant: 10),
            tweetTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15)
            
        ])
    }
    private func replyButtonConfigureContraints(){
        contentView.addSubview(replyButton)
        
        NSLayoutConstraint.activate([
            replyButton.leadingAnchor.constraint(equalTo: tweetTextContentLabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: tweetTextContentLabel.bottomAnchor,constant: 10),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -15),
        ])
    }
    private func retweetButtonConfigureContraints(){
        contentView.addSubview(retweetButton)
        
        NSLayoutConstraint.activate([
            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor,constant: spaceButton),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ])
    }
    private func likeButtonConfigureContraints(){
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor,constant: spaceButton),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ])
    }
    private func shareButtonConfigureContraints(){
        contentView.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor,constant: spaceButton),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ])
    }
}
