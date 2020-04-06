//: A UIKit based Playground for presenting user interface
  
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
    var region: MKCoordinateRegion
    var startPoint:CLLocationCoordinate2D
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        startPoint = coordinates
    }
    func setMapSize(latitudeInMeters: Double, longitudeInMeters: Double){
        region = MKCoordinateRegion(
        center: coordinates, latitudinalMeters: latitudeInMeters, longitudinalMeters: longitudeInMeters)
    }
    func setStartPoint(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        startPoint = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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

extension MapViewController{
    public override func viewDidLoad() {
        let recife = CityBank.recife
        
        mapView.showsUserLocation = true
        
        mapView.setRegion(recife.region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = recife.coordinates
        
        mapView.addAnnotation(annotation)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 60000), animated: true)
        mapView.cameraBoundary = recife.getBoundary()
        mapView.centerCoordinate
    
    }
}


let vc = MapViewController(screenType: .ipad, isPortrait: false)

let navigation = UINavigationController(screenType: .ipad, isPortrait: false)
navigation.pushViewController(vc, animated: false)
navigation.navigationBar.isHidden = true
PlaygroundPage.current.needsIndefiniteExecution = true

PlaygroundPage.current.liveView = navigation.scale(to: 0.75)
