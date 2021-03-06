//
//  Article.swift
//  NewsLater
//
//  Created by University of Missouri on 4/16/15.
//  Copyright (c) 2015 Matt Zuzolo. All rights reserved.
//

import Foundation
//import ObjectMapper


//Base Article Object
class Article: NSObject, NSCoding {
    var headline: String?
    var publication: String?
    var byline: String?
    var publishedDate: NSString?
    let receivedDate: NSDate = NSDate()
    var url: NSString?
    var thumbnailUrl: NSURL? //Points to the Thumbnail object
    var tags: Set<NSString>?
    
    init(headline: String?, publication: String?, byline: String?, publishedDate: NSString?, url: NSString?, thumbnailUrl: NSURL?, tags: Set<NSString>){
        self.headline = headline
        self.publication = publication
        self.byline = byline
        self.publishedDate = publishedDate
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.tags = tags
        //self.receivedDate = NSDate()
    }

    required init(coder aDecoder: NSCoder) {
        super.init()
        self.headline = aDecoder.decodeObjectForKey("headline") as! String?
        self.publication = aDecoder.decodeObjectForKey("publication") as! String?
        self.byline = aDecoder.decodeObjectForKey("byline") as! String?
        self.publishedDate = aDecoder.decodeObjectForKey("publishedDate") as! NSString?
        self.url = aDecoder.decodeObjectForKey("url") as! NSString?
        self.thumbnailUrl = aDecoder.decodeObjectForKey("thumbnailUrl") as! NSURL?
        self.tags = aDecoder.decodeObjectForKey("tags") as? Set<NSString>
        //self.receivedDate = aDecoder.decodeObjectForKey("receivedDate") as! NSDate
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.headline, forKey: "headline")
        aCoder.encodeObject(self.publication, forKey: "publication")
        aCoder.encodeObject(self.byline, forKey: "byline")
        aCoder.encodeObject(self.publishedDate, forKey: "publishedDate")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.thumbnailUrl, forKey: "thumbnailUrl")
        aCoder.encodeObject(self.tags, forKey: "tags")
        aCoder.encodeObject(self.receivedDate, forKey: "receivedDate")

    }
    
    func getTimeSincePublished(formatter: NSDateFormatter) -> NSTimeInterval{
        let date = formatter.dateFromString(publishedDate!.description)
        
        if (date == nil){
            return 0
        }
        
        return date!.timeIntervalSinceNow
    }
    
    func printTimeInterval(formatter: NSDateFormatter) -> String{
        let interval = getTimeSincePublished(formatter)
        
        return intervalToOffset(interval)
    }
    
    func intervalToOffset(interval: NSTimeInterval) -> String{
        var retStr = ""
        var intervalCpy = interval
        
        let years = floor(intervalCpy / 31536000)
        intervalCpy -= years * 31536000
        let months = floor(intervalCpy / 2592000)
        intervalCpy -= months * 2592000
        let days = floor(intervalCpy / 86400)
        intervalCpy -= days * 86400
        let hours = floor(intervalCpy / 3600)
        intervalCpy -= hours * 3600
        let min = intervalCpy / 60
        intervalCpy -= min * 60
        
        if (days > 0){
            retStr += "\(Int(days)) d"
        }
        else{
            if (hours > 0){
                retStr += " \(Int(hours)) h"
            }
            
            if (min > 0){
                retStr += " \(Int(min)) m"
            }
        }
        
        return retStr
    }
}

