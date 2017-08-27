//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lester Batres on 8/22/17.
//  Copyright © 2017 Lester Batres. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    struct Alerts {
        static let recordingFailedMessage = "Something went wrong with your recording."
    }
    
    enum RecordState {
        case recording
        case notRecording
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    private let audioSession = AVAudioSession.sharedInstance()
    private let recordText = "Tap to Record"
    private let recordInProgressText = "Recording in progress"
    
    fileprivate let stopRecordingSegueIdentifier = "stopRecording"
    
    fileprivate var audioRecorder: AVAudioRecorder!

    override func viewWillAppear(_ animated: Bool) {
        configureUI(recordingState: .notRecording)
    }
    
    
    // MARK: Action methods
    
    @IBAction func didTapRecordButton(_ sender: UIButton) {
        configureUI(recordingState: .recording)
        recordAudio()
    }
    
    @IBAction func didTapStopButton(_ sender: UIButton) {
        configureUI(recordingState: .notRecording)
        stopRecordingAudio()
    }
    
    
    // MARK: Prepare for segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == stopRecordingSegueIdentifier {
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            
            playSoundsViewController.recordedAudioURL = recordedAudioURL
        }
    }
    
    
    // MARK: Private methods
    
    private func configureUI(recordingState: RecordState) {
        switch recordingState {
        case .recording:
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            messageLabel.text = recordInProgressText
        case .notRecording:
            recordButton.isEnabled = true
            stopButton.isEnabled = false
            messageLabel.text = recordText
        }
    }
    
    private func recordAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord,
                                      with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    private func stopRecordingAudio() {
        audioRecorder.stop()
        try! audioSession.setActive(false)
    }
}


// MARK: AVAudioRecorderDelegate methods

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: stopRecordingSegueIdentifier, sender: audioRecorder.url)
        } else {
            showAlert(withMessage: Alerts.recordingFailedMessage)
        }
    }
    
    
    // MARK: Private methods
    
    private func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

