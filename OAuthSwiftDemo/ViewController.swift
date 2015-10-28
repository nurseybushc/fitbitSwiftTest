//
//  ViewController.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/21/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //added to store oauth stuff
    enum oauthKeys {
        static let oauth_token = ""
        static let oauth_token_secret = ""
    }
    //oauth stuff
    var oauth_token = ""
    var oauth_token_secret = ""
    
    var services = ["Twitter", "Flickr", "Github", "Instagram", "Foursquare", "Fitbit", "Withings", "Linkedin", "Linkedin2", "Dropbox", "Dribbble", "Salesforce", "BitBucket", "GoogleDrive", "Smugmug", "Intuit", "Zaim", "Tumblr", "Slack", "Uber"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "OAuth"
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func doOAuthTwitter(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Twitter["consumerKey"]!,
            consumerSecret: Twitter["consumerSecret"]!,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        //oauthswift.authorize_url_handler = WebViewController()
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/twitter")!, success: {
            credential, response in
            self.showAlertView("Twitter", message: "auth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            let parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/mentions_timeline.json", parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    print(error)
                })
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
            }
        )
    }

    func doOAuthFlickr(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Flickr["consumerKey"]!,
            consumerSecret: Flickr["consumerSecret"]!,
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/flickr")!, success: {
            credential, response in
            self.showAlertView("Flickr", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            let url :String = "https://api.flickr.com/services/rest/"
            let parameters :Dictionary = [
                "method"         : "flickr.photos.search",
                "api_key"        : Flickr["consumerKey"]!,
                "user_id"        : "128483205@N08",
                "format"         : "json",
                "nojsoncallback" : "1",
                "extras"         : "url_q,url_z"
            ]
            oauthswift.client.get(url, parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    print(error)
            })
        }, failure: {(error:NSError!) -> Void in
            print(error.localizedDescription)
        })
    }

    func doOAuthGithub(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Github["consumerKey"]!,
            consumerSecret: Github["consumerSecret"]!,
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "code"
        )
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/github")!, scope: "user,repo", state: state, success: {
            credential, response, parameters in
            self.showAlertView("Github", message: "oauth_token:\(credential.oauth_token)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
            })
    }
    func doOAuthSalesforce(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Salesforce["consumerKey"]!,
            consumerSecret: Salesforce["consumerSecret"]!,
            authorizeUrl:   "https://login.salesforce.com/services/oauth2/authorize",
            accessTokenUrl: "https://login.salesforce.com/services/oauth2/token",
            responseType:   "code"
        )
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/salesforce")!, scope: "full", state: state, success: {
            credential, response, parameters in
            self.showAlertView("Salesforce", message: "oauth_token:\(credential.oauth_token)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }

    func doOAuthInstagram(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Instagram["consumerKey"]!,
            consumerSecret: Instagram["consumerSecret"]!,
            authorizeUrl:   "https://api.instagram.com/oauth/authorize",
            responseType:   "token"
        )

        let state: String = generateStateWithLength(20) as String
        oauthswift.authorize_url_handler = WebViewController()
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/instagram")!, scope: "likes+comments", state:state, success: {
            credential, response, parameters in
            self.showAlertView("Instagram", message: "oauth_token:\(credential.oauth_token)")
            let url :String = "https://api.instagram.com/v1/users/1574083/?access_token=\(credential.oauth_token)"
            let parameters :Dictionary = Dictionary<String, AnyObject>()
            oauthswift.client.get(url, parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    print(error)
            })
        }, failure: {(error:NSError!) -> Void in
            print(error.localizedDescription)
        })
    }

    func doOAuthFoursquare(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Foursquare["consumerKey"]!,
            consumerSecret: Foursquare["consumerSecret"]!,
            authorizeUrl:   "https://foursquare.com/oauth2/authorize",
            responseType:   "token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/foursquare")!, scope: "", state: "", success: {
            credential, response, parameters in
            self.showAlertView("Foursquare", message: "oauth_token:\(credential.oauth_token)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
            })
    }
    func doOAuthFitbit(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if(self.oauth_token == ""){
        let oauthswift = OAuth1Swift(
            consumerKey: "53d18edc9d4335901db8290c29e0a576",
            consumerSecret:"b84d0bd78d01ac9d73b417be5194af4b",
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize?display=touch",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/fitbit")!, success: {
            credential, response in
            self.showAlertView("Fitbit", message: "oauth_token:\(credential.oauth_token)\n\noauth_token_secret:\(credential.oauth_token_secret)")
            self.oauth_token = credential.oauth_token
            self.oauth_token_secret = credential.oauth_token_secret
            //print(credential.oauth_verifier)
            //oauth stuff start
            //let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(credential.oauth_token, forKey: oauthKeys.oauth_token)
            defaults.setValue(credential.oauth_token_secret, forKey: oauthKeys.oauth_token_secret)
            defaults.synchronize()
            //oath stuff end
            
            let parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.fitbit.com/1/user/-/profile.json", parameters: parameters,
                success: {
                    data, response in
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(dataString)
                }, failure: {(error:NSError!) -> Void in
                    print(error)
            })
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })} else {
            self.showAlertView("Fitbit", message: "oauth_token:\(oauth_token)\n\noauth_token_secret:\(oauth_token_secret)")
            //let defaults = NSUserDefaults.standardUserDefaults()
            print(defaults.stringForKey(oauthKeys.oauth_token))
            print(defaults.stringForKey(oauthKeys.oauth_token_secret))
        }
    }
    func doOAuthFitbit2(){
        //https://dev.fitbit.com/docs/oauth2/
        if (self.oauth_token == ""){
        let oauthswift = OAuth2Swift(
            consumerKey: "53d18edc9d4335901db8290c29e0a576",
            //client_id:"229V2G",//oauth2 required
            consumerSecret:"b84d0bd78d01ac9d73b417be5194af4b",
            //requestTokenUrl: "https://api.fitbit.com/oauth/request_token",//oauth1
            //authorizeUrl:    "https://www.fitbit.com/oauth/authorize?display=touch",//oauth1
            authorizeUrl: "https://www.fitbit.com/oauth2/authorize?display=touch",
            //accessTokenUrl:  "https://api.fitbit.com/oauth/access_token",//oauth1
            accessTokenUrl: "https://api.fitbit.com/oauth2/token",
            responseType:"code"//oauth2 required, "code" for authorization, "token" for implicit grant
        )
        let state: String = generateStateWithLength(20) as String//oauth2 required
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/fitbit")!,
            scope: "profile",//oauth2 required, can be "activity", "sleep", "social" etc.
            state: state,//oauth2 required
            success: {
            credential, response, parameters in //oauth2 requires "parameters"
            self.showAlertView("Fitbit", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            self.oauth_token = credential.oauth_token
            self.oauth_token_secret = credential.oauth_token_secret
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
        } else {
            self.showAlertView("Fitbit", message: "oauth_token:\(oauth_token)\n\noauth_token_secret:\(oauth_token_secret)")
            /*Alamofire.request(.GET, "https://api.fitbit.com/1/user/-/activities/date/today.json")
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }*/
        }
    }

    func doOAuthWithings(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Withings["consumerKey"]!,
            consumerSecret: Withings["consumerSecret"]!,
            requestTokenUrl: "https://oauth.withings.com/account/request_token",
            authorizeUrl:    "https://oauth.withings.com/account/authorize",
            accessTokenUrl:  "https://oauth.withings.com/account/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/withings")!, success: {
            credential, response in
            self.showAlertView("Withings", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }

    func doOAuthLinkedin(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Linkedin["consumerKey"]!,
            consumerSecret: Linkedin["consumerSecret"]!,
            requestTokenUrl: "https://api.linkedin.com/uas/oauth/requestToken",
            authorizeUrl:    "https://api.linkedin.com/uas/oauth/authenticate",
            accessTokenUrl:  "https://api.linkedin.com/uas/oauth/accessToken"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/linkedin")!, success: {
            credential, response in
            self.showAlertView("Linkedin", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            let parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.linkedin.com/v1/people/~", parameters: parameters,
                    success: {
                        data, response in
                        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        print(dataString)
                    }, failure: {(error:NSError!) -> Void in
                print(error)
            })
        }, failure: {(error:NSError!) -> Void in
            print(error.localizedDescription)
        })
    }

    func doOAuthLinkedin2(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Linkedin2["consumerKey"]!,
            consumerSecret: Linkedin2["consumerSecret"]!,
            authorizeUrl:   "https://www.linkedin.com/uas/oauth2/authorization",
            accessTokenUrl: "https://www.linkedin.com/uas/oauth2/accessToken",
            responseType:   "code"
        )
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "http://oauthswift.herokuapp.com/callback/linkedin2")!, scope: "r_fullprofile", state: state, success: {
            credential, response, parameters in
            self.showAlertView("Linkedin2", message: "oauth_token:\(credential.oauth_token)")
            let parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.linkedin.com/v1/people/~?format=json", parameters: parameters,
                success: {
                    data, response in
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(dataString)
                }, failure: {(error:NSError!) -> Void in
                    print(error)
            })
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }

    func doOAuthSmugmug(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Smugmug["consumerKey"]!,
            consumerSecret: Smugmug["consumerSecret"]!,
            requestTokenUrl: "http://api.smugmug.com/services/oauth/getRequestToken.mg",
            authorizeUrl:    "http://api.smugmug.com/services/oauth/authorize.mg",
            accessTokenUrl:  "http://api.smugmug.com/services/oauth/getAccessToken.mg"
        )
        oauthswift.allowMissingOauthVerifier = true
        // NOTE: Smugmug's callback URL is configured on their site and the one passed in is ignored.
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/smugmug")!, success: {
            credential, response in
            self.showAlertView("Smugmug", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
        }, failure: {(error:NSError!) -> Void in
            print(error.localizedDescription)
        })
    }

    func doOAuthDropbox(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Dropbox["consumerKey"]!,
            consumerSecret: Dropbox["consumerSecret"]!,
            authorizeUrl:   "https://www.dropbox.com/1/oauth2/authorize",
            accessTokenUrl: "https://api.dropbox.com/1/oauth2/token",
            responseType:   "token"
        )
        oauthswift.authorize_url_handler = WebViewController()
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/dropbox")!, scope: "", state: "", success: {
            credential, response, parameters in
            self.showAlertView("Dropbox", message: "oauth_token:\(credential.oauth_token)")
            // Get Dropbox Account Info
            let parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.dropbox.com/1/account/info?access_token=\(credential.oauth_token)", parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    print(error)
                })
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }

    func doOAuthDribbble(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Dribbble["consumerKey"]!,
            consumerSecret: Dribbble["consumerSecret"]!,
            authorizeUrl:   "https://dribbble.com/oauth/authorize",
            accessTokenUrl: "https://dribbble.com/oauth/token",
            responseType:   "code"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/dribbble")!, scope: "", state: "", success: {
            credential, response, parameters in
            self.showAlertView("Dribbble", message: "oauth_token:\(credential.oauth_token)")
            // Get User
            let parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.dribbble.com/v1/user?access_token=\(credential.oauth_token)", parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    print(error)
                })
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }

	func doOAuthBitBucket(){
		let oauthswift = OAuth1Swift(
			consumerKey:    BitBucket["consumerKey"]!,
			consumerSecret: BitBucket["consumerSecret"]!,
			requestTokenUrl: "https://bitbucket.org/api/1.0/oauth/request_token",
			authorizeUrl:    "https://bitbucket.org/api/1.0/oauth/authenticate",
			accessTokenUrl:  "https://bitbucket.org/api/1.0/oauth/access_token"
		)
		oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/bitbucket")!, success: {
			credential, response in
			self.showAlertView("BitBucket", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
			let parameters =  Dictionary<String, AnyObject>()
			oauthswift.client.get("https://bitbucket.org/api/1.0/user", parameters: parameters,
				success: {
					data, response in
					let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(dataString)
				}, failure: {(error:NSError!) -> Void in
					print(error)
			})
			}, failure: {(error:NSError!) -> Void in
				print(error.localizedDescription)
		})
	}
    func doOAuthGoogle(){
        let oauthswift = OAuth2Swift(
            consumerKey:    GoogleDrive["consumerKey"]!,
            consumerSecret: GoogleDrive["consumerSecret"]!,
            authorizeUrl:   "https://accounts.google.com/o/oauth2/auth",
            accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
            responseType:   "code"
        )
        // For googgle the redirect_uri should match your this syntax: your.bundle.id:/oauth2Callback
        // in plist define a url schem with: your.bundle.id:
        oauthswift.authorizeWithCallbackURL( NSURL(string: "https://oauthswift.herokuapp.com/callback/google")!, scope: "https://www.googleapis.com/auth/drive", state: "", success: {
            credential, response, parameters in
            self.showAlertView("Google", message: "oauth_token:\(credential.oauth_token)")
            let parameters =  Dictionary<String, AnyObject>()
            // Multi-part upload
            oauthswift.client.postImage("https://www.googleapis.com/upload/drive/v2/files", parameters: parameters, image: self.snapshot(),
                success: {
                    data, response in
                    let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print("SUCCESS: \(jsonDict)")
                }, failure: {(error:NSError!) -> Void in
                    print(error)
            })
            }, failure: {(error:NSError!) -> Void in
                print("ERROR: \(error.localizedDescription)")
        })
    }

    func doOAuthIntuit(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Intuit["consumerKey"]!,
            consumerSecret: Intuit["consumerSecret"]!,
            requestTokenUrl: "https://oauth.intuit.com/oauth/v1/get_request_token",
            authorizeUrl:    "https://appcenter.intuit.com/Connect/Begin",
            accessTokenUrl:  "https://oauth.intuit.com/oauth/v1/get_access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/intuit")!, success: {
            credential, response in
            self.showAlertView("Intuit", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }
    func doOAuthZaim(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Zaim["consumerKey"]!,
            consumerSecret: Zaim["consumerSecret"]!,
            requestTokenUrl: "https://api.zaim.net/v2/auth/request",
            authorizeUrl:    "https://auth.zaim.net/users/auth",
            accessTokenUrl:  "https://api.zaim.net/v2/auth/access"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/zaim")!, success: {
            credential, response in
            self.showAlertView("Zaim", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }
    func doOAuthTumblr(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Tumblr["consumerKey"]!,
            consumerSecret: Tumblr["consumerSecret"]!,
            requestTokenUrl: "http://www.tumblr.com/oauth/request_token",
            authorizeUrl:    "http://www.tumblr.com/oauth/authorize",
            accessTokenUrl:  "http://www.tumblr.com/oauth/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/tumblr")!, success: {
            credential, response in
            self.showAlertView("Tumblr", message: "oauth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }
    func doOAuthSlack(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Slack["consumerKey"]!,
            consumerSecret: Slack["consumerSecret"]!,
            authorizeUrl:   "https://slack.com/oauth/authorize",
            accessTokenUrl: "https://slack.com/api/oauth.access",
            responseType:   "code"
        )
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/slack")!, scope: "", state: state, success: {
            credential, response, parameters in
            self.showAlertView("Slack", message: "oauth_token:\(credential.oauth_token)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription, terminator: "")
        })
    }

    func doOAuthUber(){
        let oauthswift = OAuth2Swift(
            consumerKey:    Uber["consumerKey"]!,
            consumerSecret: Uber["consumerSecret"]!,
            authorizeUrl:   "https://login.uber.com/oauth/authorize",
            accessTokenUrl: "https://login.uber.com/oauth/token",
            responseType:   "code",
            contentType:    "multipart/form-data"
        )
        let state: String = generateStateWithLength(20) as String
        let redirectURL = "https://oauthswift.herokuapp.com/callback/uber".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        oauthswift.authorizeWithCallbackURL( NSURL(string: redirectURL!)!, scope: "profile", state: state, success: {
            credential, response, parameters in
            self.showAlertView("Uber", message: "oauth_token:\(credential.oauth_token)")
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription, terminator: "")
        })
    }

    func snapshot() -> NSData {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
        return  UIImageJPEGRepresentation(fullScreenshot, 0.5)!
    }

    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return services.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = services[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let service: String = services[indexPath.row]
        switch service {
            case "Twitter":
                doOAuthTwitter()
            case "Flickr":
                doOAuthFlickr()
            case "Github":
                doOAuthGithub()
            case "Instagram":
                doOAuthInstagram()
            case "Foursquare":
                doOAuthFoursquare()
            case "Fitbit":
                //doOAuthFitbit2()
                doOAuthFitbit()
            case "Withings":
                doOAuthWithings()
            case "Linkedin":
                doOAuthLinkedin()
            case "Linkedin2":
                doOAuthLinkedin2()
            case "Dropbox":
                doOAuthDropbox()
            case "Dribbble":
                doOAuthDribbble()
            case "Salesforce":
                doOAuthSalesforce()
            case "BitBucket":
                doOAuthBitBucket()
            case "GoogleDrive":
                doOAuthGoogle()
            case "Smugmug":
                doOAuthSmugmug()
            case "Intuit":
                doOAuthIntuit()
            case "Zaim":
                doOAuthZaim()
            case "Tumblr":
                doOAuthTumblr()
            case "Slack":
                doOAuthSlack()
            case "Uber":
                doOAuthUber()
            default:
                print("default (check ViewController tableView)")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
}
