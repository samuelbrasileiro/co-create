import Foundation
import UIKit

public class MenuTableViewCell: UITableViewCell{
    public let iconView = UIImageView()
    public let titleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = UIFont(name: "Gilbert", size: 30)

        self.addSubview(iconView)
        self.addSubview(titleLabel)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
