//
//  FileManager.swift
//  AlarmSoundApp
//
//  Created by Nik Cane on 29.03.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import Foundation

internal class PathManager {
  public static func directory() -> URL? {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
  
  public static func namedDirectory(_ name: String, ext: String = "") -> URL? {
    let optionalPeriod = ext.isEmpty ? "" : "."
    return self.directory()?.appendingPathComponent("\(name)\(optionalPeriod)\(ext)")
  }
  
  public static func randomDirectory(ext: String = "") -> URL? {
    return self.namedDirectory(UUID().uuidString, ext: ext)
  }
  
  public static func timeBasedDirectory(ext: String = "") -> URL? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY:MM:dd-hh:mm:ss"
    let path  = dateFormatter.string(from: Date())
    return self.namedDirectory(path, ext: ext)
  }
}
