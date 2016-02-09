public class Url: Object {
    
    //MARK: Properties
    private(set) public var url: NSURL
    
    //MARK: Initializations
    init(url: NSURL, signalStrength: Beacon.SignalStrength, identifier: String) {
        self.url = url

        super.init(signalStrength: signalStrength, identifier: url.absoluteString + identifier)
    }
    
}