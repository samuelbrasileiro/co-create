//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import MapKit
import CoreLocation
import XCPlayground
// Present the view controller in the Live View window
let cfURL = Bundle.main.url(forResource: "Gilbert-Color", withExtension: "otf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)


public class MyViewController : UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate{
    
    let mapView = MKMapView(frame: CGRect(x:0, y: 106, width: 1024, height:556))
    
    var mapRegion = MKCoordinateRegion()
    var locationManager = CLLocationManager()
    
    let menuIcon = UIButton()
    
    let cityLabel = UILabel()
    
    let progressBar = CircleProgressView()
    
    let progressName = UILabel()
    
    let achievementButton = UIButton()
    override public func loadView() {
        self.view = UIView()
        view.backgroundColor = .blue
        mapView.delegate = self
        mapView.contentMode = .scaleAspectFit
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
        
        menuIcon.contentMode = .scaleToFill
        menuIcon.frame = CGRect(x: 30, y: 30, width: 54, height: 42)
        menuIcon.setImage(UIImage(imageLiteralResourceName: "icons-menu.png"), for: .normal)
        
        let belowTab = UIView(frame: CGRect(x: 0, y: 652, width: 1024, height: 106))
        belowTab.backgroundColor = .myLightGrey
        let line = UIView(frame: CGRect(x: 0, y: 0, width: belowTab.frame.width, height: 1))
        line.backgroundColor = .lightGray
        
        
        cityLabel.frame = CGRect(x: belowTab.frame.width/2 - 140, y: 10, width: 280, height: 60)
        cityLabel.font = UIFont(name: "Gilbert Color", size: 60)
        cityLabel.textAlignment = .center
        cityLabel.adjustsFontSizeToFitWidth = true
        
        cityLabel.text = "Recife"
        
        progressBar.frame = CGRect(x: 15, y: 15, width: 58, height: 58)
        progressBar.centerFillColor = .clear
        progressBar.backgroundColor = .clear
        progressBar.clockwise = true
        progressBar.setProgress(0.9, animated: true)
        progressBar.trackBackgroundColor = .clear
        progressBar.trackWidth = 8
        progressBar.trackFillColor = .myLightBlue
        
        let number = UILabel(frame: CGRect(x: 10, y: 10, width: 38, height: 40))
        number.font = UIFont(name: "Gilbert Color", size: 37)
        number.textAlignment = .center
        number.adjustsFontSizeToFitWidth = true
        number.text = String(12)
        
        achievementButton.frame = CGRect(x: 700, y: 15, width: 54, height: 58)
        achievementButton.setImage(UIImage(imageLiteralResourceName: "premio"), for: .normal)
        achievementButton.addTarget(self, action: #selector(presentNext), for:.touchUpInside)
        
        let recifeCoordinates = CLLocationCoordinate2DMake(-8.0522, -34.9286)

        let mapRegionSpan = 0.02
        mapRegion.center = recifeCoordinates
        mapView.showsUserLocation = true
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan

        mapView.setRegion(mapRegion, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = recifeCoordinates
        
        mapView.addAnnotation(annotation)
        
        
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
    }
    @objc func presentNext(){
        let vc = AchievementViewController()
        //vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)

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
class AchievementViewController: UIViewController{
    let returnButton = UIButton()
    override public func loadView() {
        self.view = UIView()
        view.backgroundColor = .myLightBlue
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
        label.text = "Recife"
        
        returnButton.contentMode = .scaleToFill
        returnButton.frame = CGRect(x: 30, y: 30, width: 54, height: 42)
        returnButton.setImage(UIImage(imageLiteralResourceName: "icons-menu.png"), for: .normal)
    
        view.addSubview(orangeTab)
        orangeTab.addSubview(logoBackground)
            logoBackground.addSubview(label)
        orangeTab.addSubview(returnButton)
    }
}

let vc = MyViewController()

//vc.preferredContentSize = CGSize(width: 800, height: 600)
let navigation = UINavigationController(screenType: .ipad, isPortrait: false)
navigation.pushViewController(vc, animated: false)
//navigation.navigationBar.isHidden = true
//PlaygroundPage.current.needsIndefiniteExecution = true // Sets up the constant running of the playground so that the location can update properly

PlaygroundPage.current.liveView = navigation.scale(to: 0.6)
