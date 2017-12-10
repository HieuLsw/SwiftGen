//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension Storyboards {
  struct Storyboard {
    let name: String
    let platform: Platform
    let initialScene: Scene?
    let scenes: Set<Scene>
    let segues: Set<Segue>
    let placeholders: Set<ScenePlaceholder>

    var modules: Set<String> {
      var result: [String] = scenes.compactMap { $0.module } +
        segues.compactMap { $0.module }

      if let module = initialScene?.module {
        result += [module]
      }

      return Set(result)
    }
  }
}

// MARK: - XML

private enum XML {
  static let initialVCXPath = "/*/@initialViewController"
  static let targetRuntimeXPath = "/*/@targetRuntime"

  static func initialSceneXPath(identifier: String) -> String {
    return "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and @id=\"\(identifier)\"]"
  }
  static let sceneXPath = "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\"]"
  static let segueXPath = "/document/scenes/scene//connections/segue[string(@identifier)]"

  static let placeholderTags = ["controllerPlaceholder", "viewControllerPlaceholder"]
}

extension Storyboards.Storyboard {
  init(with document: Kanna.XMLDocument, name: String) throws {
    self.name = name

    // TargetRuntime
    let targetRuntime = document.at_xpath(XML.targetRuntimeXPath)?.text ?? ""
    guard let platform = Storyboards.Platform(rawValue: targetRuntime) else {
      throw Storyboards.ParserError.unsupportedTargetRuntime(target: targetRuntime)
    }
    self.platform = platform

    // Initial VC
    let initialSceneID = document.at_xpath(XML.initialVCXPath)?.text ?? ""
    if let object = document.at_xpath(XML.initialSceneXPath(identifier: initialSceneID)) {
      initialScene = Storyboards.Scene(with: object, platform: platform)
    } else {
      initialScene = nil
    }

    // Scenes
    var scenes = Set<Storyboards.Scene>()
    var placeholders = Set<Storyboards.ScenePlaceholder>()
    for node in document.xpath(XML.sceneXPath) {
      if XML.placeholderTags.contains(node.tagName ?? "") {
        placeholders.insert(Storyboards.ScenePlaceholder(with: node, storyboard: name))
      } else {
        scenes.insert(Storyboards.Scene(with: node, platform: platform))
      }
    }
    self.scenes = scenes
    self.placeholders = placeholders

    // Segues
    segues = Set<Storyboards.Segue>(document.xpath(XML.segueXPath).map {
      Storyboards.Segue(with: $0, platform: platform)
    })
  }
}
