//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension Storyboards {
  struct Segue {
    let identifier: String
    let kind: String
    let customClass: String?
    let customModule: String?
    let destination: String
    let platform: Platform

    var type: String {
      if let customClass = customClass {
        return customClass
      } else {
        return "\(platform.prefix)StoryboardSegue"
      }
    }

    var module: String? {
      if let customModule = customModule {
        return customModule
      } else if customClass == nil {
        return platform.module
      } else {
        return nil
      }
    }
  }
}

// MARK: - XML

private enum XML {
  static let identifierAttribute = "identifier"
  static let kindAttribute = "kind"
  static let customClassAttribute = "customClass"
  static let customModuleAttribute = "customModule"
  static let destinationAttribute = "destination"
}

extension Storyboards.Segue {
  init(with object: Kanna.XMLElement, platform: Storyboards.Platform) {
    identifier = object[XML.identifierAttribute] ?? ""
    kind = object[XML.kindAttribute] ?? ""
    customClass = object[XML.customClassAttribute]
    customModule = object[XML.customModuleAttribute]
    destination = object[XML.destinationAttribute] ?? ""
    self.platform = platform
  }
}

// MARK: - Hashable

extension Storyboards.Segue: Equatable { }
func == (lhs: Storyboards.Segue, rhs: Storyboards.Segue) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule
}

extension Storyboards.Segue: Hashable {
  var hashValue: Int {
    return identifier.hashValue ^ (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
  }
}
