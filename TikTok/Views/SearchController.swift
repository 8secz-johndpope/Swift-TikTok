//
//  SearchController.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/11/20.
//

import UIKit

struct HagTag {
    var name : String
    var view : String
    var element : [String]
}

class SearchController: UIViewController {
    
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var adCollection: UICollectionView!
    @IBOutlet weak var tableHagTag: UITableView!
    let ads = ["meo","ma","vit","heo"]
    let tags : [HagTag] = [
        HagTag(name: "#Haloween", view: "350M", element: [
            "ma","ma","ma","ma"
        ]),
        HagTag(name: "#TamDiemAnhNhin", view: "280M", element: [
            "heo","heo","heo","heo"
        ])
    ]
    let bgField : UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor(named: "bg")
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()
    let iconSearch : UIImageView = {
        let im = UIImageView()
        im.tintColor = .lightGray
        im.image = UIImage(systemName: "magnifyingglass")
        im.contentMode = .scaleAspectFit
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    let searchField : UITextField = {
        let sf = UITextField()
        sf.placeholder = "..."
        sf.translatesAutoresizingMaskIntoConstraints = false
        return sf
    }()
    let btnQR : UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .small)
        
        let largeBoldDoc = UIImage(systemName: "qrcode.viewfinder", withConfiguration: largeConfig)
        
