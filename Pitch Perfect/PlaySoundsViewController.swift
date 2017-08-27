//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lester Batres on 8/26/17.
//  Copyright © 2017 Lester Batres. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    enum SoundEffect: Int {
        case slow = 0
        case fast
        case highPitch
        case lowPitch
        case echo
        case reverb
        case none
        
        init(initialValue: Int) {
            self = SoundEffect(rawValue: initialValue) ?? .none
        }
    }
    
    @IBOutlet weak var slowButton: UIButton! {
        didSet {
            preventImageToStretch(button: slowButton)
        }
    }
    
    @IBOutlet weak var fastButton: UIButton! {
        didSet {
            preventImageToStretch(button: fastButton)
        }
    }
    
    @IBOutlet weak var highPitchButton: UIButton! {
        didSet {
            preventImageToStretch(button: highPitchButton)
        }
    }
    
    @IBOutlet weak var lowPitchButton: UIButton! {
        didSet {
            preventImageToStretch(button: lowPitchButton)
        }
    }
    
    @IBOutlet weak var echoButton: UIButton! {
        didSet {
            preventImageToStretch(button: echoButton)
        }
    }
    
    @IBOutlet weak var reverbButton: UIButton! {
        didSet {
            preventImageToStretch(button: reverbButton)
        }
    }
    
    @IBOutlet weak var stopButton: UIButton!

    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var recordedAudioURL: URL!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        setupAudio()
    }
    
    // MARK: IBAction methods
    
    @IBAction func didTapPlaySoundForButton(_ sender: UIButton) {
        let soundEffect = SoundEffect(initialValue: sender.tag)
        
        switch soundEffect {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        default:
            break
        }
        
        configureUI(.playing)
    }
    
    @IBAction func didTapStopButton(_ sender: UIButton) {
        stopAudio()
    }
    
    // MARK: Private methods
    
    private func preventImageToStretch(button: UIButton) {
        button.imageView?.contentMode = .scaleAspectFit
    }
}
