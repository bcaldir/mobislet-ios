//
//  DiscoveryViewController.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 15/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class DiscoveryViewController: UIViewController, PagingViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // Check later
    private let locationManager = CLLocationManager()
    
    // Values
    private var campaignsPagingViewHeight: CGFloat = 360
    private var storesPagingViewHeight: CGFloat = 360
    private var mallsPagingViewHeight: CGFloat = 360
    
    private var mapViewHeight: CGFloat = 220
    
    private var searchButtonHeight: CGFloat = 50
    private var searchButtonRightMargin: CGFloat = 20
    private var searchButtonBottomMargin: CGFloat = 100
    
    private var closeButtonHeight: CGFloat = 25
    private var closeButtonRightMargin: CGFloat = 10
    private var closeButtonTopMargin: CGFloat = 10
    
    private var annotationViewCalloutButtonHeight: CGFloat = 30
    
    private var locationButtonHeight: CGFloat = 50.0
    
    private var labelTextMargin: CGFloat = 20.0
    
    private var scaleParameter: CGFloat = 1.0 {
        didSet {
            campaignsPagingViewHeight *= scaleParameter
            storesPagingViewHeight *= scaleParameter
            mallsPagingViewHeight *= scaleParameter
            
            mapViewHeight *= scaleParameter
            
            searchButtonHeight *= scaleParameter
            searchButtonRightMargin *= scaleParameter
            searchButtonBottomMargin *= scaleParameter
            
            closeButtonHeight *= scaleParameter
            closeButtonRightMargin *= scaleParameter
            closeButtonTopMargin *= scaleParameter
            
            annotationViewCalloutButtonHeight *= scaleParameter
            
            locationButtonHeight *= scaleParameter
            
            labelTextMargin *= scaleParameter
            
        }
    }
    
    // Variables
    var mapDataReturned = false {
        didSet {
            if mapDataReturned && pagingViewsDataReturned {
                self.loadingView.stopAnimating()
                /*
                 var campaignData = [Mobitem](count: 4, repeatedValue: Mobitem(type: MobitemType.Campaign))
                 campaignData.append(Mobitem(type: MobitemType.Campaign,  name: "Campaign 2", userLiked: true))
                 popularCampaignsPagingView.setData(campaignData)
                 */
            }
        }
    }
    
    var pagingViewsDataReturned = true {
        didSet {
            if mapDataReturned && pagingViewsDataReturned {
                self.loadingView.stopAnimating()
            }
        }
    }
    
    var mapRemoved = false
    var userLocationUpdatedOnce = false
    
    // Views
    var newCampaignsPagingView: PagingView!
    var popularCampaignsPagingView: PagingView!
    var popularStoresPagingView: PagingView!
    var popularMallsPagingView: PagingView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var loadingView : MAActivityIndicatorView!
    
    var map: MKMapView!
    var openLocationServicesBanner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleParameter = UTILS.scaleFactor
        
        self.mainScrollView.backgroundColor = CONSTANTS.colorAppVeryLightGray
        
        self.loadingView.startAnimating()
        
        self.addSearchButton()
        self.addMapArea { () -> Void in
            self.locationManager.delegate = self
            self.addPagingViews()
        }
        
        self.addGestureRecognizer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestureRecognizer() {
        
        let leftGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DiscoveryViewController.swipeLeftHandler(_:)))
        leftGestureRecognizer.direction = .Left
        self.mainScrollView!.addGestureRecognizer(leftGestureRecognizer)
        
        let rightGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DiscoveryViewController.swipeRightHandler(_:)))
        rightGestureRecognizer.direction = .Right
        self.mainScrollView!.addGestureRecognizer(rightGestureRecognizer)
        
        
    }
    
    func swipeLeftHandler(recognizer: UISwipeGestureRecognizer) {
        swipeHandler(UISwipeGestureRecognizerDirection.Left)
    }
    
    func swipeRightHandler(recognizer: UISwipeGestureRecognizer) {
        swipeHandler(UISwipeGestureRecognizerDirection.Right)
    }
    
    func swipeHandler(direction: UISwipeGestureRecognizerDirection) {
        
        
        if direction == UISwipeGestureRecognizerDirection.Left {
            print("swipe left")
            
            if let currentPage = self.tabBarController?.selectedIndex {
                if (currentPage+1) < self.tabBarController?.tabBar.items?.count {
                    self.tabBarController?.selectedIndex = currentPage + 1
                }
            }
        } else if direction == UISwipeGestureRecognizerDirection.Right {
            
            print("swipe right")
            
            if let currentPage = self.tabBarController?.selectedIndex {
                if currentPage > 0 {
                    self.tabBarController?.selectedIndex = currentPage - 1
                }
            }
        }
    }
    
    
    func requestNearestMalls(coordinate: CLLocationCoordinate2D, completed: Completed) {
        
        if self.openLocationServicesBanner != nil {
            self.openLocationServicesBanner.removeFromSuperview()
        }
        
        if self.map != nil {
            self.mainScrollView.addSubview(self.map)
        } else {
            return
        }
        
        
        
        DataService.sharedInstance.sendAlamofireRequest(.GET, urlString: "\(DataService.MALL_SERVICE_URL)\(DataService.MALLS_NEAREST_GET_URL)/\(coordinate.latitude)/\(coordinate.longitude)/0", parameters: nil) { (result, err) -> Void in
            
            if let error = err {
                
                self.removeViewFromScrollviewContent(self.map)
                
                
                let alert = SCLAlertView()
                
                alert.showInfo("Uyarı", subTitle: error.description, closeButtonTitle: "Kapat")
                alert.dismissBlock = { () -> Void in
                    
                }
                
                
            } else if let dict = result {
                
                if let nearestMalls = JSONParser.getMallListFrom(dict) {
                    self.pinDataOnMap(nearestMalls)
                    
                } else {
                    self.removeViewFromScrollviewContent(self.map)
                }
            }
            completed()
        }
    }
    
    func removeViewFromScrollviewContent(theView: UIView?) {
        
        // Use thread for frame changes
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            var isViewRemoved = false
            var heightOfViewRemoved: CGFloat = 0.0
            var originYOfViewRemoved: CGFloat = 0.0
            if let viewToRemove = theView {
                
                for var i = 0; i<self.mainScrollView.subviews.count; i++ {
                    
                    let tempViewOriginY = self.mainScrollView.subviews[i].frame.origin.y
                    
                    if isViewRemoved && tempViewOriginY > originYOfViewRemoved {
                        
                        UIView.animateWithDuration(0.5, animations: {
                            self.mainScrollView.subviews[i].frame.origin.y -= heightOfViewRemoved
                        })
                    } else {
                        if self.mainScrollView.subviews.contains(viewToRemove) {
                            heightOfViewRemoved = viewToRemove.frame.height
                            originYOfViewRemoved = viewToRemove.frame.origin.y
                            viewToRemove.removeFromSuperview()
                            isViewRemoved = true
                            
                            i-=1
                        }
                    }
                }
                
                
                if isViewRemoved {
                    
                    UIView.animateWithDuration(0.5, animations: {
                        self.mainScrollView.contentInset.bottom -= heightOfViewRemoved
                    })
                }
                
                /*
                 if self.mainScrollView.subviews.contains(viewToRemove) {
                 let viewHeight = viewToRemove.frame.height
                 viewToRemove.removeFromSuperview()
                 // self.mainScrollView.contentInset.top = -viewHeight
                 }
                 */
            }
            
            
        }
        
        
        
    }
    
    func locationNotAllowed() {
        
        self.removeViewFromScrollviewContent(self.map)
        self.removeViewFromScrollviewContent(self.openLocationServicesBanner)
    }
    
    func addMapArea(completed: Completed) {
        
        let status = CLLocationManager.authorizationStatus()
        
        let pagingViewWidth = self.view.frame.width
        let scrollHeightY: CGFloat = self.updateScrollviewContentSize()
        self.map = MKMapView(frame: CGRectMake(0.0, scrollHeightY, pagingViewWidth, self.mapViewHeight))
        self.map.delegate = self
        
        /*
         let mapLoadingView = MAActivityIndicatorView(frame: CGRectMake(0.0, 0.0, map.frame.width, map.frame.height))
         mapLoadingView.startAnimating()
         mapLoadingView.style = IndicatorViewType.Small
         self.map.addSubview(mapLoadingView)
         */
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch status {
            case .AuthorizedAlways, .AuthorizedWhenInUse, .NotDetermined:
                self.mainScrollView.addSubview(self.map)
                break
            case .Denied, .Restricted:
                self.mapDataReturned = true
            }
            
        } else {
            self.showActivateLocationBanner({ () -> Void in
                self.mapDataReturned = true
            })
        }
        
        completed()
    }
    
    
    
    func pinDataOnMap(datas: [Mall]) {
        
        for item in datas {
            if let lat = item.latitude, let lon = item.longitude {
                let mallLocation = CLLocation(latitude: lat, longitude: lon)
                self.createAnnotationForLocation(mallLocation, with:  item)
                
            }
        }
        
        self.map.showAnnotations(map.annotations, animated: true)
        
        /*
         for mylocation in self.locations {
         self.addPinToMappOn(mylocation)
         }
         */
        
    }
    
    func showActivateLocationBanner(completed: Completed) {
        
        
        // self.map.removeFromSuperview()
        
        let pagingX: CGFloat = 0.0
        let pagingViewWidth = self.view.frame.width
        
        let scrollHeightY: CGFloat = self.updateScrollviewContentSize()
        
        let locationButtonHeight: CGFloat = self.locationButtonHeight
        
        openLocationServicesBanner = UIView(frame: CGRectMake(pagingX, scrollHeightY, pagingViewWidth, self.mapViewHeight))
        
        let locationButton = UIButton(frame: CGRect(origin: CGPointMake(openLocationServicesBanner!.center.x - locationButtonHeight/2, openLocationServicesBanner!.center.y - locationButtonHeight), size: CGSizeMake(locationButtonHeight, locationButtonHeight)))
        locationButton.setImage(UIImage(named: "open_location_services"), forState: UIControlState.Normal)
        locationButton.addTarget(self, action: #selector(DiscoveryViewController.locationButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        openLocationServicesBanner.addSubview(locationButton)
        
        let locationInfoLabel = UILabel(frame: CGRectMake(self.labelTextMargin, locationButton.center.y + locationButton.frame.height, pagingViewWidth - 2*self.labelTextMargin, 50.0))
        locationInfoLabel.text = STATICS.TEXT_OPEN_LOCATION_SERVICES
        locationInfoLabel.font = CONSTANTS.fontTitle
        locationInfoLabel.adjustsFontSizeToFitWidth = true
        locationInfoLabel.minimumScaleFactor = 0.7
        locationInfoLabel.numberOfLines = 3
        locationInfoLabel.textAlignment = .Center
        
        openLocationServicesBanner.addSubview(locationInfoLabel)
        
        let closeButton = UIButton(frame: CGRectMake(pagingViewWidth - self.closeButtonHeight - self.closeButtonRightMargin, self.closeButtonTopMargin, self.closeButtonHeight, self.closeButtonHeight))
        closeButton.setImage(UIImage(named: "remove"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: #selector(DiscoveryViewController.closeButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        openLocationServicesBanner.addSubview(closeButton)
        
        openLocationServicesBanner.backgroundColor = CONSTANTS.colorAppBackground
        
        self.mainScrollView.addSubview(openLocationServicesBanner)
        
        completed()
    }
    
    
    func locationButtonTapped(sender:UIButton!)
    {
        print("Location button tapped")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        // UIApplication.sharedApplication().openURL(NSURL(string: "My Settings URL")!)
    }
    
    
    func closeButtonTapped(sender:UIButton!)
    {
        self.mapRemoved = true
        self.removeViewFromScrollviewContent(self.openLocationServicesBanner)
    }
    
    func addPagingView(var pagingView: PagingView, data: [Mobitem]) {
        
        let pagingX: CGFloat = 0.0
        let pagingViewWidth = self.view.frame.width
        
        var scrollHeightY: CGFloat = self.updateScrollviewContentSize()
        
        pagingView = PagingView(frame: CGRectMake(pagingX, scrollHeightY, pagingViewWidth, self.campaignsPagingViewHeight), title: "Yeni Kampanyalar", backgroundColor: CONSTANTS.colorPagingViewBackground)
        self.mainScrollView.addSubview(pagingView)
        pagingView.setData(data)
        
        scrollHeightY = self.updateScrollviewContentSize()
    }
    
    func addPagingViews() {
        
        let pagingX: CGFloat = 0.0
        let pagingViewWidth = self.view.frame.width
        
        var scrollHeightY: CGFloat = self.updateScrollviewContentSize()
        
        newCampaignsPagingView = PagingView(frame: CGRectMake(pagingX, scrollHeightY, pagingViewWidth, self.campaignsPagingViewHeight), title: "Yeni Kampanyalar", backgroundColor: CONSTANTS.colorPagingViewBackground)
        //self.mainScrollView.addSubview(newCampaignsPagingView)
        
        scrollHeightY = self.updateScrollviewContentSize()
        
        popularCampaignsPagingView = PagingView(frame: CGRectMake(pagingX, scrollHeightY, pagingViewWidth, self.campaignsPagingViewHeight), title: "Popüler Kampanyalar", backgroundColor: CONSTANTS.colorPagingViewBackground)
        //self.mainScrollView.addSubview(popularCampaignsPagingView)
        
        scrollHeightY = self.updateScrollviewContentSize()
        
        popularStoresPagingView = PagingView(frame: CGRectMake(pagingX, scrollHeightY, pagingViewWidth, self.storesPagingViewHeight), title: "Popüler Mağazalar", backgroundColor: CONSTANTS.colorPagingViewBackground)
        //self.mainScrollView.addSubview(popularStoresPagingView)
        
        scrollHeightY = self.updateScrollviewContentSize()
        
        popularMallsPagingView = PagingView(frame: CGRectMake(pagingX, scrollHeightY, pagingViewWidth, self.mallsPagingViewHeight), title: "Popüler Alıveriş Merkezleri", backgroundColor: CONSTANTS.colorPagingViewBackground)
        //self.mainScrollView.addSubview(popularMallsPagingView)
        
        self.updateScrollviewContentSize()
        
        newCampaignsPagingView.delegate = self
        popularCampaignsPagingView.delegate = self
        popularStoresPagingView.delegate = self
        popularMallsPagingView.delegate = self
        
        self.requestDataForPagingViews()
    }
    
    // Request data for new, popüler campaigns, stores an malls
    func requestDataForPagingViews() {
        
        
        // For New Campaigns
        DataService.sharedInstance.sendAlamofireRequest(.GET, urlString: "\(DataService.CAMPAIGN_SERVICE_URL)\(DataService.CAMPAGINS_NEW_GET_URL)", parameters: nil) { (result, err) -> Void in
            
            if let error = err {
                print("Error in new campaigns -> \(error)")
                self.removeViewFromScrollviewContent(self.newCampaignsPagingView)
                
            } else if let dict = result {
                
                if let newCampaignsData = JSONParser.getCampaignListFrom(dict) {
                    self.newCampaignsPagingView.setData(newCampaignsData)
                    
                } else {
                    self.removeViewFromScrollviewContent(self.newCampaignsPagingView)
                }
            }
        }
        
        
        // For Popular Campaigns
        DataService.sharedInstance.sendAlamofireRequest(.GET, urlString: "\(DataService.CAMPAIGN_SERVICE_URL)\(DataService.CAMPAGINS_POPULAR_GET_URL)", parameters: nil) { (result, err) -> Void in
            
            if let error = err {
                print("Error in popular campaigns -> \(error)")
                self.removeViewFromScrollviewContent(self.popularCampaignsPagingView)
                
            } else if let dict = result {
                
                if let popularCampaignsData = JSONParser.getCampaignListFrom(dict) {
                    self.popularCampaignsPagingView.setData(popularCampaignsData)
                    
                } else {
                    self.removeViewFromScrollviewContent(self.popularCampaignsPagingView)
                }
            }
        }
        
        
        // For Popular Brands
        /*DataService.sharedInstance.sendAlamofireRequest(.GET, urlString: "\(DataService.STORE_SERVICE_URL)\(DataService.BRANDS_POPULAR_GET_URL)", parameters: nil) { (result, err) -> Void in
            
            if let error = err {
                print("Error in popular stores -> \(error)")
                self.removeViewFromScrollviewContent(self.popularStoresPagingView)
                
            } else if let dict = result {
                
                if let popularStoresData = JSONParser.getStoreListFrom(dict) {
                    self.popularStoresPagingView.setData(popularStoresData)
                    
                } else {
                    self.removeViewFromScrollviewContent(self.popularStoresPagingView)
                }
            }
        }*/
        
        
        
        // For Popular Malls
        DataService.sharedInstance.sendAlamofireRequest(.GET, urlString: "\(DataService.MALL_SERVICE_URL)\(DataService.MALLS_POPULAR_GET_URL)", parameters: nil) { (result, err) -> Void in
            
            if let error = err {
                print("Error in popular malls -> \(error)")
                self.removeViewFromScrollviewContent(self.popularMallsPagingView)
                
            } else if let dict = result {
                
                if let popularMallsData = JSONParser.getMallListFrom(dict) {
                    self.popularMallsPagingView.setData(popularMallsData)
                    
                } else {
                    self.removeViewFromScrollviewContent(self.popularMallsPagingView)
                }
            }
        }
        
    }
    
    
    
    func updateScrollviewContentSize() -> CGFloat {
        
        var scrollSize: CGFloat = 0.0
        var contentRect = CGRectZero
        
        for view in self.mainScrollView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
            scrollSize += view.frame.height
        }
        
        self.mainScrollView.contentSize.height = contentRect.size.height - 20
        
        return scrollSize - 20.0
    }
    
    func addSearchButton() {
        
        // Use thread for frame changes
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
        }
        
        let searchButton = UIButton(frame:  CGRectMake(self.view.bounds.width - self.searchButtonHeight - self.searchButtonRightMargin , self.view.bounds.height - self.searchButtonHeight - self.searchButtonBottomMargin,  self.searchButtonHeight, self.searchButtonHeight))
        
        searchButton.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        
        self.view.addSubview(searchButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DiscoveryViewController.searchButtonTapped(_:)))
        tap.numberOfTapsRequired = 1
        searchButton.addGestureRecognizer(tap)
        searchButton.userInteractionEnabled = true
    }
    
    func searchButtonTapped(sender: UIButton!) {
        print("Search happened")
    }
    
    
    /*
     func centerMapOnLocation(location: CLLocation) {
     let coorRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
     map.setRegion(coorRegion, animated: true)
     }
     */
    
    func createAnnotationForLocation(location: CLLocation, with item: Mobitem){
        
        // centerMapOnLocation(location)
        
        var annotationView: MKPinAnnotationView!
        var pointAnnoation: CustomAnnotation!
        
        
        pointAnnoation = CustomAnnotation(coordinate: location.coordinate)
        pointAnnoation.item = item
        pointAnnoation.title = item.name
        
        annotationView = MKPinAnnotationView(annotation: pointAnnoation, reuseIdentifier: "pin")
        
        self.map.addAnnotation(annotationView.annotation!)
        
    }
    
    // MARK: - Navigation
    func pushViewControllerWithData(item: Mobitem) {
        
        
        switch item.mobitemType {
        case .Default:
            break
        case .Campaign:
            self.performSegueWithIdentifier(CONSTANTS.SEGUE_CAMPAIGNDETAIL, sender: item)
        case .Store:
            self.performSegueWithIdentifier(CONSTANTS.SEGUE_STOREDETAIL, sender: item)
        case .Mall:
            self.performSegueWithIdentifier(CONSTANTS.SEGUE_MALLDETAIL, sender: item)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CONSTANTS.SEGUE_CAMPAIGNDETAIL {
            if let destinationVC = segue.destinationViewController as? CampaignDetailViewController {
                destinationVC.item = sender as? Mobitem
            }
        } else if segue.identifier == CONSTANTS.SEGUE_STOREDETAIL {
            if let destinationVC = segue.destinationViewController as? StoreDetailViewController {
                destinationVC.item = sender as? Mobitem
            }
        } else if segue.identifier == CONSTANTS.SEGUE_MALLDETAIL {
            if let destinationVC = segue.destinationViewController as? MallDetailViewController {
                if let mall = sender as? Mall {
                    destinationVC.mall = mall
                }
            }
        }
    }
    
    // MARK: Pagingview Delegate Methods
    func pagingView(pagingView pagingView: PagingView, selectedIndex index: Int) {
        /*
         let alert = UIAlertController(title: "Bilgi", message: "Birşeye tıklandı.", preferredStyle: UIAlertControllerStyle.Alert)
         
         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
         
         self.presentViewController(alert, animated: true, completion: nil)
         */
        
        //self.performSegueWithData(pagingView.datas[index])
        self.pushViewControllerWithData(pagingView.datas[index])
        
    }
    
    
    
    // MARK: MKMapview Delegate Methods
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        /*
         if let loc = userLocation.location {
         centerMapOnLocation(loc)
         }
         */
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "reuse"
        var annotationView: MKAnnotationView?
        
        if annotation.isKindOfClass(CustomAnnotation) {
            
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView!.canShowCallout = true
            }
            else {
                annotationView!.annotation = annotation
            }
            
            let customPointAnnotation = annotation as! CustomAnnotation
            if let imageNamed = customPointAnnotation.imageNamed {
                annotationView!.image = UIImage(named: imageNamed)
            } else {
                annotationView!.image = UIImage(named: "pin_passive")
            }
            
            
            let accButton = MaterialButton(frame: CGRectMake(0.0, 0.0, self.annotationViewCalloutButtonHeight, self.annotationViewCalloutButtonHeight), imageNamed: "right_arrow")
            annotationView?.rightCalloutAccessoryView = accButton
            
            
        } else if annotation.isKindOfClass(MKUserLocation) {
            
        }
        return annotationView
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        view.image = UIImage(named: "pin_active")
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        view.image = UIImage(named: "pin_passive")
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // print("\(view.annotation)")
        if let customAnnotation = view.annotation as? CustomAnnotation {
            if customAnnotation.item != nil {
                
                //self.performSegueWithData(customAnnotation.item!)
                self.pushViewControllerWithData(customAnnotation.item!)
            }
        }
    }
    
    // MARK: Location Manager Delegate Methods
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            switch status {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                if self.mapRemoved {
                    //
                } else {
                    
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                    
                    
                    /*
                     self.requestNearestMalls({ () -> Void in
                     self.mapDataReturned = true
                     })
                     
                     */
                }
                
                self.mapDataReturned = true
                
                
            case .Denied:
                self.locationNotAllowed()
                self.mapDataReturned = true
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .Restricted:
                self.locationNotAllowed()
                self.mapDataReturned = true
            }
        } else {
            self.showActivateLocationBanner({ () -> Void in
                self.mapDataReturned = true
            })
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.userLocationUpdatedOnce {
            return
        }
        
        if let location = manager.location {
            let userLocation = location.coordinate
            
            print("locations = \(userLocation.latitude) \(userLocation.longitude)")
            
            
            self.requestNearestMalls(userLocation) { () -> Void in
            }
            
            self.userLocationUpdatedOnce = true
            
        }
    }
}






