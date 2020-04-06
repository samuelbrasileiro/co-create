import Foundation
import UIKit
import MapKit
//import PlaygroundSuport

public class MapViewController : UIViewController,  MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource{

    
    public let mapView = MKMapView(frame: CGRect(x:0, y: 106, width: 1024, height:556))
    
    public var locationManager = CLLocationManager()
    
    let menuIcon = UIButton()
    let menuView = UIView()
    let menuTableView = UITableView()
    let cityLabel = UILabel()
    
    let progressBar = CircleProgressView()
    
    let progressName = UILabel()
    
    let achievementButton = UIButton()
    override public func loadView() {
        //navigationController?.navigationBar.isHidden = true
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
        }, completion: {(_) in
            
        })
    }
    
    func createMenu(){
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
        
        menuTableView.frame = CGRect(x: 0, y: 107, width: 0, height: self.menuView.frame.height - 107)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 5{
            return self.menuTableView.frame.height - 5 * 100
        }
        return 100
    }
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("here")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell else {
            fatalError("The dequeued cell is not an instance of MenuTableViewCell.")
        }
        print("here")
        cell.iconView.image = UIImage(imageLiteralResourceName: "premio")
        cell.backgroundColor = .clear
        cell.titleLabel.text = "index " + String(indexPath.row)
        
        return cell
    }
    
}
