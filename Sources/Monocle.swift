//
//  Monocle.swift
//  Spectacles
//
//  Created by Sachin on 1/2/17.
//  Copyright © 2017 Sachin Patel. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class Monocle: UIView {
	/// The current video player.
	public var player: AVPlayer? {
		didSet {
			assert(player != nil, "Please provide a non-nil value for player.")
			oldValue?.pause()
			playerView.playerLayer.player = player
		}
	}
	
	public var shouldAutorotate = true {
		didSet {
			updateMotionEvents()
		}
	}

	/// The device motion manager.
	fileprivate let manager: CMMotionManager = CMMotionManager()
	
	/// The internal video player view.
	fileprivate var playerView: CircularPlayerView = CircularPlayerView()
	
	/// The constraint representing the height of the `playerView`.
	fileprivate var playerHeightConstraint: NSLayoutConstraint?
	
	/// The current diameter of the circular player view.
	fileprivate var playerEdgeLength: CGFloat {
		return sqrt(pow(bounds.height, 2) + pow(bounds.width, 2))
	}
	
	// MARK: - Initializers
	convenience init(player aPlayer: AVPlayer) {
		self.init(frame: CGRect.zero)
		player = aPlayer
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		clipsToBounds = false
		
		addSubview(playerView)
		playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		
		playerHeightConstraint = playerView.heightAnchor.constraint(equalToConstant: playerEdgeLength)
		playerHeightConstraint?.isActive = true
		playerView.widthAnchor.constraint(equalTo: playerView.heightAnchor).isActive = true
		playerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		playerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		playerView.translatesAutoresizingMaskIntoConstraints = false
		
		updateMotionEvents()
	}
	
	/// Sets up motion events so we can rotate the video appropriately.
	fileprivate func updateMotionEvents() {
		// Check if motion is available on this device. If not, fail silently.
		guard manager.isDeviceMotionAvailable else {
			print("Motion is not available on this device. :(")
			return
		}
		guard shouldAutorotate else {
			if manager.isDeviceMotionActive {
				playerView.transform = CGAffineTransform.identity
				manager.stopDeviceMotionUpdates()
			}
			return
		}
		
		manager.deviceMotionUpdateInterval = 0.01
		manager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (data, error) in
			guard let gravity = data?.gravity else { return }
			
			// Set the transform
			let rotation = atan2(gravity.x, gravity.y) - M_PI
			self?.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerHeightConstraint?.constant = playerEdgeLength
	}
}

// MARK: - Circular Player
fileprivate class CircularPlayerView: UIView {
	fileprivate let playerLayer = AVPlayerLayer()
	
	deinit {
		removeObserver(self, forKeyPath: "bounds")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		layer.addSublayer(playerLayer)
		addObserver(self, forKeyPath: "bounds", options: [], context: nil)
	}
	
	fileprivate override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let path = keyPath, object is CircularPlayerView, path == "bounds" else { return }
		
		// Set the frame of the player layer so that the circular part of the Spectacles video fills the view frame
		let insetPercent = CGFloat(0.026)
		let playerWidth = (1 / (1 - insetPercent * 2)) * bounds.width
		let playerInset = (bounds.width - playerWidth) / 2
		let playerFrame = CGRect(x: playerInset, y: playerInset, width: playerWidth, height: playerWidth)
		playerLayer.frame = playerFrame
		
		// Mask the view layer to a circle
		let circleMask = CAShapeLayer()
		circleMask.path = UIBezierPath(ovalIn: bounds).cgPath
		layer.mask = circleMask
	}
}
