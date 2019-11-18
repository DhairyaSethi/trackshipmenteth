pragma solidity ^0.4.16;

contract BlockTracking {
    // state variables
    address shipper;
    enum OrderStatus { labelCreated, outForDelivery, delivered, notDelivered }

    struct Tracking {
        address provider;
        address recipient;
        string time;
        string notes;
        OrderStatus orderStatus;
    }
    mapping (uint256 => Tracking) public trackers;
    
    //log
    event OrderUpdate(uint256 trackingNo, address _from, address _to, OrderStatus _currentStatus, string notes, string _time);
    
    constructor() public {shipper = msg.sender;}
   
    function newOrder(uint256 _trackingNo, address _recipient, string _notes, string _time) public {
        if (msg.sender != shipper) revert();
        if (trackers[_trackingNo].recipient != 0) revert();
        trackers[_trackingNo] = Tracking(
            shipper,
            _recipient, 
            _time, 
            _notes, 
            OrderStatus.labelCreated);
        
        emit OrderUpdate(
            _trackingNo,
            shipper,
            _recipient, 
            OrderStatus.labelCreated, 
            _notes, 
            _time);
    }
    
    function updateOrder(uint256 _trackingNo, uint _newStatus, string _notes, string _time) public returns (bool) {
        if (msg.sender != shipper) revert();
        if (trackers[_trackingNo].recipient == 0) revert();
        trackers[_trackingNo].orderStatus = OrderStatus(_newStatus);
        trackers[_trackingNo].notes = _notes;
        trackers[_trackingNo].time = _time;
        emit OrderUpdate(
            _trackingNo, 
            shipper,
            trackers[_trackingNo].recipient, 
            trackers[_trackingNo].orderStatus, 
            trackers[_trackingNo].notes, 
            trackers[_trackingNo].time);
        return true;
    }

    function getOrder(uint256 _trackingNo) public view returns (uint256 a, address b, address c, string d, string e, OrderStatus f) {
        if (trackers[_trackingNo].recipient == 0) revert();
        if (trackers[_trackingNo].recipient != msg.sender && msg.sender != shipper) revert();
        a = _trackingNo;
        b = trackers[_trackingNo].provider;
        c = trackers[_trackingNo].recipient;
        d = trackers[_trackingNo].notes;
        e = trackers[_trackingNo].time;
        f = trackers[_trackingNo].orderStatus;
    }
}
