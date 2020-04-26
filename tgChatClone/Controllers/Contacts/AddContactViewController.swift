//
//  AddContactViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/26.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddContactViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private var viewModel: AddContactViewModel?
    
    private lazy var photo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        NSLayoutConstraint.activate([
            iv.heightAnchor.constraint(equalToConstant: 80),
            iv.widthAnchor.constraint(equalToConstant: 80)
        ])
        return iv
    }()
    
    lazy var firstNameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    
    lazy var underline: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }()
    
    lazy var lastNameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindViewModel()
        setupNavbar()
        setupUI()
    }
    
    private func bindViewModel() {
        let profileHelper = ProfileHelper()
        viewModel = AddContactViewModel(firstName: firstNameField.rx.text.orEmpty.asDriver(), lastName: lastNameField.rx.text.orEmpty.asDriver(), profileHelper: profileHelper)
        viewModel?.friendPhoto.drive(photo.rx.image).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        let nameStack = UIStackView(arrangedSubviews: [firstNameField, underline, lastNameField])
        nameStack.axis = .vertical
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [photo, nameStack])
        mainStack.axis = .horizontal
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.spacing = 20
        mainStack.alignment = .center
        
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            mainStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ])
        
    }
    
    private func setupNavbar() {
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        let createBtn = UIBarButtonItem(title: "Create", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = createBtn
        navigationItem.title = "New Contact"
        let cancelTap: Signal<Void> = cancelBtn.rx.tap.asSignal()
        cancelTap.emit(onNext: { [weak self] e in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        let createTap: Signal<Void> = createBtn.rx.tap.asSignal()
        createTap.emit(onNext: { e in
            print("Create Contact")
        }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
