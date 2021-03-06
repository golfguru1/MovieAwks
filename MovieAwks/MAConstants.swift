//
//  MAConstants.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import Foundation
import UIKit

//****************************************//
//              Segues
//****************************************//
let MA_CONTINUE_SIGN_UP_SEGUE = "MAContinueSignUpSegue"
let MA_SHOW_HOME_FROM_SIGN_UP_SEGUE = "MAShowHomeFromSignUpSegue"
let MA_SIGN_IN_SUCCESS_SEGUE = "MASignInSuccessSegue"
let MA_USER_ALREADY_LOGGED_IN_SEGUE = "MAUserAlreadyLoggedInSegue"
let MA_POST_REVIEW_SEGUE = "MAPostReviewSegue"
let MA_SIGN_IN_SEGUE = "MASignInSegue"
let MA_SEE_REVIEWS_SEGUE = "MASeeReviewsSegue"

//****************************************//
//              TableViewCells
//****************************************//
let MA_MOVIE_SEARCH_CELL = "MAMovieSearchCell"
let MA_REVIEW_TABLE_VIEW_CELL = "MAReviewTableViewCell"

var genresDict = Dictionary<NSNumber, String>()

func getGenres() {
    genres { (response) in
        if response is NSError {
            
        }
        else {
            genresDict = response as! Dictionary<NSNumber, String>
        }
    }
}

func emojiForRating(_ rating: CGFloat) -> String{
    if (rating < 0) {
        return "-"
    }
    else if (rating < 2) {
        return "😇"
    }
    else if (rating < 4) {
        return "😐"
    }
    else if (rating < 6) {
        return "😔"
    }
    else if (rating < 8) {
        return "😬"
    }
    else if (rating < 10) {
        return "😵"
    }
    return "💀"
}

extension UIImage {
    func averageColor() -> UIColor {
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)!
        
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        if rgba[3] > 0 {
            
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
            
        } else {
            
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
}

extension UIColor {

    func invertColor() -> UIColor {
        let rgb = self.rgb()
        let newRed = CGFloat.init((255.0-Double((rgb?.red)!)) / 255.0)
        let newGreen = CGFloat.init((255.0-Double((rgb?.green)!)) / 255.0)
        let newBlue = CGFloat.init((255.0-Double((rgb?.blue)!)) / 255.0)
        
        return UIColor.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat.init((rgb?.alpha)!))
        
    }
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    func isDark() -> Bool {
        let rgb = self.rgb()
        let brightness = (((rgb?.red)!*299+(rgb?.green)!*587)+(rgb?.blue)!*114)
        return (brightness < 50000)
    }
    
    static func maPurple() -> UIColor {
        return UIColor.init(red: 64/255.0, green: 0/255.0, blue:178/255.0, alpha:1.0)
    }
    
    static func maOrange() -> UIColor {
        return UIColor.init(red: 255/255.0, green: 167/255.0, blue:68/255.0, alpha:1.0)
    }
    
    static func maBlack() ->UIColor {
        return UIColor.init(red: 0/255.0, green: 30/255.0, blue:52/255.0, alpha:1.0)
    }
}
