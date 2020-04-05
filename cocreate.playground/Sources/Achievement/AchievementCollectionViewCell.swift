import Foundation
import UIKit

public class AchievementCollectionViewCell: UICollectionViewCell{
    public let imageView = UIImageView()
    public let frontView = UIView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .myLightGrey
        layer.masksToBounds = true
        layer.cornerRadius = 18
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        frontView.frame = imageView.frame
        frontView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        frontView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.addSubview(frontView)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
public class SupView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.myCustomInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.myCustomInit()
    }

    func myCustomInit() {
        let label = UILabel(frame: CGRect(x: (824)/2 - 273/2, y: 20, width: 273, height: 80))
        label.font = UIFont(name: "Gilbert", size: 80)
        label.textColor = .myLightGrey
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Conquistas"
        self.addSubview(label)
    }

}
