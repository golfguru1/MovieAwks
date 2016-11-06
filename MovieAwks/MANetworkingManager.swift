//
//  MANetworkingManager.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import Alamofire
    
let API_KEY = "05fb742d973ead23b8c11c9d46e53260"

//SEARCH: https://api.themoviedb.org/3/search/movie?api_key=05fb742d973ead23b8c11c9d46e53260&query=ant man&page=1
//IMAGE: http://image.tmdb.org/t/p/w300/t2AvtK0jS8MwAsVzgwbG6fvaaH0.jpg



func searchForMovieWithName(_ name:String, page:Int = 1, completion:@escaping (_ response:AnyObject) ->Void) {
    Alamofire.request(URL(string: "https://api.themoviedb.org/3/search/movie")!, method: .get, parameters:["api_key" : API_KEY, "query" : name, "page": page]).responseJSON {
        response in
//        print(response.request)  // original URL request
//        print(response.response) // URL response
//        print(response.result.value)
//        print(response.result)   // result of response serialization
        
        if (response.result.isSuccess){
            if let JSON = response.result.value {
                if let dict = JSON as? Dictionary<String, AnyObject> {
                    completion(parseMovieResult(dict) as AnyObject)
                }
            }
        }
        else{
            completion(response.result.error! as AnyObject)
        }

    }
}

func parseMovieResult(_ JSON:Dictionary<String, AnyObject>) -> Array<MAMovie> {
    var movies = Array<MAMovie>()
    
    if let results = JSON["results"] as? Array<Dictionary<String, AnyObject>> {
        for dict in results {
            movies.append(MAMovie.init(dict: dict))
        }
    }
    
    return movies
}

func genres(_ completion:@escaping (_ response:AnyObject) ->Void)  {
    
    var returnDict = Dictionary<NSNumber, String>()
    Alamofire.request(URL(string: "http://api.themoviedb.org/3/genre/movie/list")!, method: .get, parameters:["api_key" : API_KEY]).responseJSON {
        response in
        if (response.result.isSuccess){
            if let JSON = response.result.value {
                if let dict = JSON as? Dictionary<String, AnyObject> {
                    if let genresDict = dict["genres"] as? Array<Dictionary<String,AnyObject>> {
                        for genre in genresDict {
                            let id = genre["id"] as! NSNumber
                            returnDict[id] = genre["name"] as? String
                        }
                        completion(returnDict as AnyObject)
                    }
                }
            }
        }
        let error = NSError.init(domain: "MA", code: 1, userInfo: ["description": "genre error"])
        completion(error as AnyObject)
    }
    
}
