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

class City{
    var ctName: String
    public var name: String{
        return ctName
    }
    var coordinates: CLLocationCoordinate2D
    
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
    func setMapSize(latitudeInMeters: Double, longitudeInMeters: Double){
        ctRegion = MKCoordinateRegion(
        center: coordinates, latitudinalMeters: latitudeInMeters, longitudinalMeters: longitudeInMeters)
    }
    func setStartPoint(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        ctStartPoint = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    func getBoundary()->MKMapView.CameraBoundary{
        return MKMapView.CameraBoundary(coordinateRegion: region)!
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

public class MapViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{

    public let mapView = MKMapView(frame: CGRect(x:0, y: 106, width: 1024, height:556))
    
    public var locationManager = CLLocationManager()
    
    let menuIcon = UIButton()
    let menuView = UIView()
    let menuTableView = UITableView()
    let cityLabel = UILabel()
    var menuOptions: [MenuOption] = []
    let progressBar = CircleProgressView()
    
    let progressName = UILabel()
    
    let achievementButton = UIButton()
    override public func loadView() {
        //navigationController?.navigationBar.isHidden = true
        self.view = UIView()
        
        //locationManager.delegate = self
        
//        let line = UIView(frame: CGRect(x: 400, y: 0, width: 1, height: 600))
//        line.backgroundColor = .lightGray
//        view.addSubview(line)
        
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
        menuOptions.append(MenuOption(text: "Conheça os moradores locais", image: UIImage(imageLiteralResourceName: "premio"), action: openMenu))
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

        let annotation = MKPointAnnotation()
        annotation.coordinate = recife.coordinates
        
        mapView.addAnnotation(annotation)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 30000), animated: true)
        mapView.cameraBoundary = recife.getBoundary()
        mapView.setCamera(MKMapCamera(lookingAtCenter: recife.startPoint, fromDistance: 3000, pitch: 30, heading: .leastNormalMagnitude), animated: true)
        
        
        //APAGAR ISSO DPS
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(mapTap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func mapTap(_ gestureRecognizer: UITapGestureRecognizer) {

        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        annotationView?.contentMode = .scaleToFill
        annotationView?.image = UIImage(imageLiteralResourceName: "mark@3x")
        annotationView?.frame.size = CGSize(width: 132, height: 90)
    
        annotationView?.canShowCallout = false
        return annotationView
    }
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.frame)
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            
            if view.frame.width == 132{
                view.frame = CGRect(x: view.frame.origin.x - 60, y: view.frame.origin.y - 40, width: view.frame.width + 60, height: view.frame.height + 40)
            }
            else{
                view.frame = CGRect(x: view.frame.origin.x + 60, y: view.frame.origin.y + 40, width: view.frame.width - 60, height: view.frame.height - 40)
            }
        })
    }
}

let vc = MapViewController(screenType: .ipad, isPortrait: false)

let navigation = UINavigationController(screenType: .ipad, isPortrait: false)
navigation.pushViewController(vc, animated: false)
navigation.navigationBar.isHidden = true
PlaygroundPage.current.needsIndefiniteExecution = true

PlaygroundPage.current.liveView = navigation.scale(to: 0.75)
