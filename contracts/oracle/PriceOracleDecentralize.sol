pragma solidity ^0.5.0;
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin//contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "./OracleCallerInterface.sol";

contract PriceOracleDecentralize {

    using Roles for Roles.Role;
    using SafeMath for uint256;
    Roles.Role owners;
    Roles.Role oracles;
    uint public threshold = 3;
    struct Response {
        uint256 ethPrice;
        address callerAddress;
        address oracleAddress;
    }

    mapping(uint256 => Response[]) requestIdToResponse;
    mapping(uint256 => bool) pendingRequests;

    uint randNonce = 0;
    uint countOracles = 0;

    event GetLatestEthPrice(address caller, uint id);
    event AddOracle(address oracle);
    event SetThreshold(uint threshold);
    event RemoveOracle(address oracle);
    event SetLatestEthPrice(uint256 price, uint256 id, address caller);

    constructor(address _owner) public {
        owners.add(_owner);
    }

    modifier onlyOwner() {
        require(owners.has(msg.sender), "only for owner");
        _;
    }

    function addOracle(address _oracle) external onlyOwner{
        // require(owners.has(msg.sender), "only for owner");
        require(!oracles.has(_oracle), "already has this oracle");
        countOracles++;
        oracles.add(_oracle);
        emit AddOracle(_oracle);
    }

    function removeOracle(address _oracle) external onlyOwner{
        // require(owners.has(msg.sender), "only for owner");
        require(oracles.has(_oracle), "no this oracle");
        require(countOracles > 1, "at least one oracle");
        countOracles--;
        oracles.remove(_oracle);
        emit RemoveOracle(_oracle);
    }

    function setThreshold(uint _threshold) external onlyOwner{
        // require(owners.has(msg.sender), "only for owner");
        threshold = _threshold;
        emit SetThreshold(_threshold);
    }

    function getLatestEthPrice() public returns (uint) {
        randNonce++;
        uint id = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100000;
        pendingRequests[id] = true;
        emit GetLatestEthPrice(msg.sender, id);
        return id;
    }

    function setLatestEthPrice(uint256 _price, address _caller, uint256 _id) public {
        require(oracles.has(msg.sender), "only for oracle");
        require(pendingRequests[_id], "should in pending requests");
        Response memory resp;
        resp = Response(_price, _caller, msg.sender);
        requestIdToResponse[_id].push(resp);

        if (requestIdToResponse[_id].length == threshold){
            uint256 sum_price = 0;
            for(uint i = 0; i < threshold; i++){
                sum_price = sum_price.add(requestIdToResponse[_id][i].ethPrice);
            }
            uint256 avg_price = sum_price.div(threshold);
            OracleCallerInterface caller = OracleCallerInterface(_caller);
            delete pendingRequests[_id];
            caller.callback(_id, avg_price);
            emit SetLatestEthPrice(avg_price, _id, _caller);
        }
        
    }
 
}
