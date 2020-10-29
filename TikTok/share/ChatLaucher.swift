//
//  ChatLaucher.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/16/20.
//

import Foundation
import UIKit

struct Comment {
    var name : String
    var image : String
    var content : String
    var like : Int
}

class ChatLaucher : NSObject {
    let bgViewComment = UIView()
    let whiteView = UIView()
    let cellID = "cellID"
    var temps : [Comment] = [
        Comment(name: "Đức Huy", image: "", content: "Hay quá đi", like: 5),
        Comment(name: "Huy Đức", image: "", content: "Ok quá nè", like: 2)
    ]
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let quitView : UIView = {
        let qv = UIView()
        qv.translatesAutoresizingMaskIntoConstraints = false
        return qv
    }()
    let chatView : UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let textField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "..."
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        tf.backgroundColor = .white
        return tf
    }()
    let btnQuit : UIButton = {
        let image = UIImage(systemName: "xmark.circle.fill") as UIImage?
        let btn = UIButton(type: .custom) as UIButton
        btn.setImage(image, for: .normal)
        btn.tintColor = .lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let btnChat : UIButton = {
        let image = UIImage(systemName: "paperplane.fill") as UIImage?
        let btn = UIButton(type: .custom) as UIButton
        btn.setImage(image, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    @objc func didButtonClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.bgViewComment.alpha = 0
            self.whiteView.alpha = 0
        }
    }
    override init() {
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    func showView() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            bgViewComment.backgroundColor = UIColor.clear
            bgViewComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            bgViewComment.frame = window.frame
            bgViewComment.alpha = 1
            
            window.addSubview(bgViewComment)
            window.addSubview(whiteView)
            
            whiteView.backgroundColor = .white
            whiteView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height/2)
            whiteView.roundCorners(corners: [.topLeft,.topRight], radius: 15)
            whiteView.alpha = 1
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.whiteView.frame = CGRect(x: 0, y: window.frame.height/2, width: window.frame.width, height: window.frame.height/2)
            }, completion: nil)
            
            whiteView.addSubview(collectionView)
            whiteView.addSubview(quitView)
            whiteView.addSubview(chatView)
            
            quitView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            quitView.widthAnchor.constraint(equalToConstant:  whiteView.frame.width).isActive = true
            quitView.topAnchor.constraint(equalTo: whiteView.topAnchor).isActive = true
            btnQuit.addTarget(self, action: #selector(didButtonClick(_:)), for: .touchUpInside)
            quitView.addSubview(btnQuit)
            
            btnQuit.heightAnchor.constraint(equalToConstant: 25).isActive = true
            btnQuit.widthAnchor.constraint(equalToConstant:  25).isActive = true
            btnQuit.centerYAnchor.constraint(equalTo: quitView.centerYAnchor).isActive = true
            btnQuit.trailingAnchor.constraint(equalTo: quitView.trailingAnchor, constant: -10).isActive = true
            
            chatView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            chatView.widthAnchor.constraint(equalToConstant:  whiteView.frame.width).isActive = true
            chatView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor).isActive = true
            chatView.addSubview(textField)
            chatView.addSubview(btnChat)
            
            textField.topAnchor.constraint(equalTo: chatView.topAnchor, constant: 5).isActive = true
            textField.bottomAnchor.constraint(equalTo: chatView.bottomAnchor, constant: -5).isActive = true
            textField.leadingAnchor.constraint(equalTo: chatView.leadingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: btnChat.trailingAnchor).isActive = true
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
            textField.leftViewMode = .always
            
            btnChat.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btnChat.widthAnchor.constraint(equalToConstant:  40).isActive = true
            btnChat.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
            btnChat.trailingAnchor.constraint(equalTo: chatView.trailingAnchor, constant: -10).isActive = true
            btnChat.layer.cornerRadius = 20
            
            collectionView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: quitView.bottomAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: chatView.topAnchor).isActive = true
        }
    }
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.bgViewComment.alpha = 0
            self.whiteView.alpha = 0
        }
    }
}
extension ChatLaucher : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return temps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatCell
        cell.setValue(value: temps[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}
class ChatCell: UICollectionViewCell {
    let avatar : UIImageView = {
       let av = UIImageView()
        av.contentMode = .scaleAspectFill
        av.image = UIImage(named: "tik-tok")
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    let likeIcon : UIImageView = {
        let li = UIImageView()
        li.image = UIImage(systemName: "heart")
        li.tintColor = .lightGray
        li.translatesAutoresizingMaskIntoConstraints = false
        return li
    }()
    let labelLike : UILabel = {
        let ll = UILabel()
        ll.font = UIFont.boldSystemFont(ofSize: 15.0)
        ll.textColor = .lightGray
        ll.translatesAutoresizingMaskIntoConstraints = false
        return ll
    }()
    let labelValue : UILabel = {
        let lv = UILabel()
        lv.numberOfLines = 2
        lv.translatesAutoresizingMaskIntoConstraints = false
        return lv
    }()
    let labelName : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 15.0)
        lb.textColor = .lightGray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setValue(value : Comment) {
        backgroundColor = .white
        
        addSubview(avatar)
        addSubview(labelName)
        addSubview(likeIcon)
        addSubview(labelLike)
        addSubview(labelValue)
        
        avatar.widthAnchor.constraint(equalToConstant: 30).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        avatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        
        labelName.text = value.name
        labelName.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 5).isActive = true
        labelName.centerYAnchor.constraint(equalTo: avatar.topAnchor).isActive = true
        
        likeIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        likeIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        labelLike.text = "\(value.like)"
        labelLike.topAnchor.constraint(equalTo: likeIcon.bottomAnchor, constant: 5).isActive = true
        labelLike.centerXAnchor.constraint(equalTo: likeIcon.centerXAnchor).isActive = true
    
        let attributedText = NSMutableAttributedString(string: value.content, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSMutableAttributedString(string: "  20-10", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.gray]))
        labelValue.attributedText = attributedText
        labelValue.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 5).isActive = true
        labelValue.trailingAnchor.constraint(equalTo: labelLike.leadingAnchor, constant: 5).isActive = true
        labelValue.centerYAnchor.constraint(equalTo: avatar.centerYAnchor).isActive = true
    }
   
}
