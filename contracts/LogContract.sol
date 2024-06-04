// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract LogContract{
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

     event Init(
        address contractAddress,
        address _owner,
        address _receiver,
        address _sellToken,
        address _buyToken,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _interval,
        uint256 _amount);
    

    event Deposit(address contractAddress,uint256 balance,bool isActive);

    event Cancel(address contractAddress,uint256 balance, bool isActive);

    event SwappedToken(
       uint timestamp,
       address contractAddress,
       uint256 currentInvestmentNumber,
       uint256 totalInvestmentNumber,
       uint256 swappedTokenAmount,
       bool isActive
    );

    function logCreateDCA(
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
    ) external {
        emit CreateDCA(
            strategyID,
            _owner,
            _receiver,
            _sellToken,
            _buyToken,
            _startTime,
            _endTime,
            _interval,
            _amount,
            swapRouter
        );
    }

    function logInit(
        address contractAddress,
        address owner,
        address receiver,
        address sellToken,
        address buyToken,
        uint256 startTime,
        uint256 endTime,
        uint256 interval,
        uint256 amount) external {
        emit Init(
        contractAddress,
        owner,
        receiver,
        sellToken,
        buyToken,
        startTime,
        endTime,
        interval,
        amount);
    }

    function logDeposit(
        address contractAddress,
        uint256 balance,
        bool isActive
    ) external {
        emit Deposit(contractAddress, balance, isActive);
    }

    function logCancel(
        address contractAddress,
        uint256 balance,
        bool isActive
    ) external {
        emit Cancel(contractAddress, balance, isActive);
    }

    function logSwappedToken(
       address contractAddress,
       uint256 currentInvestmentNumber,
       uint256 totalInvestmentNumber,
       uint256 swappedTokenAmount,
       bool isActive
    ) external {
        emit SwappedToken(
        block.timestamp,
        contractAddress,
        currentInvestmentNumber,
        totalInvestmentNumber,
        swappedTokenAmount,
        isActive
        );
    }


    
}