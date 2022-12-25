//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Ios Developer on 10.12.2022.
//

import UIKit

class ProfileHeader: UIView {
    
    private enum SectionTabs:String{
        case tweets = "Tweets"
        case tweetsAndReplies = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
        
        var index:Int{
            switch self{
                
            case .tweets:
                return 0
            case .tweetsAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    private var leadingAnchors:[NSLayoutConstraint] = []
    private var trailingAnchors:[NSLayoutConstraint] = []
    
    private let indicator:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return view
    }()
    
    private var selectedTab : Int = 0 { //didtaptabs buton işlevinin neler yaptıgını burda görebilir ve genişletebiliriz. atıyorum print(selectedtab) olsaydı tıklanan butonun indexini yazdırırdı 0 1 2 3 gibi
        didSet{
            for i in 0..<tabs.count{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {[weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel //animasyonla seçili olan .label olsun seçili olmayan renk .secondary olsun demek
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false //seçili olan butondaki sınırlandırmalar aktif olsun diğer butonlardaki o mavi çizgi olmasın demek :false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()//animasyonu tetikler
                } completion: { _ in
                    
                }

            }
        }
    }
    
    private var tabs:[UIButton] = ["Tweets","Tweets & Replies","Media","Likes"]
        .map{buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.tintColor = .label
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    private lazy var sectionStack:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let followersTextLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Followers"
        return label
    }()
    
    var followersCountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let followingTextLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Following"
        return label
    }()
    
    var followingCountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    var joinedDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Joined May 2021"
        return label
    }()
    
    private let joinDateImageView:UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "calendar",withConfiguration: UIImage.SymbolConfiguration(pointSize:14))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .secondaryLabel
        return image
    }()
    
    var userBioLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 3
        return label
    }()
    
    var userNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    var displayNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let ProfileHeaderImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "rabi")
        image.clipsToBounds = true
        return image
    }()
    
    var profileAvatarImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 40
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        //image.image = UIImage(systemName: "person")
        //image.backgroundColor = .yellow
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .red
        profileHeaderConfiguration()
        profileAvatarConfiguration()
        displayNameLabelConfiguration()
        userNameLabelConfiguration()
        userBioLabelConfiguration()
        joinDateImageViewConfiguration()
        joinedDateLabelConfiguration()
        followingConfiguration()
        followersConfiguration()
        sectionStackConfiguration()
        configureStackButton()
        indicatorConfiguration()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func indicatorConfiguration(){
        addSubview(indicator)
        
        for i in 0..<tabs.count{
            // butonların titlesinin uzunluğuna göre sınırlandırılacak ve dizilerine eklicez döngüye soktuk
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
            
            NSLayoutConstraint.activate([
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor), //seçili olan  butonun altında  olsun demek
            indicator.heightAnchor.constraint(equalToConstant: 4)
            ])
        }
    }
    
    private func configureStackButton(){
        for (i,button) in sectionStack.arrangedSubviews.enumerated(){
            guard let button = button as? UIButton else {return}
            if i == selectedTab { // i seçilen butona eşitse değilse olayı
                button.tintColor = .label
            }else{
                button.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTapTabs(_:)), for: .touchUpInside)
        }
    }
    @objc private func didTapTabs(_ sender:UIButton){ //bu düğmelerdeki ilk adım
        guard let label = sender.titleLabel?.text else {return} // dokunulan düğmenin etiketine sahibiz ve switch label yaparak hangisiyse selected tab budur deriz.
        switch label{
        case SectionTabs.tweets.rawValue:
            selectedTab = 0
        case SectionTabs.tweetsAndReplies.rawValue:
            selectedTab = 1
        case SectionTabs.media.rawValue:
            selectedTab = 2
        case SectionTabs.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    
    private func profileHeaderConfiguration(){
        addSubview(ProfileHeaderImage)
        
        NSLayoutConstraint.activate([
            ProfileHeaderImage.topAnchor.constraint(equalTo: topAnchor),
            ProfileHeaderImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            ProfileHeaderImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            ProfileHeaderImage.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func profileAvatarConfiguration(){
        addSubview(profileAvatarImageView)
        
        NSLayoutConstraint.activate([
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: ProfileHeaderImage.bottomAnchor,constant: 10),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func displayNameLabelConfiguration(){
        addSubview(displayNameLabel)
        
        NSLayoutConstraint.activate([
            displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor,constant:20)
        ])
    }
    
    private func userNameLabelConfiguration(){
        addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor,constant:5)
        ])
    }
    
    private func userBioLabelConfiguration(){
        addSubview(userBioLabel)
        
        NSLayoutConstraint.activate([
            userBioLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userBioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant:5),
            userBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5)
        ])
    }

    private func joinDateImageViewConfiguration(){
        addSubview(joinDateImageView)
        
        NSLayoutConstraint.activate([
            joinDateImageView.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor,constant:5)
        ])
    }
    
    private func joinedDateLabelConfiguration(){
        addSubview(joinedDateLabel)
        
        NSLayoutConstraint.activate([
            joinedDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor,constant: 2),
            joinedDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
        ])
    }
    private func followingConfiguration(){
        addSubview(followingCountLabel)
        addSubview(followingTextLabel)
        
        NSLayoutConstraint.activate([
            followingCountLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            followingCountLabel.topAnchor.constraint(equalTo: joinedDateLabel.bottomAnchor,constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor,constant: 4),
            followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ])
        
    }
    
    private func followersConfiguration(){
        addSubview(followersCountLabel)
        addSubview(followersTextLabel)
        
        NSLayoutConstraint.activate([
            followersCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor,constant: 8),
            followersCountLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor,constant: 4),
            followersTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ])
    }
    
    private func sectionStackConfiguration(){
        addSubview(sectionStack)
        
        
        NSLayoutConstraint.activate([
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor,constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
