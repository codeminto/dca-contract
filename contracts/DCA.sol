// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BokkyPooBahsDateTimeLibrary} from "../contracts/lib/BokkyPooBahsDateTimeLibrary.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../contracts/interfaces/IUniswapV2Router.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {ILogContract} from "../contracts/interfaces/ILogContract.sol";

contract DCA is Initializable {
    using SafeERC20 for IERC20;

    address public owner;
    address public receiver;
    IERC20 public sellToken;
    IERC20 public buyToken;
    uint public startTime;
    uint public endTime;
    uint public interval;
    bool public active;
    uint public amount;
    uint public executionOrderNumber;
    uint public totalExecutionOrderNumber;
    uint[] public executionTimeArray;
    uint public totalNumberOfInv;
    uint public currentNumberOfInv;
    ILogContract public logContract;

    IUniswapV2Router01 public uniswap;

    constructor() {
        _disableInitializers();
    }

    event Init(address _owner,
        address _receiver,
        address _sellToken,
        address _buyToken,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _interval,
        uint256 _amount);
    
    event SwappedToken(
       uint256 timestamp,
       uint256 currentInvestmentNumber,
       uint256 totalInvestmentNumber,
       uint256 swappedTokenAmount,
       bool isActive
    );

    event Deposit(uint256 balance,bool isActive);

    event Cancel(uint256 balance, bool isActive);

    function init(
        address _owner,
        address _receiver,
        address _sellToken,
        address _buyToken,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _interval,
        uint256 _amount,
        address swapRouter,
        address _logContract
    ) external initializer {
        owner = _owner;
        receiver = _receiver;
        sellToken = IERC20(_sellToken);
        buyToken = IERC20(_buyToken);
        startTime = _startTime;
        endTime = _endTime;
        interval = _interval;
        amount = _amount;
        uniswap = IUniswapV2Router01(swapRouter);
        totalNumberOfInv = calculateExecutionOrderTime().length;
        logContract = ILogContract(_logContract);

        emit Init(
        owner,
        receiver,
        address(sellToken),
        address(buyToken),
        startTime,
        endTime,
        interval,
        amount 
        );

        logContract.logInit(address(this), owner, receiver, address(sellToken), address(buyToken), startTime, endTime, interval, amount);

    }

    function calculateExecutionOrderTime()
        public
        view
        returns (uint[] memory timeSlots)
    {
        uint256 total = Math.ceilDiv(
            BokkyPooBahsDateTimeLibrary.diffHours(startTime, endTime),
            interval
        );
        timeSlots = new uint256[](total);
        for (uint256 i = 0; i < total; i++) {
            uint256 orderExecutionTime = startTime + (i * interval * 1 hours);
            timeSlots[i] = orderExecutionTime;
        }
        return timeSlots;
    }

    function currentSlot() public view returns (uint256 slot) {
        uint256 _startTime = startTime;
        uint256 currentTime = block.timestamp;

        if (currentTime < _startTime) {
            return 0;
        }

        if (currentTime > endTime) {
            return 0;
        }

        uint256 intervalTimestamp = interval * 1 hours;
        return
            _startTime +
            (((currentTime - _startTime) / intervalTimestamp) *
                intervalTimestamp);
    }

    function isLastSlot() public view returns (bool) {
        uint256 intervalTimestamp = interval * 1 hours;
        return
            ((startTime +
                ((((block.timestamp - startTime) / intervalTimestamp) + 1) *
                    intervalTimestamp)) + intervalTimestamp) > endTime;
    }

    function deposit() public {
        require(msg.sender == owner, "Caller is not Owner");
        require(active == false, "Already active");
        active = true;
        sellToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Deposit(sellToken.balanceOf(address(this)),active);
        logContract.logDeposit(address(this), sellToken.balanceOf(address(this)), active);
    }

    function cancel() public {
        require(msg.sender == owner, "Caller is not Owner");
        require(active == true, "Already inactive");
        sellToken.safeTransfer(owner, sellToken.balanceOf(address(this)));
        active = false;
        emit Cancel(sellToken.balanceOf(address(this)),active);
        logContract.logCancel(address(this), sellToken.balanceOf(address(this)), active);
    }

    function calculateInvestmentAmount()
        public
        view
        returns (uint256 orderSellAmount)
    {
        uint256 _endTime = endTime;
        if (block.timestamp >= _endTime) {
            return 0;
        }
        (, orderSellAmount) = Math.tryDiv(
            amount,
            (
                Math.ceilDiv(
                    BokkyPooBahsDateTimeLibrary.diffHours(startTime, _endTime),
                    interval
                )
            )
        );
    }
    function swap() public {
        uint invAmount;
        uint256 _endTime = endTime;
        require(
            currentNumberOfInv < totalNumberOfInv,
            "Not a valid txn number"
        );
        require(active == true, "Already inactive");
        require(block.timestamp < _endTime, "End is already reached");
        
        if (isLastSlot()) {
            invAmount = sellToken.balanceOf(address(this));
        } else {
            invAmount = calculateInvestmentAmount();
        }
        address[] memory path = new address[](2);
        path[0] = address(sellToken);
        path[1] = address(buyToken);

        uint swappedAmount = uniswap.swapExactTokensForTokens(
            invAmount,
            (invAmount * 99) / 100,
            path,
            receiver,
            block.timestamp + 15
        )[1];
        require(swappedAmount > 0, "Failed to swapped");
        currentNumberOfInv++;

        emit SwappedToken(block.timestamp,currentNumberOfInv,totalNumberOfInv,swappedAmount,active);
        logContract.logSwappedToken(address(this), currentNumberOfInv, totalNumberOfInv, swappedAmount, active);
    }
}
