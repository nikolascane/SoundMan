//
//  RecordSettings.swift
//  AlarmSoundApp
//
//  Created by Nik Cane on 29.03.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import AVFoundation

class RecordSettings {
  internal static func defaultSettings() -> [String: Any] {
    return [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
  }
  
  internal static func hqSettings() -> [String: Any] {
    return [
        AVFormatIDKey: Int(kAudioFormatAppleLossless),
        AVSampleRateKey: 48000,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
    ]
  }
  
  internal static func voiceSettings() -> [String: Any] {
    return [
        AVFormatIDKey: Int(kAudioFormatQUALCOMM),
        AVSampleRateKey: 8000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
    ]
  }

}
