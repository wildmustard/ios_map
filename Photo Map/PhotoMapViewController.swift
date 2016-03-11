//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var captureButton: UIButton!
    
    // Variables
    let vc = UIImagePickerController()
    var chosenImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //makes UIButton circular
//        captureButton.imageView?.layer.cornerRadius = ((captureButton.imageView?.bounds.size.height)!/2);
        
        
        // Setup Map View Region
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
            MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        
        // Setup Camera View
        vc.delegate = self
        vc.allowsEditing = true
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) == false) {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        else {
            vc.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions
    
    // Camera Button Press
    @IBAction func onCameraPress(sender: AnyObject) {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // Image Picker Delegate
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            chosenImg = editedImage
            
            // Do something with the images (based on your use case)
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.performSegueWithIdentifier("tagSegue", sender: nil)
            })
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! LocationsViewController
        vc.delegate = self
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        
        let ann = MKPointAnnotation()
        let locationCoord = CLLocationCoordinate2DMake(Double(latitude), Double(longitude))
        ann.coordinate = locationCoord
        ann.title = "Picture!"
        mapView.addAnnotation(ann)
    
    
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
    

}
