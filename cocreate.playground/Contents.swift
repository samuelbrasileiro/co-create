//: A UIKit based Playground for presenting user interface
//TODO:- Criar classe de locais e de atividades. além disso, terminar a criação da table view de menu E LUGAR ONDE BOTAR ONDE MORA
import UIKit
import PlaygroundSupport
import MapKit
import CoreLocation
import XCPlayground

var cfURL = Bundle.main.url(forResource: "Gilbert-Color", withExtension: "otf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
cfURL = Bundle.main.url(forResource: "Gilbert-Bold", withExtension: "otf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

let bank = AchievementBank()

public class City{
    private var ctName: String
    public var name: String{
        return ctName
    }
    public var coordinates: CLLocationCoordinate2D
    
    private var ctRegion: MKCoordinateRegion
    public var region: MKCoordinateRegion{
        return ctRegion
    }
    
    private var ctStartPoint:CLLocationCoordinate2D
    public var startPoint: CLLocationCoordinate2D{
        return ctStartPoint
    }
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.ctName = name
        self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        ctRegion = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        ctStartPoint = coordinates
    }
    public func setMapSize(latitudeInMeters: Double, longitudeInMeters: Double){
        ctRegion = MKCoordinateRegion(
        center: coordinates, latitudinalMeters: latitudeInMeters, longitudinalMeters: longitudeInMeters)
    }
    public func setStartPoint(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        ctStartPoint = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    public func getBoundary()->MKMapView.CameraBoundary{
        return MKMapView.CameraBoundary(coordinateRegion: region)!
    }
    
    public func withCoordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> City{
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return self
    }
}

public class Activity{
    public var name: String
    public var image: UIImage
    public var description: String = ""
    public var address: City
    init(name: String, address: City, imageName: String){
        self.name = name
        self.address = address
        self.image = UIImage(imageLiteralResourceName: imageName)
    }
    func addDescription(description: String){
        self.description = description
    }
    
}

class Local{
    var name: String
    var image: UIImage
    var activities: [Activity] = []
    var description: String = ""
    init(name: String, imageName: String){
        self.name = name
        self.image = UIImage(imageLiteralResourceName: imageName)
        
    }
    func addDescription(description: String){
        self.description = description
    }
    func addActivity(activity: Activity){
        self.activities.append(activity)
    }
}

extension City{
    static var recife: City{
        get{
            let city = City(name: "Recife", latitude: -8.0522, longitude: -34.9286)
            city.setMapSize(latitudeInMeters: 22000, longitudeInMeters: 22000)
            city.setStartPoint(latitude: -8.062169, longitude: -34.877139)
            return city
        }
    }
    static var rioDeJaneiro: City{
        get{
            let city = City(name: "Rio de Janeiro", latitude: 22.9068, longitude: 43.1729)
            return city
        }
    }
    static var salvador: City{
        get{
            let city = City(name: "Salvador", latitude: 12.9777, longitude: 38.5016)
            return city
        }
    }

}

class localsBank{
    var locals: [Local] = []
    init(){
        var local = Local(name: "Fatinha", imageName: "fatinha")
        local.addActivity(activity: Activity(name: "Bolo de rolo artesanal", address: City.recife.withCoordinate(latitude: -8.0561369, longitude: -34.877661), imageName: "cookhat"))
        local.addActivity(activity: Activity(name: "Capoeira recifence", address: City.recife.withCoordinate(latitude: -8.0657236, longitude: -34.872713), imageName: "capo"))
        locals.append(local)
        local = Local(name: "Januário", imageName: "samba")
        local.addActivity(activity: Activity(name: "Confecção de bonecos de barro", address: City.recife.withCoordinate(latitude: -8.0574190, longitude: -34.8715867), imageName: "samba"))
        locals.append(local)
    }
}

class LocationSearchTable : UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

public class MenuOption{
    let text: String
    let image: UIImage
    let action: () -> Void
    init(text: String, image: UIImage, action: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.action = action
        
    }
    public func performAction(){
        action()
    }
    public func getText()-> String{
        return text
    }
    public func getImage() -> UIImage{
        return image
    }
    
}

class LocalCollectionViewCell: UICollectionViewCell{
    let photo = UIImageView()
    let name = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        photo.frame = CGRect(x: 60, y: 20, width: 100, height: 100)
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = photo.frame.width/2
        name.frame = CGRect(x: 60, y: 120, width: 100, height: 45)
        name.font = UIFont(name: "Gilbert", size: 29)
        name.textAlignment = .center
        name.adjustsFontSizeToFitWidth = true
        name.textColor = .lightGray
        addSubview(photo)
        addSubview(name)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

public class MapViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let bank = localsBank()

    public let mapView = MKMapView(frame: CGRect(x:0, y: 106, width: 1024, height:556))
    
    public var locationManager = CLLocationManager()
    
    public let width: CGFloat = 1024
    public let height: CGFloat = 768
    public var backView = UIView()
    
    public let sectionInsets = UIEdgeInsets(top:   100.0,   left: 30.0,
                                             bottom:100.0,   right: 30.0)
    public let itemsPerRow: CGFloat = 3
    
    let menuIcon = UIButton()
    let menuView = UIView()
    let menuTableView = UITableView()
    let cityLabel = UILabel()
    var menuOptions: [MenuOption] = []
    let progressBar = CircleProgressView()
    var localCollection: UICollectionView?
    let progressName = UILabel()
    
    let achievementButton = UIButton()
    override public func loadView() {

        self.view = UIView()
        
        let orangeTab = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 106))
        orangeTab.backgroundColor = .myOrange
        
        let logoBackground = UILabel(frame: CGRect(x: 376, y: 16, width: 273, height: 77))
        logoBackground.backgroundColor = .myLightGrey
        logoBackground.layer.masksToBounds = true
        logoBackground.layer.cornerRadius = 17
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 273, height: 77))
        label.font = UIFont(name: "Gilbert Color", size: 80)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "co-create"
        
        
        let belowTab = UIView(frame: CGRect(x: 0, y: 662, width: 1024, height: 106))
        belowTab.backgroundColor = .myLightGrey
        let line = UIView(frame: CGRect(x: 0, y: 0, width: belowTab.frame.width, height: 1))
        line.backgroundColor = .lightGray
        
        
        cityLabel.frame = CGRect(x: belowTab.frame.width/2 - 140, y: 20, width: 280, height: 60)
        cityLabel.font = UIFont(name: "Gilbert Color", size: 80)
        cityLabel.textAlignment = .center
        cityLabel.adjustsFontSizeToFitWidth = true
        
        cityLabel.text = "Recife"
        
        progressBar.frame = CGRect(x: 15, y: 15, width: 76, height: 76)
        progressBar.centerFillColor = .clear
        progressBar.backgroundColor = .clear
        progressBar.clockwise = true
        progressBar.setProgress(0.9, animated: true)
        progressBar.trackBackgroundColor = .clear
        progressBar.trackWidth = 8
        progressBar.trackFillColor = .myLightBlue
        cityLabel.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(progress(_:))))
        let number = UILabel(frame: CGRect(x: 13, y: 10, width: 49, height: 52))
        number.font = UIFont(name: "Gilbert Color", size: 55)
        number.textAlignment = .center
        number.adjustsFontSizeToFitWidth = true
        number.text = String(25)

        achievementButton.frame = CGRect(x: 919, y: 10, width: 82, height: 87)
        achievementButton.setImage(UIImage(imageLiteralResourceName: "premio"), for: .normal)
        achievementButton.addTarget(self, action: #selector(presentNext), for:.touchUpInside)
        
        
        
        createMenu()
        view.addSubview(orangeTab)
        orangeTab.addSubview(logoBackground)
        logoBackground.addSubview(label)
        orangeTab.addSubview(menuIcon)
        view.addSubview(mapView)
        
        view.addSubview(belowTab)
        belowTab.addSubview(line)
        belowTab.addSubview(cityLabel)
        belowTab.addSubview(progressBar)
        progressBar.addSubview(number)
        belowTab.addSubview(achievementButton)
        view.addSubview(menuView)
    }
    @objc func progress(_ gestureRecognizer: UITapGestureRecognizer){
        print("a")
        progressBar.setProgress(0.9, animated: true)
    }
    @objc func presentNext(){
        let vc = AchievementsViewController(screenType: .ipad)
        //vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        self.menuView.frame = CGRect(x: 0, y: 0, width: 0, height: 1024)
        self.menuIcon.frame = CGRect(x: 30, y: 30, width: 54, height: 42)
        self.menuTableView.frame = CGRect(x: 0, y: 106, width: 0, height: self.menuView.frame.height - 107)
    
    }
    
    
    @objc func openMenu(){
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            
            if self.menuView.frame.width <= 1{
                self.menuView.frame = CGRect(x: 0, y: 0, width: 240, height: self.view.frame.height)
                self.menuIcon.frame = CGRect(x: self.menuView.frame.width + 30, y: 30, width: 54, height: 42)
                self.menuTableView.frame = CGRect(x: 0, y: 106, width: 240, height: self.menuView.frame.height - 107)
            }
            else{
                self.menuView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height)
                self.menuIcon.frame = CGRect(x: 30, y: 30, width: 54, height: 42)
                self.menuTableView.frame = CGRect(x: 0, y: 106, width: 0, height: self.menuView.frame.height - 107)
            }
        })
    }
    
    func createMenu(){
        menuOptions.append(MenuOption(text: "Acompanhe as atividades inscritas", image: UIImage(imageLiteralResourceName: "premio"), action: openMenu))
        menuOptions.append(MenuOption(text: "Descubra as atividades de recife", image: UIImage(imageLiteralResourceName: "mark"), action: openMenu))
        menuOptions.append(MenuOption(text: "Conheça os moradores locais", image: UIImage(imageLiteralResourceName: "premio"), action: createLocalsView))
        menuOptions.append(MenuOption(text: "Encerrar viagem", image: UIImage(imageLiteralResourceName: "cancel"), action: openMenu))
        
        menuIcon.contentMode = .scaleToFill
        menuIcon.frame = CGRect(x: 30, y: 30, width: 54, height: 42)
        menuIcon.setImage(UIImage(imageLiteralResourceName: "icons-menu.png"), for: .normal)
        menuIcon.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        menuView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height)
        menuView.backgroundColor = .myLightBlue
        
        menuTableView.frame = CGRect(x: 0, y: 107, width: 240, height: self.menuView.frame.height - 107)
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
        menuTableView.reloadData()
        menuTableView.backgroundColor = .clear
        menuView.addSubview(menuTableView)
        menuTableView.tintColor = .clear
        menuTableView.frame = CGRect(x: 0, y: 107, width: 0, height: self.menuView.frame.height - 107)
    }
    
    public func createOptionView(){
        openMenu()
        backView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        backView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        
        let mainView = UIView(frame: CGRect(x: 164, y: 146, width: 696, height: 560))
        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = true
        mainView.backgroundColor = .myLightGrey
        let orangeTab = UIView(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: 53))
        orangeTab.backgroundColor = .myOrange

        let label = UILabel(frame: CGRect(x: orangeTab.frame.width/2 - 170, y: 5, width: 340, height: 43))
        label.font = UIFont(name: "Gilbert", size: 34)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Moradores locais"
        label.textColor = .myLightGrey
        
        let cancelButton = UIButton()
        cancelButton.contentMode = .scaleToFill
        cancelButton.frame = CGRect(x: 12, y: 16, width: 17, height: 17)
        cancelButton.setImage(UIImage(imageLiteralResourceName: "cancel"), for: .normal)

        cancelButton.addTarget(self, action: #selector(removeDetail), for: .touchUpInside)
        view.addSubview(backView)
        backView.addSubview(mainView)
        mainView.addSubview(orangeTab)
        orangeTab.addSubview(label)
        orangeTab.addSubview(cancelButton)
    }

    func createLocalsView(){
        createOptionView()
        let flowLayout = UICollectionViewFlowLayout()
        
        let mainView = backView.subviews[0]
        let orangeTab = mainView.subviews[0]
        guard let label = orangeTab.subviews[0] as? UILabel else{fatalError()}
        localCollection = UICollectionView(frame: CGRect(x: 0, y: 53, width: mainView.frame.width, height: mainView.frame.height - 53), collectionViewLayout: flowLayout)
        localCollection?.register(LocalCollectionViewCell.self, forCellWithReuseIdentifier: "localCell")
        
        label.text = "Moradores locais"
        localCollection?.backgroundColor = .clear

        localCollection?.bounces = true
        
        localCollection?.delegate = self
        localCollection?.dataSource = self
        localCollection?.reloadData()
        
        
        mainView.addSubview(localCollection!)
        
    }
    @objc func removeDetail(){
        backView.removeFromSuperview()
        
    }
    //MARK:- COLLECTION VIEW FUNCTIONS
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == localCollection{
            return bank.locals.count * 2
        }
        else{
            
        }
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == localCollection{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localCell", for: indexPath) as? LocalCollectionViewCell else{
                fatalError("Não foi possivel instanciar uma LocalCollectionViewCell")
            }
            let local = bank.locals[indexPath.row % 2]
            cell.photo.image = local.image
            cell.name.text = local.name
            return cell
        }
        else{
            
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == localCollection{

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
        }
        else{
            
        }
        return CGSize.zero
    }
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == localCollection{

        return sectionInsets
        }
        else{
            
        }
        return UIEdgeInsets.zero
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == localCollection{

        print("elaine")
        }
        else{
            
        }
    }
    
    //MARK:- TABLEVIEW FUNCTIONS
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == menuOptions.count - 1{
            return tableView.frame.height - CGFloat((menuOptions.count - 1) * 100)
        }
        return 100
    }
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell else {
            fatalError("The dequeued cell is not an instance of MenuTableViewCell.")
        }
        let menuOption = menuOptions[indexPath.row]
        cell.iconView.image = menuOption.getImage()
        cell.backgroundColor = .clear
        cell.titleLabel.text = menuOption.getText()
        cell.selectionStyle = .none
        cell.set()
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let menuOption = menuOptions[indexPath.row]
        menuOption.performAction()
        
    }
}
extension MenuTableViewCell{
    public func set(){
        
        let half = self.frame.height / 2
        iconView.frame = CGRect(x: 10, y: half - 20, width: 40, height: 40)
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = iconView.frame.width/2
        
        titleLabel.frame = CGRect(x: 60, y: 10, width: 175, height: self.frame.height - 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .myLightGrey
        titleLabel.numberOfLines = 2
        
    }
}


extension MapViewController: MKMapViewDelegate{
    public override func viewDidLoad() {
        
        let recife = City.recife
        
        mapView.delegate = self
        mapView.contentMode = .scaleAspectFit
        mapView.showsUserLocation = true
        
        mapView.setRegion(recife.region, animated: true)
        
        for local in bank.locals{
            
            for activity in local.activities{
                let annotation = MKPointAnnotation()
                annotation.coordinate = activity.address.coordinates
                mapView.addAnnotation(annotation)
            }
        }
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 30000), animated: true)
        mapView.cameraBoundary = recife.getBoundary()
        mapView.setCamera(MKMapCamera(lookingAtCenter: recife.startPoint, fromDistance: 3000, pitch: 30, heading: .leastNormalMagnitude), animated: true)
        
        
        
        
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        annotationView?.contentMode = .scaleToFill
        annotationView?.image = UIImage(imageLiteralResourceName: "mark@3x").withHorizontallyFlippedOrientation()
        for local in bank.locals{
            for activity in local.activities{
                if annotation.coordinate.latitude == activity.address.coordinates.latitude{
                    let imagev = UIImageView(image: activity.image)
                    
                    annotationView?.addSubview(imagev)
                }
            }
        }
        
        annotationView?.frame.size = CGSize(width: 132, height: 90)
    
        annotationView?.canShowCallout = false
        return annotationView
    }
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for local in bank.locals{
            for activity in local.activities{
                for sub in view.subviews{
                    if let sub = sub as? UIImageView{
                        
                        if sub.image == activity.image{
                            print(local.name)
                        }
                    }
                }
            }
        }
    }
}

let vc = MapViewController(screenType: .ipad, isPortrait: false)

let navigation = UINavigationController(screenType: .ipad, isPortrait: false)
navigation.pushViewController(vc, animated: false)
navigation.navigationBar.isHidden = true
PlaygroundPage.current.needsIndefiniteExecution = true

PlaygroundPage.current.liveView = navigation.scale(to: 0.75)
