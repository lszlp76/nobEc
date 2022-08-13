//
//  ModifyActivityController.swift
//  travelguide
//
//  Created by ulas özalp on 11.08.2022.
//

import LinkPresentation

class MyActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String
    var icon : UIImage?
    
    init(title: String, text: String, icon : UIImage?) {
        self.title = title
        self.text = text
        self.icon = icon
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return text
    }
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
       
        return icon
    }
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        
        metadata.imageProvider = NSItemProvider(object: icon as! NSItemProviderWriting)
        
       // metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "text.bubble")!)
        //This is a bit ugly, though I could not find other ways to show text content below title.
        //https://stackoverflow.com/questions/60563773/ios-13-share-sheet-changing-subtitle-item-description
        //You may need to escape some special characters like "/".
        metadata.originalURL = URL(fileURLWithPath: text)
        return metadata
    }

}
