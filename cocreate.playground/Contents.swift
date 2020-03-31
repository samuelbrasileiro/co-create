//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// Present the view controller in the Live View window
let vc = MyViewController()
vc.preferredContentSize = CGSize(width: 800, height: 600)
PlaygroundPage.current.liveView = vc