        btn.setImage(largeBoldDoc, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        return btn
    }()
    let btnGoBack : UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .small)
        
        let largeBoldDoc = UIImage(systemName: "arrowshape.turn.up.left.2.fill", withConfiguration: largeConfig)
        
        btn.setImage(largeBoldDoc, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        return btn
    }()
    
    let btnSubmitSearch : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor(named: "text"), for: .normal)
        btn.setTitle("Tìm kiếm", for: .normal)
        btn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 10)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let barADCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        styleDefaultSearch()
        NotificationCenter.default.addObserver(self, selector: #selector(SearchController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        adCollection.delegate = self
        adCollection.dataSource = self
        adCollection.collectionViewLayout.invalidateLayout()
        adCollection.isPagingEnabled = true
        adCollection.showsHorizontalScrollIndicator = false
        adCollection.register(ADCell.self, forCellWithReuseIdentifier: "ADCell")
        
        view.addSubview(barADCollection)
        
        barADCollection.bottomAnchor.constraint(equalTo: adCollection.bottomAnchor,constant: 10).isActive = true
        barADCollection.widthAnchor.constraint(equalToConstant: CGFloat(ads.count*20)).isActive = true
        barADCollection.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        barADCollection.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        barADCollection.delegate = self
        barADCollection.dataSource = self
        barADCollection.collectionViewLayout.invalidateLayout()
        barADCollection.isPagingEnabled = true
        barADCollection.showsHorizontalScrollIndicator = false
        barADCollection.register(BarCell.self, forCellWithReuseIdentifier: "BarCell")
        barADCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        tableHagTag.delegate = self
        tableHagTag.dataSource = self
        tableHagTag.separatorColor = .clear
    }
    @objc func didButtonClick(_ sender: UIButton) {
        btnQR.blink()
    }
    var leadindBgField : NSLayoutConstraint?
    func styleDefaultSearch() {
        viewSearch.addSubview(bgField)
        viewSearch.addSubview(btnQR)
        
        btnQR.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnQR.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btnQR.trailingAnchor.constraint(equalTo: viewSearch.trailingAnchor, constant: -10).isActive = true
        btnQR.centerYAnchor.constraint(equalTo: viewSearch.centerYAnchor).isActive = true
        btnQR.addTarget(self, action: #selector(didButtonClick(_:)), for: .touchUpInside)
        
        bgField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        leadindBgField = bgField.leadingAnchor.constraint(equalTo: viewSearch.leadingAnchor,constant: 10)
        leadindBgField?.isActive = true
        bgField.trailingAnchor.constraint(equalTo: btnQR.leadingAnchor,constant: -40).isActive = true
        bgField.centerYAnchor.constraint(equalTo: viewSearch.centerYAnchor).isActive = true
        bgField.layer.cornerRadius = 5
        bgField.addSubview(iconSearch)
        bgField.addSubview(searchField)
        
        iconSearch.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconSearch.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iconSearch.centerYAnchor.constraint(equalTo: bgField.centerYAnchor).isActive = true
        iconSearch.leadingAnchor.constraint(equalTo: bgField.leadingAnchor,constant: 8).isActive = true
        
        searchField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchField.leadingAnchor.constraint(equalTo: iconSearch.trailingAnchor,constant: 8).isActive = true
        searchField.trailingAnchor.constraint(equalTo: bgField.trailingAnchor, constant: 8).isActive = true
        searchField.centerYAnchor.constraint(equalTo: bgField.centerYAnchor).isActive = true
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        styleSearchWhenKeyboarhShow()
    }
    func styleSearchWhenKeyboarhShow() {
        viewSearch.addSubview(btnGoBack)
        viewSearch.addSubview(btnSubmitSearch)
        btnSubmitSearch.isHidden = false
        btnGoBack.isHidden = false
        btnQR.isHidden = true
        
        btnGoBack.leadingAnchor.constraint(equalTo: viewSearch.leadingAnchor, constant: 8).isActive = true
        btnGoBack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnGoBack.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btnGoBack.centerYAnchor.constraint(equalTo: viewSearch.centerYAnchor).isActive = true
        btnGoBack.addTarget(self, action: #selector(onClickGoBack(_:)), for: .touchUpInside)
        leadindBgField?.constant = 50
        
        btnSubmitSearch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnSubmitSearch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnSubmitSearch.trailingAnchor.constraint(equalTo: viewSearch.trailingAnchor, constant: -10).isActive = true
        btnSubmitSearch.centerYAnchor.constraint(equalTo: viewSearch.centerYAnchor).isActive = true
        btnSubmitSearch.addTarget(self, action: #selector(onClickBtnSearch(_:)), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @objc func onClickBtnSearch(_ sender: UIButton) {
        btnSubmitSearch.blink()
        
    }
    @objc func onClickGoBack(_ sender: UIButton) {
        btnGoBack.blink()
        leadindBgField?.constant = 10
        btnQR.isHidden = false
        btnSubmitSearch.isHidden = true
        btnGoBack.isHidden = true
        view.endEditing(true)
    }
    func getIndexScroll() -> IndexPath{
        var visibleRect = CGRect()
        
        visibleRect.origin = adCollection.contentOffset
        visibleRect.size = adCollection.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = adCollection.indexPathForItem(at: visiblePoint) else { return IndexPath() }
        return indexPath
    }
}
extension UIView{
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear], animations: {self.alpha = 1.0}, completion: nil)
    }
}
extension SearchController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == barADCollection {
            let cell = barADCollection.dequeueReusableCell(withReuseIdentifier: "BarCell", for: indexPath) as! BarCell
            return cell
        } else {
            let cell = adCollection.dequeueReusableCell(withReuseIdentifier: "ADCell", for: indexPath) as! ADCell
            cell.setStyle(url: ads[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == barADCollection {
            return CGSize(width: 20, height: 20)
        } else {
            return CGSize(width: view.frame.width, height: 150)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == barADCollection {
            adCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        barADCollection.selectItem(at: getIndexScroll(), animated: true, scrollPosition: .centeredVertically)
    }
}
class ADCell : UICollectionViewCell {
    let image : UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleToFill
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setStyle(url:String) {
        addSubview(image)
        image.image = UIImage(named: url)
        image.frame = bounds
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BarCell : UICollectionViewCell {
    
    let icon : UIImageView = {
        let ic = UIImageView()
        ic.tintColor = .black
        ic.image = UIImage(systemName: "circle.fill")
        ic.translatesAutoresizingMaskIntoConstraints = false
        return ic
    }()
    override var isSelected: Bool {
        didSet {
            icon.tintColor = isSelected ? .lightGray : .black
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        icon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SearchController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableHagTag.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
        let item = tags[indexPath.row]
        cell.nameTag.text = item.name
        cell.viewTag.text = item.view
        cell.styleElement()
        cell.configCollection(item: item.element)
        return cell
    }
    
}

class TagCell : UITableViewCell {
    @IBOutlet weak var nameTag: UILabel!
    @IBOutlet weak var viewTag: UILabel!
    @IBOutlet weak var goView: UIView!
    @IBOutlet weak var videoCollec: UICollectionView!
    var elements = [String]()
    func styleElement() {
        goView.layer.cornerRadius = 3
    }
    func configCollection(item: [String]) {
        elements = item
        videoCollec.delegate = self
        videoCollec.dataSource = self
        videoCollec.register(VideoTagCell.self, forCellWithReuseIdentifier: "VTC")
        videoCollec.collectionViewLayout.invalidateLayout()
    }
}
extension TagCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2.5-2, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoCollec.dequeueReusableCell(withReuseIdentifier: "VTC", for: indexPath) as! VideoTagCell
        cell.setImage(url: elements[indexPath.row])
        return cell
    }
}

class VideoTagCell : UICollectionViewCell {
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setImage(url:String) {
        addSubview(imageView)
        imageView.image = UIImage(named: url)
        imageView.frame = bounds
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
