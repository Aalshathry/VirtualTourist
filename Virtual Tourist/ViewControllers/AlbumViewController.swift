//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Al Shathry on 28/05/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
import Kingfisher

class AlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var dataController: DataController!
    var pin: Pin!
    
    var isEmpty: Bool{
        return fetchedResultsController?.fetchedObjects?.count == 0
    }
    
    var blockOperations: [BlockOperation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetch()
    }
    
    func fetch() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        
        try? fetchedResultsController.performFetch()
        loadImages()
        
    }
    
    
    private func setupMap() {
        
        let latitude = pin.latitude
        let longitude = pin.longitude
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
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
    
    func loadImages(){
        if(isEmpty){
            API.getImages(self.pin!) { err  in
                guard err == nil else {
                    return
                }
                let alert = UIAlertController(title: "There was an error", message: err!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                self.present(alert, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func newCollection(_ sender: Any) {
        collectionButton.isEnabled = false
        
        let photos = fetchedResultsController.fetchedObjects
                
        for photo in photos!{
            DataController.shared.viewContext.delete(photo)
            try? DataController.shared.viewContext.save()
        }
        
        fetch()
        loadImages()
        collectionButton.isEnabled = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    
        let photo = fetchedResultsController.object(at: indexPath)
        if photo.image == nil{
            let imageUrl = URL(string: (photo.url)!)!
            let imageData = try! Data(contentsOf: imageUrl)
            photo.image = imageData

            let image = UIImage(data: imageData)
            
            cell.ImageProduct.image = image
            cell.ImageProduct.kf.indicatorType = .activity
            cell.ImageProduct.kf.setImage(with: imageUrl, options: [.transition(.fade(0.5))])
        }
        else{
            let image = UIImage(data: photo.image!)
            
            cell.ImageProduct.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = fetchedResultsController.object(at: indexPath)
        DataController.shared.viewContext.delete(object)
        try? DataController.shared.viewContext.save()
    }
    
}


extension AlbumViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            break
        default: ()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: collectionView.insertSections(indexSet)
        case .delete: collectionView.deleteSections(indexSet)
        default: ()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: BlockOperation in self.blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
}
