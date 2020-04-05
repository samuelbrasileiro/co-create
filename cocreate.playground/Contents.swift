//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import MapKit
import CoreLocation
import XCPlayground
// Present the view controller in the Live View window
var cfURL = Bundle.main.url(forResource: "Gilbert-Color", withExtension: "otf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
cfURL = Bundle.main.url(forResource: "Gilbert-Bold", withExtension: "otf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

let bank = AchievementBank()


class AchievementCollectionViewCell: UICollectionViewCell{
    let imageView = UIImageView()
    let frontView = UIView()
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
class SupView: UICollectionReusableView {

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

extension AchievementsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        backButton.setImage(UIImage(imageLiteralResourceName: "back.png"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        let achievementCollection = UICollectionView(frame: CGRect(x: 100, y: 106, width: self.width - 200, height: self.height - 106), collectionViewLayout: flowLayout)
        
        achievementCollection.backgroundColor = .clear
        achievementCollection.register(AchievementCollectionViewCell.self, forCellWithReuseIdentifier: "AchievementCell")

        achievementCollection.register(SupView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        achievementCollection.delegate = self
        achievementCollection.dataSource = self
        achievementCollection.reloadData()
        view.addSubview(orangeTab)
        orangeTab.addSubview(logoBackground)
        logoBackground.addSubview(label)
        orangeTab.addSubview(backButton)
        view.addSubview(achievementCollection)
        
        
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
    }
    
    @objc func goBack(){
        
        navigationController?.popViewController(animated: true)

    }
    

}

let vc = MapViewController(screenType: .ipad, isPortrait: false)

//vc.preferredContentSize = CGSize(width: 800, height: 600)
let navigation = UINavigationController(screenType: .ipad, isPortrait: false)
navigation.pushViewController(vc, animated: false)
navigation.navigationBar.isHidden = true
PlaygroundPage.current.needsIndefiniteExecution = true // Sets up the constant running of the playground so that the location can update properly

PlaygroundPage.current.liveView = navigation.scale(to: 0.75)
