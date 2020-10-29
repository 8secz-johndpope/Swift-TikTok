//
//  ShareLaucher.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/23/20.
//

import Foundation
import UIKit

struct  SharesItem {
    var name: String
    var image: String
}

struct Shares  {
    var nameSection : String
    var sections : [SharesItem]
}

class ShareLaucher : NSObject  {
    
    let items : [Shares] = [
        Shares(nameSection: "Gửi đến", sections: [
            SharesItem(name: "Đức Huy", image: "vit"),
            SharesItem(name: "Thu Trang", image: "vit"),
            SharesItem(name: "Hữu Thành", image: "meo"),
            SharesItem(name: "Trọng Toàn", image: "ma"),
            SharesItem(name: "Xuân Tài", image: "heo"),
            SharesItem(name: "Nguyễn Sỹ", image: "meo"),
            SharesItem(name: "Xuân Khánh", image: "ma")
        ]),Shares(nameSection: "Chia sẻ đến", sections: [
            SharesItem(name: "Tin nhắn", image: "whatsapp"),
            SharesItem(name: "Messenger", image: "messenger"),
            SharesItem(name: "Facebook", image: "facebook"),
            SharesItem(name: "Youtube", image: "youtube"),
            SharesItem(name: "SMS", image: "telegram"),
            SharesItem(name: "Sao chép Liên kết", image: "slack"),
            SharesItem(name: "Email", image: "linkedin"),
            SharesItem(name: "Instagram", image: "instagram")
        ]),Shares(nameSection: " ", sections: [
            SharesItem(name: "Báo cáo", image: "exclamationmark.triangle"),
            SharesItem(name: "Không quan tâm", image: "slash.circle"),
            SharesItem(name: "Lưu video", image: "square.and.arrow.down"),
            SharesItem(name: "Duet", image: "person.crop.circle.badge.plus"),
            SharesItem(name: "Stitch", image: "rectangle.dashed.and.paperclip"),
            SharesItem(name: "Thêm vào yêu thích", image: "bookmark"),
            SharesItem(name: "Live Photo", image: "livephoto"),
            SharesItem(name: "Chia sẻ dưới dạng GIF", image: "text.below.photo")
        ])
    ]
    
