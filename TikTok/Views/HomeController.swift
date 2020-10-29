//
//  HomeController.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/11/20.
//

import UIKit
import AVKit
import AVFoundation
protocol AVVideo {
    func startVideo()
    func stopVideo()
}
protocol CollectionViewEvent {
    func cellTaped()
}
class HomeController: UIViewController,CollectionViewEvent {
    func cellTaped() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        stopVideo()
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
  
    static let instance = HomeController()
    @IBOutlet weak var videoCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        videoCollection.delegate = self
        videoCollection.dataSource = self
        videoCollection.collectionViewLayout.invalidateLayout()
        videoCollection.isPagingEnabled = true
        WelcomeController.instance.videoDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        startVideo()
    }
    func getIndexScroll() -> IndexPath{
        var visibleRect = CGRect()
        
        visibleRect.origin = videoCollection.contentOffset
        visibleRect.size = videoCollection.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = videoCollection.indexPathForItem(at: visiblePoint) else { return IndexPath() }
        return indexPath
    }
}
extension HomeController : AVVideo {
    func stopVideo() {
        let indexPath = IndexPath()
        videoCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
    func startVideo() {
        let indexPath = getIndexScroll()
        videoCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
    
}
extension HomeController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoCollection.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! CustomVideoCell
        cell.delegate = self
        cell.setStyle()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        videoCollection.selectItem(at: getIndexScroll(), animated: true, scrollPosition: .centeredVertically)
    }
}

class CustomVideoCell: UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btnFollow: UIImageView!
    @IBOutlet weak var iconMusic: UIImageView!
    @IBOutlet weak var labelNameMusic: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var bgVideo: UIView!
    @IBOutlet weak var btnPlay: UIImageView!
    @IBOutlet weak var btnLikeVideo: UIImageView!
    @IBOutlet weak var btnChat: UIImageView!
    @IBOutlet weak var btnShare: UIImageView!
    var delegate:CollectionViewEvent?
    var textArray = [String]()
    var nameTimer: Timer?
    var pvController = AVPlayerViewController()
    var playerView = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var isPlay = true
    let chat = ChatLaucher()
    let share = ShareLaucher()
    override func awakeFromNib() {
        super.awakeFromNib()
        playBackgroundView()
        btnLikeVideo.isUserInteractionEnabled = true
        btnChat.isUserInteractionEnabled = true
        btnShare.isUserInteractionEnabled = true
        avatar.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let likeGesture = UITapGestureRecognizer(target: self, action:  #selector(self.likeVideo))
        let chatGesture = UITapGestureRecognizer(target: self, action:  #selector(self.chatSlide))
        let shareGesture = UITapGestureRecognizer(target: self, action:  #selector(self.shareSlide))
        let avatarGesture = UITapGestureRecognizer(target: self, action:  #selector(self.avatarNavigation))
        self.avatar.addGestureRecognizer(avatarGesture)
        self.bgVideo.addGestureRecognizer(gesture)
        self.btnLikeVideo.addGestureRecognizer(likeGesture)
        self.btnChat.addGestureRecognizer(chatGesture)
        self.btnShare.addGestureRecognizer(shareGesture)
    }
    @objc func avatarNavigation() {
        delegate?.cellTaped()
        
    }
    @objc func checkAction(sender : UITapGestureRecognizer) {
        if isPlay {
            btnPlay.isHidden = false
            playerView.pause()
        } else {
            btnPlay.isHidden = true
            playerView.play()
        }
        isPlay.toggle()
    }
    @objc func likeVideo(sender : UITapGestureRecognizer) {
        btnLikeVideo.tintColor = UIColor.red
    }
    @objc func chatSlide(sender : UITapGestureRecognizer) {
        chat.showView()
    }
    @objc func shareSlide(sender : UITapGestureRecognizer) {
        share.showView()
    }
    func setStyle() {
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.borderWidth = 1
        btnFollow.layer.cornerRadius = btnFollow.frame.height/2
        btnPlay.isHidden = true
        iconMusic.rotate()
        animationLabel()
    }
    override var isSelected: Bool {
        didSet {
            isSelected ? {
                playerView.play()
                btnPlay.isHidden = true
                isPlay = true
            }() : {
                playerView.pause()
                btnPlay.isHidden = false
                isPlay = false
            }()
        }
    }
    func playBackgroundView() {
        let url : URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/tiktok-4c9bd.appspot.com/o/Trend%20nha%CC%89y%20em%20la%CC%80%20bad%20girl%20trong%20bo%CC%A3%CC%82%20va%CC%81y%20nga%CC%86%CC%81n%20_%20Tik%20Tok%20Vie%CC%A3%CC%82t%20Nam.mp4?alt=media&token=76508c38-ca42-47d9-b380-39a4fe6927b3")!
        playerView = AVPlayer(url: url as URL)
        playerLayer = AVPlayerLayer(player: playerView)
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            playerLayer.frame = window.frame
        }
        playerLayer.videoGravity = .resizeAspectFill
        bgVideo.layer.addSublayer(playerLayer)
        bgVideo.bringSubviewToFront(avatar)
        bgVideo.bringSubviewToFront(btnFollow)
        bgVideo.bringSubviewToFront(iconMusic)
        bgVideo.bringSubviewToFront(labelNameMusic)
        bgVideo.bringSubviewToFront(stackView)
        bgVideo.bringSubviewToFront(iconLabel)
        bgVideo.bringSubviewToFront(btnPlay)
    }
    func animationLabel() {
        textArray = labelNameMusic.text!.components(separatedBy: " ")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if let lastElement = self.textArray.popLast() {
                self.textArray.insert(lastElement, at: 0)
                UILabel.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.labelNameMusic.text = self.textArray.joined(separator: " ")
                }, completion: nil)
            }
        }
    }
}
extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
