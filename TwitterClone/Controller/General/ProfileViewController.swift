//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Ios Developer on 5.12.2022.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {

    private var isStatusBarHidden:Bool = true
    private var viewModel = ProfileViewModel()
    
    private var subscriptions:Set<AnyCancellable> = []
    
    private let statusBar:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var profileHeaderView = ProfileHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))//profile table view i burda kullanabilmek için lazy var yaptık
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        profileTableView.delegate = self
        profileTableView.dataSource = self
        configureProfileTableViewConstraints()
    
        
        //let profileHeader = ProfileHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
        profileTableView.tableHeaderView = profileHeaderView
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        bindViews() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retreiveUser()
    }
    
    private func bindViews(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else{return}
            //artık profileheaderdeki display name vs şeylere erişimimiz var
            self?.profileHeaderView.displayNameLabel.text = user.displayName
            self?.profileHeaderView.userNameLabel.text = "@\(user.username )"
            self?.profileHeaderView.followersCountLabel.text = "\(user.followersCount)"//double to string
            self?.profileHeaderView.followingCountLabel.text = "\(user.followingCount)"
            self?.profileHeaderView.userBioLabel.text = user.bio
            self?.profileHeaderView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
        }
        .store(in: &subscriptions)
    }
    
    private func configureProfileTableViewConstraints(){
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ])
    }
   

}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{return UITableViewCell()}
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: { _ in }
            
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear){ [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
    
}
