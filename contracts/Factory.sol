// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "@openzeppelin/contracts/proxy/Clones.sol";
import {IDCA} from "../contracts/interfaces/IDCA.sol";
import {ILogContract} from "../contracts/interfaces/ILogContract.sol";

contract DCAFactory {
    address public pancakeSwapRouter;
    address public singletonDCA;
    uint public strategyID;
    ILogContract public logContract;

    constructor(address _pancakeSwapRouter, address _singletonDCA, address _logContract) {
        pancakeSwapRouter = _pancakeSwapRouter;
        singletonDCA = _singletonDCA;
        logContract = ILogContract(_logContract);
    }

    struct StrategyDetails {
        uint id;
        address receiver;
        address sellToken;
        address buyToken;
        uint256 startTime;
        uint256 endTime;
        uint256 interval;
        uint256 amount;
        address swapRouter;
    }

    struct UserDetails {
        uint[] campaignID;
        address[] strategyAddress;
        StrategyDetails[] strategyDetails;
    }

    StrategyDetails[] public strategyInfo;
    mapping(address => UserDetails) userInfo;

    event CreateDCA(
        uint strategyID,
        address _owner,
        address _receiver,
        address _sellToken,
        address _buyToken,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _interval,
        uint256 _amount,
        address swapRouter
    );

    function createDCA(
        address _receiver,
        address _sellToken,
        address _buyToken,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _interval,
        uint256 _amount
    ) public {
        address clone = Clones.clone(singletonDCA);
        IDCA(clone).init(
            msg.sender,
            _receiver,
            _sellToken,
            _buyToken,
            _startTime,
            _endTime,
            _interval,
            _amount,
            pancakeSwapRouter
        );

        strategyInfo.push(
            StrategyDetails(
                strategyID,
                _receiver,
                _sellToken,
                _buyToken,
                _startTime,
                _endTime,
                _interval,
                _amount,
                pancakeSwapRouter
            )
        );

        userInfo[msg.sender].campaignID.push(strategyID);
        emit CreateDCA(
            strategyID,
            msg.sender,
            _receiver,
            _sellToken,
            _buyToken,
            _startTime,
            _endTime,
            _interval,
            _amount,
            pancakeSwapRouter
        );

        logContract.logInit(clone, msg.sender, _receiver, _sellToken, _buyToken, _startTime, _endTime, _interval, _amount);
        
        strategyID++;
    }
}
