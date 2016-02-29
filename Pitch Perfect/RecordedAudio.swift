//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Rodrigo Astorga on 2/25/16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl : NSURL, title : String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
