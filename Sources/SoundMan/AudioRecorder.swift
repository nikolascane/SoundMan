//
//  AudioRecorder.swift
//  AlarmSoundApp
//
//  Created by Nik Cane on 29.03.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit
import AVFoundation

public enum RecordOptions {
  case using(name: String, ext: String)
  case randomFile
  case timeBased
}

public enum RecordQiality {
  case voice
  case byDefault
  case highQuality
  
  var fileExtension: String {
    switch self {
    case .voice:
      return "Qclp"
    case .byDefault:
      return "m4a"
    case .highQuality:
      return "alac"
    }
  }
}

final internal class AudioRecorder: NSObject {
  var recorder: AVAudioRecorder?
  private var recording: Bool = false
  
  internal init(url: URL, settings: [String: Any], delegate: AVAudioRecorderDelegate) {
    do {
      if let format = AVAudioFormat.init(settings: settings) {
        self.recorder = try AVAudioRecorder(url: url, format: format)
      }
    }catch let error {
      print("Can't create recoder: \(error)")
    }
    super.init()
    self.recorder?.delegate = delegate
  }
  
  internal func record(atTime: TimeInterval, forDuration: TimeInterval) throws {
    try AVAudioSession.sharedInstance().setActive(true)
    self.resume(atTime: atTime, forDuration: forDuration)
  }
  
  internal func resume(atTime: TimeInterval, forDuration: TimeInterval) {
    if self.recording {
      self.recorder?.record()
      return
    }
    if self.recorder?.prepareToRecord() == true {
      self.recording = true
      self.recorder?.record(atTime: atTime, forDuration: forDuration)
    }
  }
  
  internal func pause() {
    self.recorder?.pause()
  }
  
  internal func stop() {
    self.recording = false
    self.recorder?.stop()
  }
}
