//
//  SoundManager.swift
//  AlarmSoundApp
//
//  Created by Nik Cane on 29.03.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit
import AVFoundation

public enum SoundError: Swift.Error, CustomStringConvertible {
  case fileNameIsEmpty
  case wrongFileName
  case pathIsNotDefined
  case unknown
  
  public var description: String {
    switch self {
    case .fileNameIsEmpty:
      return "File Name Is Empty"
    case .pathIsNotDefined:
      return "Path Is Not Defined"
    case .wrongFileName:
      return "Wrong File Name"
    case .unknown:
      return "The unknown error has occured"
    }
  }
}

public protocol SoundManagerDelegate: class {
  func audioRecorderEncodeError(error: Error?)
  func audioRecorderDidFinishRecording(successfully: Bool)
  func audioPlayerDecodeError(error: Error?)
  func audioPlayerDidFinishPlaying(successfully: Bool)
}

final public class SoundManager: NSObject {
  
  private var player: AudioPlayer?
  private var recorder: AudioRecorder?
  public weak var delegate: SoundManagerDelegate?
  
  public func configureAudioSession() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
    }
    catch let error {
      print("Can't set: \(error)")
    }
  }
}

//MARK: Player
extension SoundManager {
  public func play(url: URL, playbackOptions: PlaybackOptions) {
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    }
    catch let error {
      print("Can't activate Audio session \(error)")
    }
    self.player = AudioPlayer(url: url, playbackOptions: playbackOptions, delegate: self)
    self.player?.play()
  }
  
  public func pausePlaying() {
    self.player?.pause()
  }
  
  public func resumePlaying() {
    self.player?.resume()
  }
  
  public func pauseRecording() {
    self.recorder?.recorder?.pause()
  }
  
  public func stop() {
    do {
      try AVAudioSession.sharedInstance().setActive(false)
    }
    catch let error {
      print("Can't stop audio session:\(error)")
    }
  }
}

//MARK: Recorder
//MARK: Public methods
extension SoundManager {
  
  public func record(name: String, quality: RecordQiality = .byDefault, duration: TimeInterval = 60) throws {
    guard !name.isEmpty else {
      throw(SoundError.fileNameIsEmpty)
    }
    let fileName = try self.decompose(name: name)
    try self.record(options: .using(name: fileName.name, ext: fileName.ext), quality: quality, duration: duration)
  }
  
  public func record(to url: URL?, quality: RecordQiality = .byDefault, duration: TimeInterval = 60) throws {
    try self.startRecord(url: url, quality: quality, duration: duration)
  }
  
  public func record(options: RecordOptions, quality: RecordQiality = .byDefault, duration: TimeInterval = 60) throws {
    switch options {
    case .using(name: let name, ext: let ext):
      try startRecordUsing(name: name, ext: ext, quality: quality, duration: duration)
    case .randomFile:
      try self.startRandomRecord(quality: quality, duration: duration)
    case .timeBased:
      try self.startTimeBasedRecord(quality: quality, duration: duration)
    }
  }
}

//MARK: Private methods
extension SoundManager {
  
  private func decompose(name: String) throws -> (name: String, ext: String) {
    guard name.contains(".") else {
      throw(SoundError.wrongFileName)
    }
    let nameComponents = name.components(separatedBy: ".")
    guard nameComponents.count == 2 else {
      throw(SoundError.wrongFileName)
    }
    if let name = nameComponents.first, let ext = nameComponents.last {
      return (name: name, ext: ext)
    }
    throw(SoundError.wrongFileName)
  }
  
  private func startRecordUsing(name: String, ext: String, quality: RecordQiality, duration: TimeInterval) throws {
    let url = PathManager.namedDirectory(name, ext: ext)
    try self.startRecord(url: url, quality: quality, duration: duration)
  }
  
  private func startRandomRecord(quality: RecordQiality, duration: TimeInterval) throws {
    let url = PathManager.randomDirectory()?.appendingPathExtension(quality.fileExtension)
    try self.startRecord(url: url, quality: quality, duration: duration)
  }
  
  private func startTimeBasedRecord(quality: RecordQiality, duration: TimeInterval) throws {
    let url = PathManager.timeBasedDirectory()?.appendingPathExtension(quality.fileExtension)
    try self.startRecord(url: url, quality: quality, duration: duration)
  }
  
  private func startRecord(url: URL?, quality: RecordQiality, duration: TimeInterval) throws {
    guard let url = url else {
      throw(SoundError.pathIsNotDefined)
    }
    
    self.recorder = AudioRecorder(url: url, settings: self.recordSettings(quality: quality), delegate: self)
    try self.recorder?.record(atTime: 0, forDuration: 30)
  }

  private func recordSettings(quality: RecordQiality) -> [String: Any] {
    switch quality {
    case .voice:
      return RecordSettings.voiceSettings()
    case .byDefault:
      return RecordSettings.defaultSettings()
    case .highQuality:
      return RecordSettings.hqSettings()
    }
  }
}

extension SoundManager: AVAudioRecorderDelegate {
  public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    self.delegate?.audioRecorderEncodeError(error: error)
    print("Encode error: \(error.debugDescription)")
  }
  
  public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    self.delegate?.audioRecorderDidFinishRecording(successfully: flag)
    print("Record finished")
  }
}

extension SoundManager: AVAudioPlayerDelegate {
  public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    self.delegate?.audioPlayerDecodeError(error: error)
    print("Decode error: \(error.debugDescription)")
  }
  
  public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.delegate?.audioPlayerDidFinishPlaying(successfully: flag)
    print("Playback finished")
  }
}


