//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Elisson de Oliveira on 4/5/24.
//

import UIKit
import AVFAudio

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recording: false)
    }

    @IBAction func recordAudio(_ sender: Any) {
        print("Record button was pressed")
        configureUI(recording: true)
        
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
        print("Stop recording button was pressed")
        configureUI(recording: false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio record finished")
        if flag == false {
            print("Recording was not successful")
            return
        }
        
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(recording: Bool) {
        if recording {
            recordingLabel.text = "Recording in progress..."
            stopRecordingButton.isEnabled = recording
            stopRecordingButton.alpha = 1.0
            recordButton.isEnabled = !recording
            recordButton.alpha = 0.5
        } else {
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = !recording
            recordButton.alpha = 1.0
            stopRecordingButton.isEnabled = recording
            stopRecordingButton.alpha = 0.5
        }
    }
}
