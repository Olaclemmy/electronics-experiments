public class Object: Equatable {
    
    //MARK: Properties
    /// The signal strength of the nearby entity
    private(set) public var signalStrength: Beacon.SignalStrength
    /// A unique identifier for the beacon
    private(set) public var identifier: String
    /// The percent battery left on the beacon
    private(set) public var battery: Double?
    /// The temperature of the beacon in degrees Celsius
    private(set) public var temperature: Double?
    /// The amount of packets the beacon has sent
    private(set) public var advertisementCount: Int?
    /// The amount of time the beacon has been on in seconds
    private(set) public var onTime: NSTimeInterval?
    
    //MARK: Initilizations
    init (signalStrength: Beacon.SignalStrength, identifier: String) {
        self.signalStrength = signalStrength
        self.identifier = identifier
    }
    
    func parseTlmFrame(frame: TlmFrame) {
        self.battery = Object.batteryLevelInPercent(frame.batteryVolts)
        self.temperature = frame.temperature
        self.advertisementCount = frame.advertisementCount
        self.onTime = NSTimeInterval(frame.onTime / 10)
    }
    
    //MARK: Class
    class func batteryLevelInPercent(mvolts: Int) -> Double
    {
        var batteryLevel: Double
        let mvoltsDouble = Double(mvolts)
        
        if (mvolts >= 3000) {
            batteryLevel = 100
        } else if (mvolts > 2900) {
            batteryLevel = 100 - ((3000 - mvoltsDouble) * 58) / 100
        } else if (mvolts > 2740) {
            batteryLevel = 42 - ((2900 - mvoltsDouble) * 24) / 160
        } else if (mvolts > 2440) {
            batteryLevel = 18 - ((2740 - mvoltsDouble) * 12) / 300
        } else if (mvolts > 2100) {
            batteryLevel = 6 - ((2440 - mvoltsDouble) * 6) / 340
        } else {
            batteryLevel = 0
        }
        
        return batteryLevel
    }
    
}

public func ==(lhs: Object, rhs: Object) -> Bool {
    return lhs.identifier == rhs.identifier
}