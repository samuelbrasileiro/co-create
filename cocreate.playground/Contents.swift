//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// Present the view controller in the Live View window
let cfURL = Bundle.main.url(forResource: "Gilbert-Color", withExtension: "otf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

let vc = MyViewController()

public class MyViewController : UIViewController {
    override public func loadView() {
        self.view = UIView()
        view.backgroundColor = .white
//        let line = UIView(frame: CGRect(x: 400, y: 0, width: 1, height: 600))
//        line.backgroundColor = .lightGray
//        view.addSubview(line)
        
        let orangeTab = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 88))
        orangeTab.backgroundColor = .myOrange
        
        let logoBackground = UILabel(frame: CGRect(x: 280, y: 15, width: 240, height: 60))
        logoBackground.backgroundColor = .myLightGrey
        logoBackground.layer.masksToBounds = true
        logoBackground.layer.cornerRadius = 25
        
        let label = UILabel(frame: CGRect(x: 0, y: -10, width: 240, height: 60))
        label.font = UIFont(name: "Gilbert Color", size: 80)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "co-create"
        
        
        
        view.addSubview(orangeTab)
            orangeTab.addSubview(logoBackground)
                logoBackground.addSubview(label)
    }
    
    override public func viewDidLoad(){
        
    }
}

vc.preferredContentSize = CGSize(width: 800, height: 600)



PlaygroundPage.current.liveView = vc
