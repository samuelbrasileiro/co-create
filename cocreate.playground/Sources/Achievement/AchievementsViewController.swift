import Foundation
import UIKit

public class AchievementsViewController: UIViewController{
    public let returnButton = UIButton()
    public let width: CGFloat = 1024
    public let height: CGFloat = 768
    public let backDetailView = UIView()
    public let detailLabel = UILabel()
    public let detailText = UILabel()
    public let detailImage = UIImageView()
    public let sectionInsets = UIEdgeInsets(top:   100.0,   left: 30.0,
                                             bottom:100.0,   right: 30.0)
    public let itemsPerRow: CGFloat = 3
    
    let bank = AchievementBank()

}

extension AchievementsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    

    public override func loadView() {
        self.view = UIView()
        view.backgroundColor = .myLightBlue
        let orangeTab = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 106))
        orangeTab.backgroundColor = .myOrange
        orangeTab.isHidden = false
        let logoBackground = UILabel(frame: CGRect(x: 376, y: 16, width: 273, height: 77))
        logoBackground.backgroundColor = .myLightGrey
        logoBackground.layer.masksToBounds = true
        logoBackground.layer.cornerRadius = 17
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 273, height: 77))
        label.font = UIFont(name: "Gilbert Color", size: 80)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Recife"
        
        let backButton = UIButton()
        backButton.contentMode = .scaleToFill
        backButton.frame = CGRect(x: 30, y: 30, width: 54, height: 42)
        backButton.setImage(UIImage(imageLiteralResourceName: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        view.addSubview(orangeTab)
        orangeTab.addSubview(logoBackground)
        logoBackground.addSubview(label)
        orangeTab.addSubview(backButton)
        
        createCollection()
        CreateDetailView()
        
    }
    func createCollection(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        let achievementCollection = UICollectionView(frame: CGRect(x: 100, y: 106, width: self.width - 200, height: self.height - 106), collectionViewLayout: flowLayout)
        
        achievementCollection.backgroundColor = .clear
        achievementCollection.register(AchievementCollectionViewCell.self, forCellWithReuseIdentifier: "AchievementCell")

        achievementCollection.register(SupView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
        achievementCollection.bounces = false
        
        achievementCollection.delegate = self
        achievementCollection.dataSource = self
        achievementCollection.reloadData()
        
        view.addSubview(achievementCollection)
    }
    
    
    func CreateDetailView(){
        backDetailView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        backDetailView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        
        let detailView = UIView(frame: CGRect(x: 264, y: 246, width: 496, height: 360))
        detailView.layer.cornerRadius = 20
        detailView.layer.masksToBounds = true
        detailView.backgroundColor = .myLightGrey
        
        let orangeTab = UIView(frame: CGRect(x: 0, y: 0, width: detailView.frame.width, height: 53))
        orangeTab.backgroundColor = .myOrange

        
        detailLabel.frame = CGRect(x: 78, y: 5, width: 340, height: 43)
        detailLabel.font = UIFont(name: "Gilbert", size: 34)
        detailLabel.textAlignment = .center
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.text = "Conquista desbloqueada!"
        detailLabel.textColor = .myLightGrey
        let cancelButton = UIButton()
        cancelButton.contentMode = .scaleToFill
        cancelButton.frame = CGRect(x: 12, y: 16, width: 17, height: 17)
        cancelButton.setImage(UIImage(imageLiteralResourceName: "cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(closeDetail), for: .touchUpInside)
        
        detailImage.frame = CGRect(x: 195, y: 67, width: 141, height: 141)
        detailImage.contentMode = .scaleAspectFit
        
        detailText.frame = CGRect(x: 42, y: 234, width: 412, height: 108)
        detailText.font = UIFont(name: "Gilbert", size: 27)
        detailText.textAlignment = .center
        //detailText.adjustsFontSizeToFitWidth = true
        detailText.textColor = .lightGray
        detailText.numberOfLines = 3
        
        self.view.addSubview(backDetailView)
        backDetailView.addSubview(detailView)
        detailView.addSubview(orangeTab)
        orangeTab.addSubview(detailLabel)
        orangeTab.addSubview(cancelButton)
        detailView.addSubview(detailImage)
        detailView.addSubview(detailText)
        closeDetail()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let achievement = bank.getAchievement(indexPath.row)
        if achievement.isCompleted(){
            detailLabel.text = "Conquista desbloqueada!"
        }
        else{
            detailLabel.text = "Conquista bloquada."
        }
        detailText.text = achievement.getText()
        detailImage.image = achievement.getImage()
        backDetailView.isHidden = false
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bank.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: indexPath) as? AchievementCollectionViewCell else{
            fatalError("Não foi possivel instanciar uma AchievementCollectionViewCell")
        }
        let achievement = bank.getAchievement(indexPath.row)
        cell.imageView.image = achievement.getImage()
        if achievement.isCompleted(){
            
            cell.frontView.isHidden = true
        }
        else{
            cell.frontView.isHidden = false
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell", for: indexPath) as? SupView else{
                fatalError("Não foi possível gerar SupView")
            }
            header.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
            
            return header
        default:
            // 4
            assert(false, "Invalid element type")
        }
        return UICollectionReusableView()
    }
    @objc func closeDetail(){
        backDetailView.isHidden = true
    }
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    

}
