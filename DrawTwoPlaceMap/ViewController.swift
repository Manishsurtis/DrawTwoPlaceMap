//
//  ViewController.swift
//  DrawTwoPlaceMap
//
//  Created by Manish on 05/08/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit
import MapKit

class customPin : NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var subTitle : String?
    
    init(title : String,subTitle : String,coordinate : CLLocationCoordinate2D){
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
    }
}

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapDisplay: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sourceDes = CLLocationCoordinate2D(latitude: 23.059670, longitude: 72.637070)
        let destDes = CLLocationCoordinate2D(latitude: 23.045988, longitude: 72.513824)
        
        let sourcPin = customPin(title: "Krishananagar", subTitle: "", coordinate: sourceDes)
        let destPin = customPin(title: "Bodakdev", subTitle: "", coordinate: destDes)
        
        self.mapDisplay.addAnnotation(sourcPin)
        self.mapDisplay.addAnnotation(destPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceDes)
        let destPlaceMark = MKPlacemark(coordinate: destDes)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destPlaceMark)
        
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.mapDisplay.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapDisplay.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        self.mapDisplay.delegate = self
    
    }


    //MARK:- MapKit delegates
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

