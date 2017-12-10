//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension Storyboards {
  struct ScenePlaceholder {
    let sceneID: String
    let storyboardName: String
    let referencedIdentifier: String?
  }
}

// MARK: - XML

private enum XML {
  static let sceneIDAttribute = "id"
  static let storyboardNameAttribute = "storyboardName"
  static let referencedIdentifierAttribute = "referencedIdentifier"
}

extension Storyboards.ScenePlaceholder {
  init(with object: Kanna.XMLElement, storyboard: String) {
    sceneID = object[XML.sceneIDAttribute] ?? ""
    storyboardName = object[XML.storyboardNameAttribute] ?? storyboard
    referencedIdentifier = object[XML.referencedIdentifierAttribute]
  }
}

// MARK: - Hashable

extension Storyboards.ScenePlaceholder: Equatable { }
func == (lhs: Storyboards.ScenePlaceholder, rhs: Storyboards.ScenePlaceholder) -> Bool {
  return lhs.sceneID == rhs.sceneID
}

extension Storyboards.ScenePlaceholder: Hashable {
  var hashValue: Int {
    return sceneID.hashValue
  }
}
