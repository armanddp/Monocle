//
//  ViewController.swift
//  Sample
//
//  Created by Sachin Patel on 1/25/17.
//  Copyright © 2017 Sachin Patel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	let monocleNonExpandedScale: CGFloat = 0.3
	
	var monocle: Monocle
	var monocleExpanded: Bool {
		didSet {
			UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
				let scale: CGFloat = self.monocleExpanded ? 1 : self.monocleNonExpandedScale
				self.monocle.transform = CGAffineTransform(scaleX: scale, y: scale)
			}, completion: nil)
			
			setNeedsStatusBarAppearanceUpdate()
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return monocleExpanded
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		monocle = Monocle()
		monocleExpanded = false
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Add a basic header label
		let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 30.0, weight: UIFont.Weight.medium)
		headerLabel.text = "Monocle"
		headerLabel.textAlignment = .center
		headerLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.3)
		view.addSubview(headerLabel)
		
		// Add a description
		let subLabel = UILabel()
        subLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
		subLabel.text = "Tap the video and rotate your phone."
		subLabel.textAlignment = .center
		subLabel.frame = CGRect(x: 0, y: view.bounds.height - view.bounds.height * 0.3, width: view.bounds.width, height: view.bounds.height * 0.3)
		view.addSubview(subLabel)
		
		// Get the sample video from the main bundle
		guard let path = Bundle.main.path(forResource: "sample", ofType: "mp4") else {
			fatalError("Sample video not found in main bundle.")
		}
		
		// Create an AVPlayer and subscribe to the `AVPlayerItemDidPlayToEndTime`
		// notification so that we can loop the video automatically when it ends.
		let item = AVPlayerItem(url: URL(fileURLWithPath: path))
		let player = AVPlayer(playerItem: item)
		player.actionAtItemEnd = .none
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerItemDidReachEnd(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: item)
		monocle.player = player
		player.play()
		
		// Add a tap gesture to toggle expanding and shrinking the circular view
		let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleMonocleSize))
		monocle.addGestureRecognizer(tap)
		
		// Add the monocle view and position it
		view.addSubview(monocle)
		monocle.bounds = view.bounds
		monocle.center = view.center
		monocle.transform = CGAffineTransform(scaleX: monocleNonExpandedScale, y: monocleNonExpandedScale)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    @objc func toggleMonocleSize() {
		monocleExpanded = !monocleExpanded
	}
	
    @objc func playerItemDidReachEnd(notification: Notification) {
		guard let playerItem = notification.object as? AVPlayerItem else { return }
        playerItem.seek(to: CMTime.zero)
	}
}
