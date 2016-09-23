//
//  ViewController.swift
//  ISSLayout
//
//  Created by Tobias Löfstrand on 2015-05-01.
//  Copyright (c) 2015 Leafnode. All rights reserved.
//

import UIKit
import InterfaCSS

class ViewController: UIViewController {

    // Properties auto populated by ISSViewBuilder (when using elementId):
    var button: UIButton?
    var label: UILabel?
    var rootView:ISSLayoutContextView?
    
    var backgroundImageView:UIImageView?;
    var iconImageView:UIImageView?;
    var temperatureLabel:UILabel?;
    var phenomenaLabel:UILabel?;
    var pm25Label:UILabel?;
    var airqualityLabel:UILabel?;
    
    var goodAirBtn: UIButton?
    var badAirBtn: UIButton?
    
    var buttonCenterLayoutValueDefault : CGFloat?
    
    var weatherData : [String:AnyObject]?
    
    
    override func loadView() {
        // Setup view hierarchy - two options available:
        
        
        // *** OPTION 1 - Using view builder and layout specified in stylesheet ***
        /*InterfaCSS.sharedInstance().loadStyleSheetFromMainBundleFile("layout.css")
        self.view = ISSViewBuilder.rootViewWithId("rootView", withOwner: self, andSubViews: {
            return [
                ISSViewBuilder.labelWithId("marginLabel"),
                ISSViewBuilder.labelWithId("layoutGuideLabel"),
                
                ISSViewBuilder.viewOfClass(UIButton.self, withId: "button"),
                ISSViewBuilder.viewWithId("view1"),
                ISSViewBuilder.viewWithId("view2"),
                ISSViewBuilder.viewWithId("view3"),
                ISSViewBuilder.viewWithId("view4"),
                ISSViewBuilder.labelWithId("label")
            ];
        })*/
        
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("weather", ofType: "json")!);
        do{
        let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: UInt(0)));
            self.weatherData = dict as? [String : AnyObject];
        }
        catch(_){}
        
        // *** OPTION 2 - Load both view hierachy and layout from a view definition file ('layout.xml') ***
        self.view = ISSViewBuilder.loadViewHierarchyFromMainBundleFile("weather.xml", fileOwner: self);
            
            self.rootView = self.view as! ISSRootView;

/*
        if let b = button {
            // Initialize default value for layout attribute that we'll need later
            b.applyStylingISS() // Make sure styling has been applied first (only really needed for option 1)
            self.buttonCenterLayoutValueDefault = b.layoutISS.valueForLayoutAttribute(.CenterY).constant
            
            b.setTitle("Tap Me", forState: .Normal)
            b.addTarget(self, action: "moveMe", forControlEvents: .TouchDown)
        }
        if let l = label {
            l.text = "Hello ISSLayout World!"
        }
*/

        // Example of how additional layout pre/post processing / validation / customization can be applied:
        if let layoutContextView = self.rootView {
            // Example of pre processing block, to customize layout before it's applied to view (in this case, used to adjust layout attribute value based on active class):
            layoutContextView.layoutPreProcessingBlock = { (view: UIView!, layout: ISSLayout!) -> Void in
                if view.elementIdISS == "button" {
                    if view.hasStyleClassISS("moveMe") {
                        layout.valueForLayoutAttribute(.CenterY).constant = 100
                    } else {
                        layout.valueForLayoutAttribute(.CenterY).constant = self.buttonCenterLayoutValueDefault!
                    }
                }
                
                if let dict = self.weatherData {
                    if(view.isKindOfClass(UIImageView)){
                        let iv:UIImageView = view as! UIImageView;
                        //iv.image = nil;
                    }
                    if(view.isKindOfClass(UILabel)){
                        let label:UILabel = view as! UILabel;
                        let info = dict[view.elementIdISS!];
                        
                        if let text = info as? String {
                            label.text = text;
                        }
                        if let text = info as? Int {
                            label.text = String(format: "%lu", text);
                        }
                    }
                }
            }
            // Example of post processing block, using class function
            layoutContextView.layoutPostProcessingBlock = ViewController.layoutPostProcessingBlock
        }
        
        
        if let b = self.goodAirBtn {
            b.addTarget(self, action: #selector(ViewController.goodAir(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        if let b = self.badAirBtn {
            b.addTarget(self, action: #selector(ViewController.badAir(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func goodAir(sender:UIButton){
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("weather2", ofType: "json")!);
        do{
            let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: UInt(0)));
            self.weatherData = dict as? [String : AnyObject];
        }
        catch(_){}
        
        if let _ = self.weatherData {
            self.view.setNeedsLayout()
        }
    }
    
    func badAir(sender:UIButton){
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("weather", ofType: "json")!);
        do{
            let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: UInt(0)));
            self.weatherData = dict as? [String : AnyObject];
        }
        catch(_){}
        if let _ = self.weatherData {
            self.view.setNeedsLayout()
        }
    }
    
    // Class function used as layout post processing block, to customize frame after layoyt has been applied (in this case, to calculate some custom weird frame value for view4):
    class func layoutPostProcessingBlock(view: UIView!, layout: ISSLayout!) {
        if view.elementIdISS == "view4" {
            let vf = view.frame
            if vf.origin.y > (UIScreen.mainScreen().bounds.size.height * 2 / 3) {
                view.frame = CGRectMake(vf.origin.x - vf.size.width, vf.origin.y - vf.size.height, vf.size.width, vf.size.height)
            }
        }
    }
    
    // Action handler method for button
    func moveMe() {
        let hasClass: Bool = self.button?.hasStyleClassISS("moveMe") as Bool!
        
        UIView.animateWithDuration(0.3, delay: 0, options: [.BeginFromCurrentState, .LayoutSubviews], animations: { () -> Void in
            if( hasClass ) {
                self.button?.removeStyleClassISS("moveMe")
            } else {
                self.button?.addStyleClassISS("moveMe")
            }
            self.button?.applyStylingISS()
            // Force re-layout of root view:
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
