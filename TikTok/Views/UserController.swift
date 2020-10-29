//
//  UserController.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/11/20.
//

import UIKit

struct User {
    var name:String
    var avatar:String
}

class UserController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var iconArow: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userCollection: UICollectionView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnBookMark: UIButton!
    @IBOutlet weak var following: UIView!
    @IBOutlet weak var follower: UIView!
    @IBOutlet weak var like: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var tabCollection: UICollectionView!
    let tabView = UIView()
    let temps : [User] = [
        User(name: "Đức Huy", avatar: "skeleton"),
        User(name: "Huy Đức", avatar: "astronaut")
    ]
    let tabs = [
        "music.note.list",
        "heart.circle.fill",
        "lock.fill"
    ]
    let blackView : UIView = {
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bv
    }()
    var active = true
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addBottomBorder(with: UIColor.lightGray, andWidth: 1)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showUsers))
        userView.addGestureRecognizer(gesture)
        
        userCollection.register(UserCell.self, forCellWithReuseIdentifier: "UCell")
        userCollection.isHidden = true
        userCollection.collectionViewLayout.invalidateLayout()
        userCollection.delegate = self
        userCollection.dataSource = self
        
        tabCollection.register(TabCell.self, forCellWithReuseIdentifier: "TCell")
        tabCollection.collectionViewLayout.invalidateLayout()
        tabCollection.delegate = self
        tabCollection.dataSource = self
        tabCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        tabCollection.addTopBorder(with: .opaqueSeparator, andWidth: 1)
        
        btnEdit.borderButton()
        btnBookMark.borderButton()
        following.addRightBorder(with: UIColor.opaqueSeparator, andWidth: 1)
        follower.addRightBorder(with: UIColor.opaqueSeparator, andWidth: 1)
        avatar.layer.cornerRadius = avatar.frame.height/2
        
        tabView.backgroundColor = .black
        tabView.frame = CGRect(x: mainView.frame.width/3-mainView.frame.width/4, y: tabCollection.frame.origin.y+50, width: 40, height: 3)
        view.addSubview(tabView)
    }
    
    @objc func showUsers() {
        view.addSubview(blackView)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showUsers))
        blackView.addGestureRecognizer(gesture)
        blackView.isHidden = !self.active
        blackView.topAnchor.constraint(equalTo: userCollection.bottomAnchor).isActive = true
        blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        iconArow.image = UIImage(systemName: active ? "arrowtriangle.up.fill":"arrowtriangle.down.fill")
        userCollection.isHidden = !active
        active.toggle()
    }
}

extension UserController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabCollection {
            return 3
        } else {
            return temps.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == userCollection {
            let cell = userCollection.dequeueReusableCell(withReuseIdentifier: "UCell", for: indexPath) as! UserCell
            cell.styleCell(index: indexPath.row, value: temps[indexPath.row])
            return cell
        } else {
            let cell = tabCollection.dequeueReusableCell(withReuseIdentifier: "TCell", for: indexPath) as! TabCell
            cell.setStyle(image: tabs[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == userCollection {
            return CGSize(width: mainView.frame.width, height: 70)
        } else {
            return CGSize(width: mainView.frame.width/4, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tabView.frame = CGRect(x: CGFloat(indexPath.row+1)*self.mainView.frame.width/3-self.mainView.frame.width/4+CGFloat(indexPath.row*15), y: collectionView.frame.origin.y+50, width: 40, height: 3)
        }, completion: nil)
    }
}

class UserCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(named: "bg")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 25
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let labelName : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let imageCheck : UIImageView = {
        let ic = UIImageView()
        ic.image = UIImage(systemName: "checkmark")
        ic.tintColor = UIColor(named: "text")
        ic.translatesAutoresizingMaskIntoConstraints = false
        return ic
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func styleCell(index:Int,value: User) {
        addSubview(imageView)
        addSubview(labelName)
        addSubview(imageCheck)
        
        imageView.image = UIImage(named: value.avatar)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let attributedText = NSMutableAttributedString(string: "\(index)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSMutableAttributedString(string: value.name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.gray]))
        labelName.numberOfLines = 0
        labelName.lineBreakMode = .byWordWrapping
        labelName.attributedText = attributedText
        labelName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        labelName.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        imageCheck.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageCheck.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageCheck.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        imageCheck.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
extension UIView {
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    func borderButton() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.opaqueSeparator.cgColor
        self.layer.cornerRadius = 5
    }
    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 10, width: borderWidth, height: frame.size.height/2)
        addSubview(border)
    }
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

}
class TabCell : UICollectionViewCell {
    let imageView : UIImageView = {
        let lb = UIImageView()
        lb.contentMode = .scaleAspectFill
        lb.tintColor = .opaqueSeparator
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    override var isSelected: Bool{
       didSet {
        imageView.tintColor = self.isSelected ? .black : .opaqueSeparator
       }
    }
    func setStyle(image:String) {
        addSubview(imageView)
        
        imageView.image = UIImage(systemName: image)
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