    let bgView = UIView()
    let whiteView =  UIView()
    let btnBack : UIButton = {
        let btn = UIButton()
        btn.setTitle("Huỷ", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    let collectionShare : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    let labelSend: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "Gửi đến"
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textColor = .gray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let labelShare: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "Chia sẻ đến"
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textColor = .gray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let actionCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    override init() {
        super.init()
    }
    func showView() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            
            window.addSubview(bgView)
            bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            bgView.frame = window.frame
            bgView.alpha = 1
            bgView.backgroundColor = .clear
            window.addSubview(whiteView)
            whiteView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height/2+20)
            whiteView.alpha = 1
            whiteView.backgroundColor = .white
            whiteView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.whiteView.frame = CGRect(x: 0, y: window.frame.height/2-25, width: window.frame.width, height: window.frame.height/2+25)
            }, completion: nil)
            
            whiteView.addSubview(btnBack)
            btnBack.heightAnchor.constraint(equalToConstant: 50).isActive = true
            btnBack.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor).isActive
                = true
            btnBack.widthAnchor.constraint(equalToConstant:  whiteView.frame.width).isActive = true
            btnBack.addTopBorder(with: UIColor.opaqueSeparator, andWidth: 1)
            btnBack.addTarget(self, action: #selector(didButtonClick(_:)), for: .touchUpInside)

            whiteView.addSubview(labelSend)
            labelSend.alpha = 1
            labelSend.topAnchor.constraint(equalTo: whiteView.topAnchor).isActive = true
            labelSend.heightAnchor.constraint(equalToConstant: 30).isActive = true
            labelSend.widthAnchor.constraint(equalToConstant: whiteView.frame.width).isActive = true
            
            whiteView.addSubview(collectionView)
            collectionView.alpha = 1
            collectionView.topAnchor.constraint(equalTo: labelSend.bottomAnchor).isActive = true
            collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            collectionView.widthAnchor.constraint(equalToConstant: whiteView.frame.width).isActive = true
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.register(ShareCell.self, forCellWithReuseIdentifier: "SCell")
            collectionView.showsHorizontalScrollIndicator = false
            
            whiteView.addSubview(labelShare)
            labelShare.alpha = 1
            labelShare.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
            labelShare.heightAnchor.constraint(equalToConstant: 30).isActive = true
            labelShare.widthAnchor.constraint(equalToConstant: whiteView.frame.width).isActive = true
            
            whiteView.addSubview(collectionShare)
            collectionShare.alpha = 1
            collectionShare.topAnchor.constraint(equalTo: labelShare.bottomAnchor).isActive = true
            collectionShare.heightAnchor.constraint(equalToConstant: 80).isActive = true
            collectionShare.widthAnchor.constraint(equalToConstant: whiteView.frame.width).isActive = true
            collectionShare.delegate = self
            collectionShare.dataSource = self
            collectionShare.collectionViewLayout.invalidateLayout()
            collectionShare.register(SendCell.self, forCellWithReuseIdentifier: "ShareCell")
            collectionShare.showsHorizontalScrollIndicator = false
            
            whiteView.addSubview(actionCollection)
            actionCollection.addTopBorder(with: UIColor.opaqueSeparator, andWidth: 1)
            actionCollection.alpha = 1
            actionCollection.bottomAnchor.constraint(equalTo: btnBack.topAnchor).isActive = true
            actionCollection.heightAnchor.constraint(equalToConstant: 90).isActive = true
            actionCollection.widthAnchor.constraint(equalToConstant: whiteView.frame.width).isActive = true
            actionCollection.delegate = self
            actionCollection.dataSource = self
            actionCollection.collectionViewLayout.invalidateLayout()
            actionCollection.register(ActionCell.self, forCellWithReuseIdentifier: "ActionCell")
            actionCollection.showsHorizontalScrollIndicator = false
        }
    }
    @objc func didButtonClick(_ sender: UIButton) {
        quitView()
    }
    @objc func handleDismiss() {
        quitView()
    }
    func quitView() {
        UIView.animate(withDuration: 0.5) {
            self.bgView.alpha = 0
            self.whiteView.alpha = 0
        }
    }
}
extension ShareLaucher : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionShare {
            return items[1].sections.count
        } else if collectionView == actionCollection {
            return items[2].sections.count
        } else {
            return items[0].sections.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionShare {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareCell", for: indexPath) as! SendCell
            cell.setStyle(item: items[1].sections[indexPath.row])
            return cell
        } else if collectionView == actionCollection {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell", for: indexPath) as! ActionCell
            cell.setStyle(item: items[2].sections[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCell", for: indexPath) as! ShareCell
            cell.setStyle(item: items[0].sections[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bgView.frame.width/5, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
class ShareCell: UICollectionViewCell {
    let avatar : UIImageView = {
        let av = UIImageView()
        av.contentMode = .scaleToFill
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    let name : UILabel = {
        let av = UILabel()
        av.textColor = .opaqueSeparator
        av.font = UIFont.boldSystemFont(ofSize: 10)
        av.textAlignment = .center
        av.numberOfLines = 2
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setStyle(item:SharesItem) {
        addSubview(avatar)
        addSubview(name)
        avatar.image = UIImage(named: item.image)
        avatar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        avatar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.gray.cgColor
        avatar.layer.cornerRadius = 25
        
        name.text = item.name
        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5).isActive = true
    }
}
class SendCell: UICollectionViewCell {
    let avatar : UIImageView = {
        let av = UIImageView()
        av.contentMode = .scaleToFill
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    let name : UILabel = {
        let av = UILabel()
        av.textColor = .opaqueSeparator
        av.font = UIFont.boldSystemFont(ofSize: 10)
        av.textAlignment = .center
        av.numberOfLines = 2
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setStyle(item:SharesItem) {
        addSubview(avatar)
        addSubview(name)
        avatar.image = UIImage(named: item.image)
        avatar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        avatar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        name.text = item.name
        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5).isActive = true
    }
}

class ActionCell : UICollectionViewCell {
    let avatar : UIButton = {
        let av = UIButton()
        av.tintColor = .black
        av.backgroundColor = .opaqueSeparator
        av.layer.cornerRadius = 25
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    let name : UILabel = {
        let av = UILabel()
        av.textColor = .opaqueSeparator
        av.font = UIFont.boldSystemFont(ofSize: 10)
        av.textAlignment = .center
        av.numberOfLines = 2
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setStyle(item:SharesItem) {
        addSubview(avatar)
        addSubview(name)
        
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .small)
        
        let largeBoldDoc = UIImage(systemName: item.image, withConfiguration: largeConfig)
        
        avatar.setImage(largeBoldDoc, for: .normal)
        avatar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        avatar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        name.text = item.name
        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5).isActive = true
    }
}
