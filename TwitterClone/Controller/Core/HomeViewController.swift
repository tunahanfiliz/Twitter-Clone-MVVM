//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Ios Developer on 1.12.2022.
//

import UIKit
import FirebaseAuth
import Combine
import Firebase

class HomeViewController: UIViewController {
     
    private var viewModel = HomeViewModel()
    private var subscriptions:Set<AnyCancellable> = []
    
    private let timelineTableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return table
    }()
    
    
    private func navigationBarConfigure(){
        let size:CGFloat = 36
        let logoİmageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoİmageView.contentMode = .scaleAspectFill
        logoİmageView.image = UIImage(named: "tw")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoİmageView)
        navigationItem.titleView = middleView
        
        
        let profileİmage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileİmage, style: .plain, target: self, action: #selector(didTapProfile))
        
        navigationController?.navigationBar.tintColor = .label
        
    }
    @objc private func didTapProfile(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(timelineTableView)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        navigationBarConfigure()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
        bindViews()
    }
    @objc func didTapSignOut(){
        try? Auth.auth().signOut()
        handleAuthentication()
        
    }
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retreiveUser() // ana ekranda mevcut kullanıcıyı alcak
        
        
    }
    func completeUserOnboarding(){
        let vc = ProfileDataFromViewController()
        present(vc, animated: true)
    }
    
    func bindViews(){//viewdidload da çagrılmalı çunku giriş yapmış kullanıcıyı girdigimiz gibi görmeliyiz
        viewModel.$user.sink { [weak self]user in
            guard let user = user else{return}
            if !user.isUserOnboarded{
                self?.completeUserOnboarding()
            }
        }.store(in: &subscriptions)

    }

}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{return UITableViewCell()}
        
        return cell
    }
 
}



/* func scrollViewDidScroll(_ scrollView: UIScrollView) {
           if ((scrollView.contentOffset.y + scrollView.frame.size.height) > (scrollView.contentSize.height * (8/10)) )
           {
             ElemanEkle()
           }
 }*/
