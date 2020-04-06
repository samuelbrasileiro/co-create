//: A UIKit based Playground for presenting user interface
//TODO:- Criar classe de locais e de atividades. além disso, terminar a criação da table view de menu
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
    var coordinates: CLLocationCoordinate2D
    
    private var ctRegion: MKCoordinateRegion
    public var region: MKCoordinateRegion{
        return ctRegion
    }
    
    private var ctStartPoint:CLLocationCoordinate2D
    public var startPoint: CLLocationCoordinate2D{
        return ctStartPoint
    }
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
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
class CityBank{
    static var recife: City{
        get{
            let city = City(latitude: -8.0522, longitude: -34.9286)
            city.setMapSize(latitudeInMeters: 22000, longitudeInMeters: 22000)
            city.setStartPoint(latitude: -8.062169, longitude: -34.877139)
            return city
        }
    }
    static var rioDeJaneiro: City{
        get{
            let city = City(latitude: 22.9068, longitude: 43.1729)
            return city
        }
    }
    static var salvador: City{
        get{
            let city = City(latitude: 12.9777, longitude: 38.5016)
            return city
        }
    }

}

class menuOption{
    let text: String
    let image: UIImage
    let action: () -> Void
    init(text: String, image: UIImage, action: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.action = action
        
    }
    func performAction(){
        action()
    }
}


extension MapViewController{
    public override func viewDidLoad() {
        let recife = CityBank.recife
        
        mapView.showsUserLocation = true
        
        mapView.setRegion(recife.region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = recife.coordinates
        
        mapView.addAnnotation(annotation)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 30000), animated: true)
        mapView.cameraBoundary = recife.getBoundary()
        mapView.setCamera(MKMapCamera(lookingAtCenter: recife.startPoint, fromDistance: 3000, pitch: 30, heading: .leastNormalMagnitude), animated: true)
    }
}


let vc = MapViewController(screenType: .ipad, isPortrait: false)

let navigation = UINavigationController(screenType: .ipad, isPortrait: false)
navigation.pushViewController(vc, animated: false)
navigation.navigationBar.isHidden = true
PlaygroundPage.current.needsIndefiniteExecution = true

PlaygroundPage.current.liveView = navigation.scale(to: 0.75)
