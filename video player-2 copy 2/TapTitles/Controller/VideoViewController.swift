//
//  ViewController.swift
//  video player
//
//  Created by Gabriele Volpe on 04/06/2019.
//  Copyright © 2019 Gabriele Volpe. All rights reserved.
//

import UIKit
import AVFoundation

/// A simple `UIView` subclass that is backed by an `AVPlayerLayer` layer.
class VideoPlayerView: UIView {
  var player: AVPlayer? {
    get {
      return playerLayer?.player
    }
    
    set {
      playerLayer?.player = newValue
    }
  }
  
  var playerLayer: AVPlayerLayer? {
    return layer as? AVPlayerLayer
  }
  
  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
}

class VideoViewController: UIViewController {
  var videoName = ""
  var videoPath = ""
  var timer = Timer()
  var subtitles = ""
  var subtitleLabel = ""
  var tempLabel = ""
  
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var otherLabel: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var videoView: VideoPlayerView!
  
  @IBAction func pausePlay(_ sender: Any) {
    if videoView.player?.rate == 0.0 {
      videoView.player?.play()
      pauseButton.setTitle("I I", for: .normal)
     } else {
      videoView.player?.pause()
      pauseButton.setTitle(">", for: .normal)
    }
  }
  
  @IBAction func clickSubtitle(_ sender: Any) {
    if videoView.player?.rate == 0.0 {
      videoView.player?.play()
    } else {
      let start = Double(subs[actualLang]?.times[lastFound].0 ?? 0)
      videoView.player?.seek(to: CMTime(seconds: start, preferredTimescale: (videoView.player?.currentTime().timescale)!))
      videoView.player?.play()
      otherLabel.isHidden = false
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: checkSubtitle)
    
    subtitles = readSubtitle(name: videoName, language: "en")
    subtitles = readSubtitle(name: videoName, language: "it")
    actualLang = "en"
    subtitle.text = ""
    otherLabel.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let path = Bundle.main.path(forResource: videoName, ofType: "mp4")
    {
      //player = AVPlayer(url: URL(fileURLWithPath: videoPath))
      videoView.player = AVPlayer(url: URL(fileURLWithPath: path))
      videoView.player!.play()
    }
    pauseButton.layer.cornerRadius = 8
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    videoView.player?.pause()
    timer.invalidate()
    videoView.playerLayer?.player = nil
  }
  
  func checkSubtitle(_: Timer) -> Void {
    guard let actualCT = videoView.player?.currentTime() else { return }  // Controlla il timecode della riproduzione in corso
    if actualCT.value > 0 {
      let tempo = Int(Double(actualCT.value)/Double(actualCT.timescale))
      subtitle.text = searchSubtitle(time: tempo, lang: actualLang)
      let tempOtherLabel = searchSubtitle(time: tempo, lang: otherLang)
      if tempLabel == subtitle.text {
        otherLabel.text = tempOtherLabel
      } else {
        otherLabel.isHidden = true
      }
      tempLabel = subtitle.text ?? ""
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

