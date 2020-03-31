import Foundation
import UIKit
import MapKit
//import PlaygroundSuport

public class MyViewController : UIViewController {
    override public func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        
        
    }
    
    override public func viewDidLoad(){
        
    }
}
