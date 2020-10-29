//
//  WelcomeController.swift
//  TikTok
//
//  Created by Huy Than Duc on 10/10/20.
//

import Foundation
import UIKit
class WelcomeController: UIView {
    static let instance  = WelcomeController()
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var labelTimer: UILabel!
    var videoDelegate : AVVideo?
    var timer: Timer?
    var second = 5
    let image: UIImageView = {
        let vc = UIImageView()
        vc.image = UIImage(named: "icon")
        vc.contentMode = .scaleAspectFill
        return vc
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("WelcomeView", owner: self, options: nil)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if second%2 != 0 {
                styleTimerBlack()
            } else {
                styleTimerWhite()
            }
            labelTimer.text = "\(second)"
            if second < 0 {
                self.removeView()
                timer.invalidate()
            }
            second-=1
        }
    }
    func styleTimerBlack() {
        viewTimer.backgroundColor = .black
        labelTimer.textColor = .white
        viewTimer.layer.cornerRadius = viewTimer.frame.height / 2
        viewTimer.layer.shadowColor = UIColor.white.cgColor
        viewTimer.layer.shadowPath = UIBezierPath(rect: viewTimer.bounds).cgPath
        viewTimer.layer.shadowRadius = viewTimer.frame.height / 2
        viewTimer.layer.shadowOffset = .zero
        viewTimer.layer.shadowOpacity = 0.4
    }
    func styleTimerWhite() {
        viewTimer.layer.cornerRadius = viewTimer.frame.height / 2
        viewTimer.backgroundColor = .white
        labelTimer.textColor = .black
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showView(frame: CGRect) {
        parentView.frame = frame
        let keyWindow = UIApplication.shared.connectedScenes
                .lazy
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first { $0.isKeyWindow }
        keyWindow?.addSubview(parentView)
        second = 5
        setupIcon()
    }
    func removeView() {
        startVideo()
        parentView.removeFromSuperview()
    }
    func startVideo()  {
        videoDelegate?.startVideo()
    }
    func stopVideo() {
        videoDelegate?.stopVideo()
    }
    func setupIcon() {
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: contentView.frame.height/2.5)
        let widthConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: contentView.frame.width/0.8)
        let horizontalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        contentView.addConstraints([horizontalConstraint, verticalConstraint,widthConstraint, heightConstraint])
    }
}
