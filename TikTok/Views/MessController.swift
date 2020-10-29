//
//  MessController.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/11/20.
//

import UIKit
struct AlertSection {
    var section: String
    var itemSection: [AlertItem]
}
struct AlertItem {
    var name: String
    var avatar: String
    var des: String
    var time: String
    var isNew : Bool
    var isFollow : Bool
}
class MessController: UIViewController {
    
    @IBOutlet weak var alertCollection: UICollectionView!
    let alerts : [AlertSection] = [
        AlertSection(section: "Tuần này", itemSection: [
        AlertItem(name: "TikTok", avatar: "tred", des: "#tiectrangmau", time: "3 ngày", isNew: true, isFollow: false)
        ]),
        AlertSection(section: "Trước đây", itemSection: [
            AlertItem(name: "Thông báo hệ thống", avatar: "tred", des: "#tiectrangmau", time: "5 ngày", isNew: true, isFollow: false)
        ]),
        AlertSection(section: "Tài khoản được đề xuất", itemSection: [
            AlertItem(name: "Karik", avatar: "heo", des: "Đã Follow Bạn", time: "1 tuần trước", isNew: false, isFollow: false),
            AlertItem(name: "Binz", avatar: "ma", des: "Đã Follow Bạn", time: "2 tuần trước", isNew: false, isFollow: false),
            AlertItem(name: "Wowy", avatar: "meo", des: "Đã Follow Bạn", time: "3 tuần trước", isNew: false, isFollow: true),
            AlertItem(name: "SuBoi", avatar: "vit", des: "Đã Follow Bạn", time: "4 tuần trước", isNew: false, isFollow: false)
        ])
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        alertCollection.delegate = self
        alertCollection.dataSource = self
        alertCollection.collectionViewLayout.invalidateLayout()
        alertCollection.register(AlertCell.self, forCellWithReuseIdentifier: "Acell")
    }
    
}
extension MessController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return alerts.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alerts[section].itemSection.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = alertCollection.dequeueReusableCell(withReuseIdentifier: "Acell", for: indexPath) as! AlertCell
        cell.setValueItem(item: alerts[indexPath.section].itemSection[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = alertCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MessHeader", for: indexPath) as! MessHeader
        header.categoryTitle = alerts[indexPath.section].section
        return header
    }
    
}
class AlertCell:UICollectionViewCell {
    let avatar:UIImageView = {
        let av = UIImageView()
        av.contentMode = .scaleToFill
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    let text:UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let btnFollow : UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let btnNavigation : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "arrow.right.circle"), for: .normal)
        btn.tintColor = .opaqueSeparator
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var follow = true
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setValueItem(item: AlertItem) {
        addSubview(avatar)
        addSubview(text)
        
        avatar.image = UIImage(named: item.avatar)
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatar.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10).isActive = true
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 25
        
        text.leadingAnchor.constraint(equalTo: avatar.trailingAnchor,constant: 10).isActive = true
        text.centerYAnchor.constraint(equalTo: avatar.centerYAnchor).isActive = true
        let attributedText = NSMutableAttributedString(string: "\(item.name)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSMutableAttributedString(string: item.des, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: " \(item.time)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.gray]))
        text.attributedText = attributedText
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        
        if item.isNew {
            addBtnNavigation()
        } else {
            addBtnFollow()
            follow = item.isFollow
            follow ? setBtnFollow():setBtnChat()
        }
    }
    func addBtnNavigation() {
        addSubview(btnNavigation)
        
        btnNavigation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnNavigation.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnNavigation.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        btnNavigation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    func addBtnFollow() {
        addSubview(btnFollow)
        
        btnFollow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnFollow.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btnFollow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        btnFollow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        btnFollow.addTarget(self, action: #selector(didButtonClick(_:)), for: .touchUpInside)
    }
    @objc func didButtonClick(_ sender:UIButton) {
        btnFollow.blink()
        follow.toggle()
        follow ? setBtnFollow():setBtnChat()
    }
    func setBtnChat() {
        btnFollow.setTitle("Nhắn tin", for: .normal)
        btnFollow.setTitleColor(.black, for: .normal)
        btnFollow.backgroundColor = .white
        btnFollow.layer.masksToBounds = true
        btnFollow.layer.borderWidth = 1
        btnFollow.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    func setBtnFollow() {
        btnFollow.setTitle("Follow lại", for: .normal)
        btnFollow.setTitleColor(.white, for: .normal)
        btnFollow.backgroundColor = UIColor(named: "text")
        btnFollow.layer.borderColor = UIColor(named: "text")?.cgColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class MessHeader: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    var categoryTitle : String! {
        didSet {
            titleLabel.text = categoryTitle
        }
    }
}
