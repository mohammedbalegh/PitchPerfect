//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by mohammed balegh on 4/11/20.
//  Copyright © 2020 mohammed balegh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingState(label: "Recording in progress", stopButton: true, startButton: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingState(label: "Recording finished", stopButton: false, startButton: true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
    }
    
    func recordingState(label: String,stopButton: Bool,startButton: Bool){
        recordingLabel.text = label
        recordButton.isEnabled = startButton
        stopRecordingButton.isEnabled = stopButton
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
    }
    
    func  audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) }
        else {
            
            let alert = UIAlertController(title: "Error", message: "Unexpected error occurred", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: {_ in self.recordingState(label: "Tap to button", stopButton: false, startButton: true)}))
            
            self.present(alert, animated: true, completion:
                nil)
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as!  URL
            playSoundVC.recordedAudioURL  = recordedAudioURL
        }
        
    }
    
}

