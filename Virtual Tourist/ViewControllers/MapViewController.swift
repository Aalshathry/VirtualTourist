//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Al Shathry on 25/05/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePinsByTapping()
        mapView.delegate = self
        
        fetch()
    }
    
    func fetch() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate

        try? fetchedResultsController.performFetch()
        
        let pins = fetchedResultsController.fetchedObjects
        
        for pin in pins! {
            loadPins(pin: pin)
        }
        
    }
    
    func loadPins(pin: Pin){
        let annotation = MyPinAnnotation()

        annotation.coordinate.latitude = pin.latitude
        annotation.coordinate.longitude = pin.longitude
        annotation.pinObject = pin
        
        mapView.addAnnotation(annotation)
    }
    
    func createNewPin(longitude: Double, latitdue: Double) -> Pin {
        let pin = Pin(context: DataController.shared.viewContext)
        pin.longitude = longitude
        pin.latitude = latitdue
        pin.createdAt = Date()
        try? DataController.shared.viewContext.save()
        return pin
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        guard sender.state == UIGestureRecognizer.State.began else {return}
        
        let touchPoint = sender.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        let annotation = MyPinAnnotation()
        annotation.coordinate = coordinate
        annotation.pinObject =  self.createNewPin(longitude: coordinate.longitude, latitdue: coordinate.latitude)

        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "nextVC") as! AlbumViewController
        
        vc.pin = (view.annotation! as! MyPinAnnotation).pinObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func makePinsByTapping() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
}
