//
//  ZoomyImageView.swift
//  ZoomyImageView
//
//  Created by Sherif  Wagih on 12/15/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
public class ZoomableImageView: UIImageView
{
    var startingFrame:CGRect?
    lazy public var zoomingImageView:UIImageView  = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        return image
    }()
    lazy  public  var blackBGView : UIView = {
        let bg = UIView()
        bg.backgroundColor = .black
        bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        return bg
    }()
    public init()
    {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(customMessageTap)))
    }
    override public init(frame: CGRect) {
        super.init(frame:.zero)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(customMessageTap)))
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(customMessageTap)))
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc public func customMessageTap(gesture: UITapGestureRecognizer) {
        guard let image = gesture.view as? UIImageView else {return}
        startingFrame = image.superview?.convert(image.frame, to: nil)
        zoomingImageView.frame = startingFrame!
        zoomingImageView.image = image.image
        blackBGView.alpha = 0
        if let keyWindow =   UIApplication.shared.keyWindow
        {
            blackBGView.frame = keyWindow.frame
            keyWindow.addSubview(blackBGView)
            let height = startingFrame!.height / startingFrame!.width * keyWindow.frame.width
            keyWindow.addSubview(zoomingImageView)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height - 100)
                self.zoomingImageView.center = keyWindow.center
                self.blackBGView.alpha = 1
            }, completion: nil)
        }
    }
    @objc public func handleZoomOut(tapGesture:UITapGestureRecognizer)
    {
        if let zoomOutImage = tapGesture.view as? UIImageView
        {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                zoomOutImage.frame = self.startingFrame!
                self.blackBGView.alpha = 0
            }, completion: { (completed) in
                self.zoomingImageView.removeFromSuperview()
            })
        }
    }
}
