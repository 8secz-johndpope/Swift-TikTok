//
//  ViewController.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/10/20.
//

import UIKit
struct TabBarItem {
    var image: String
    var value: String
}
class ViewController: UIViewController {
    @IBOutlet weak var tabBar: UICollectionView!
    let cellID = "tabbar"
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var messView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var photoView: UIView!
    let items : [TabBarItem] = [
        TabBarItem(image: "music.house.fill", value: "Trang chủ"),
        TabBarItem(image: "magnifyingglass", value: "Khám phá"),
        TabBarItem(image: "plus.app.fill", value: ""),
        TabBarItem(image: "message", value: "Hộp thư"),
        TabBarItem(image: "person", value: "Tôi")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        WelcomeController.instance.showView(frame: view.frame)
        tabBar.register(TabBarCell.self, forCellWithReuseIdentifier: cellID)
        tabBar.delegate = self
        tabBar.dataSource = self
        tabBar.collectionViewLayout.invalidateLayout()
        hideView()
        homeView.isHidden = false
    }
    func hideView() {
        homeView.isHidden = true
        searchView.isHidden = true
        messView.isHidden = true
        userView.isHidden = true
        photoView.isHidden = true
    }
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = tabBar.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TabBarCell
        cell.image.image = UIImage(systemName: items[indexPath.row].image)
        cell.selectedIndexPath(indexPath)
        if items[indexPath.row].value.isEmpty {
            cell.label.isHidden  = true
        } else {
            cell.label.text = items[indexPath.row].value
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tabBar.frame.width/5, height: tabBar.frame.height - (tabBar.safeAreaInsets.top + tabBar.safeAreaInsets.bottom))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hideView()
        switch  indexPath.row {
        case 0:
            homeView.isHidden = false
        case 1:
            searchView.isHidden = false
        case 2:
            photoView.isHidden = false
        case 3:
            messView.isHidden = false
        case 4:
            userView.isHidden = false
        default:
            hideView()
        }
        if indexPath.row != 0 {
            WelcomeController.instance.stopVideo()
        } else {
            WelcomeController.instance.startVideo()
        }
    }
}
class TabBarCell:UICollectionViewCell {
    fileprivate let image : UIImageView = {
        let vc = UIImageView()
        vc.tintColor = .white
        return vc
    }()
    fileprivate let label : UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = lb.font.withSize(10)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func selectedIndexPath(_ indexPath: IndexPath) {

        setStyleImage(index: indexPath.row)
        setStyleLabel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setStyleImage(index:Int) {
        addSubview(image)
        let cons = index == 2 ? 50:30
        image.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = image.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let verticalConstraint = image.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let widthConstraint = image.widthAnchor.constraint(equalToConstant: CGFloat(cons))
        let heightConstraint = image.heightAnchor.constraint(equalToConstant: 30)
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    func setStyleLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let botLabel = label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5)
        let horizontalLabel = label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        self.addConstraints([botLabel,horizontalLabel])
    }
}
