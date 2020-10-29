//
//  ProfileController.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/25/20.
//

import UIKit
import AVKit
import AVFoundation

struct VideoProfile {
    var video : String
    var view : String
}

class ProfileController: UIViewController {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btnMess: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnSocial: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var navigationCollection: UICollectionView!
    @IBOutlet weak var videoCollection: UICollectionView!
    let share = ShareLaucher()
    let navi = ["list.bullet.indent","heart.slash"]
    let blackView = UIView()
    var more = false
    let videos : [VideoProfile] =  [
        VideoProfile(video: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/%5E%5E%20Tik%20Tok%20Sie%CC%82u%20Nga%CC%86%CC%81n%20%2315%20%5E%5E%20%E0%B4%A0%E0%B4%A7%E0%B4%A0.mp4?alt=media&token=769961b3-41fe-4b9b-bf6e-06eb54f0b2cc", view: "30K"),
        VideoProfile(video: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/%5E%5E%20Tik%20Tok%20Sie%CC%82u%20Nga%CC%86%CC%81n%20%2315%20%5E%5E%20%E0%B4%A0%E0%B4%A7%E0%B4%A0.mp4?alt=media&token=769961b3-41fe-4b9b-bf6e-06eb54f0b2cc", view: "20K"),
        VideoProfile(video: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/%5E%5E%20Tik%20Tok%20Sie%CC%82u%20Nga%CC%86%CC%81n%20%2315%20%5E%5E%20%E0%B4%A0%E0%B4%A7%E0%B4%A0.mp4?alt=media&token=769961b3-41fe-4b9b-bf6e-06eb54f0b2cc", view: "10K"),
        VideoProfile(video: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/%5E%5E%20Tik%20Tok%20Sie%CC%82u%20Nga%CC%86%CC%81n%20%2315%20%5E%5E%20%E0%B4%A0%E0%B4%A7%E0%B4%A0.mp4?alt=media&token=769961b3-41fe-4b9b-bf6e-06eb54f0b2cc", view: "5K"),
        VideoProfile(video: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/%5E%5E%20Tik%20Tok%20Sie%CC%82u%20Nga%CC%86%CC%81n%20%2315%20%5E%5E%20%E0%B4%A0%E0%B4%A7%E0%B4%A0.mp4?alt=media&token=769961b3-41fe-4b9b-bf6e-06eb54f0b2cc", view: "3K"),
        VideoProfile(video: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/%5E%5E%20Tik%20Tok%20Sie%CC%82u%20Nga%CC%86%CC%81n%20%2315%20%5E%5E%20%E0%B4%A0%E0%B4%A7%E0%B4%A0.mp4?alt=media&token=769961b3-41fe-4b9b-bf6e-06eb54f0b2cc", view: "2K"),
        VideoProfile(video: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/%5E%5E%20Tik%20Tok%20Sie%CC%82u%20Nga%CC%86%CC%81n%20%2315%20%5E%5E%20%E0%B4%A0%E0%B4%A7%E0%B4%A0.mp4?alt=media&token=769961b3-41fe-4b9b-bf6e-06eb54f0b2cc", view: "1K")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Đức Huy";
        let share = UIBarButtonItem(image:UIImage(systemName: "list.bullet.rectangle"), style: .plain, target: self, action: #selector(shareTapped))
        share.tintColor = .black
        self.navigationItem.rightBarButtonItem  = share
        let back = UIBarButtonItem(image:UIImage(systemName: "arrowshape.turn.up.backward.2"), style: .plain, target: self, action: #selector(backTapped))
        back.tintColor = .black
        self.navigationItem.leftBarButtonItem  = back
        styleElement()
        configNavigation()
        configVideos()
        btnMore.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
    }
    @objc func moreTapped() {
        btnMore.setImage(UIImage(systemName: more ? "arrowtriangle.down.fill":"arrowtriangle.up.fill"), for: .normal)
        more.toggle()
    }
    func configVideos() {
        videoCollection.delegate = self
        videoCollection.dataSource = self
        videoCollection.register(VideoProfileCell.self, forCellWithReuseIdentifier: "VideoCell")
        videoCollection.collectionViewLayout.invalidateLayout()
    }
    func configNavigation() {
        navigationCollection.delegate = self
        navigationCollection.dataSource = self
        navigationCollection.register(NavigationCell.self, forCellWithReuseIdentifier: "NaviCell")
        navigationCollection.collectionViewLayout.invalidateLayout()
        
        navigationCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        view.addSubview(blackView)
        blackView.backgroundColor = .black
        blackView.frame = CGRect(x: view.frame.width/4-20, y: navigationCollection.frame.origin.y+40, width: 50, height: 3)
        navigationCollection.addTopBorder(with: UIColor.opaqueSeparator, andWidth: 1)
    }
    @objc func shareTapped() {
        share.showView()
    }
    @objc func backTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func styleElement() {
        avatar.layer.cornerRadius = avatar.frame.height/2
        btnMess.borderGray()
        btnUser.borderGray()
        btnSocial.borderGray()
        btnMore.borderGray()
    }
}
extension UIButton {
    func borderGray() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
    }
}
class NavigationCell : UICollectionViewCell {
    let icon : UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.tintColor = .lightGray
        return im
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override var isSelected: Bool {
        didSet {
            icon.tintColor =  isSelected ? .black : .lightGray
        }
    }
    func setStyle(img:String) {
        addSubview(icon)
        icon.image = UIImage(systemName: img)
        icon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ProfileController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == navigationCollection {
            return navi.count
        } else {
            return videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == navigationCollection {
            let cell = navigationCollection.dequeueReusableCell(withReuseIdentifier: "NaviCell", for: indexPath) as! NavigationCell
            cell.setStyle(img: navi[indexPath.row])
            return cell
        } else {
            let cell = videoCollection.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoProfileCell
            cell.getVideoThumbnail(item: videos[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == navigationCollection {
            return CGSize(width: view.frame.width/2, height: 40)
        } else {
            return CGSize(width: view.frame.width/3 - 1, height: 120)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.frame = CGRect(x: ( CGFloat(indexPath.row + (indexPath.row == 0 ? 1:2)) + (indexPath.row == 0 ? -0.05:0.05) ) * (self.view.frame.width/4)-20, y: self.navigationCollection.frame.origin.y+45, width: 50, height: 3)
        }, completion: nil)
    }
}
class VideoProfileCell : UICollectionViewCell {
    let iconPlay : UIImageView = {
        let ip = UIImageView()
        ip.image = UIImage(systemName: "play")
        ip.tintColor = .white
        ip.translatesAutoresizingMaskIntoConstraints = false
        return ip
    }()
    let bg : UIImageView = {
        let ip = UIImageView()
        ip.image = UIImage(systemName: "play.fill")
        ip.contentMode = .scaleToFill
        ip.translatesAutoresizingMaskIntoConstraints = false
        return ip
    }()
    let label : UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    var url : URL? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bg)
        bg.frame = bounds
    }
    func addBTN() {
        bg.addSubview(iconPlay)
        iconPlay.frame = CGRect(x: 10, y: 100, width: 15, height: 15)
        bg.bringSubviewToFront(iconPlay)
    }
    func addLabel() {
        bg.addSubview(label)
        label.frame = CGRect(x: 30, y: 88, width: 40, height: 40)
        label.bringSubviewToFront(iconPlay)
    }
    func getVideoThumbnail(item: VideoProfile) {
        url = URL(string: item.video)
        addLabel()
        label.text = item.view
        getThumbnail(url: url!) { (image,time) in
            self.bg.image = image
            self.addBTN()
        }
    }
    func getThumbnail(url:URL,completion: @escaping ((_ image: UIImage,_ time: Double)->Void) )  {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImage = AVAssetImageGenerator(asset: asset)
            let durationInSeconds = asset.duration.seconds
            avAssetImage.appliesPreferredTrackTransform = true
            let thumbnailVideo = CMTimeMake(value: 7, timescale: 1)
            do {
                let cgImage = try avAssetImage.copyCGImage(at: thumbnailVideo, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.sync {
                    completion(image,durationInSeconds)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
