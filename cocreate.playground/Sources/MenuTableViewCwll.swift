import Foundation
import UIKit

public class MenuTableViewCell: UITableViewCell{
    let iconView = UIImageView()
    let titleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconView.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = iconView.frame.width/2
        titleLabel.frame = CGRect(x: 60, y: 10, width: 180, height: 40)
        titleLabel.font = UIFont(name: "Gilbert Bold", size: 30)
        self.addSubview(iconView)
        self.addSubview(titleLabel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
