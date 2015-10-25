//
//  ViewController.swift
//  Random User
//
//  Created by Joan Nadal Brotat on 25/10/2015.
//  Copyright © 2015 Joan Nadal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var picture: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var email_address: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let default_picture_url = NSURL(string: String("https://placeholdit.imgix.net/~text?txtsize=24&txt=User%20Image&w=150&h=150"))
        if let data = NSData(contentsOfURL: default_picture_url!){
            picture.contentMode = UIViewContentMode.ScaleAspectFit
            picture.image = UIImage(data: data)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setValues(user: JSON) {
        let picture_url = NSURL(string: String(user["picture"]["thumbnail"]))
        if let data = NSData(contentsOfURL: picture_url!){
            self.picture.contentMode = UIViewContentMode.ScaleAspectFit
            self.picture.image = UIImage(data: data)
        }
        
        let fullName = String(user["name"]["first"]).capitalizedString + " " + String(user["name"]["last"]).capitalizedString
        self.name.text = fullName
        self.email_address.text = String(user["email"])
        self.username.text = String(user["username"])
        self.gender.text = String(user["gender"]).capitalizedString
        let fullLocation = String(user["location"]["city"]).capitalizedString + ", " + String(user["location"]["state"]).capitalizedString
        self.location.text = fullLocation
        self.phone.text = String(user["phone"])
        
        self.activityIndicator.stopAnimating()
    }

    @IBAction func getRandomUser(sender: AnyObject) {
        activityIndicator.startAnimating()
        RestApiManager.sharedInstance.getRandomUser { json in
            let results = json["results"]
            for (_, subJson):(String, JSON) in results {
                let user: AnyObject = subJson["user"].object
                self.setValues(JSON(user))
            }
        }
    }

}

