// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ILogContract {
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
    ) external;

    function logInit(
        address contractAddress,
        address owner,
        address receiver,
        address sellToken,
        address buyToken,
        uint256 startTime,
        uint256 endTime,
        uint256 interval,
        uint256 amount) external;

    function logDeposit(
        address contractAddress,
        uint256 balance,
        bool isActive
    ) external;

    function logCancel(
        address contractAddress,
        uint256 balance,
        bool isActive
    ) external;

    function logSwappedToken(
       address contractAddress,
       uint256 currentInvestmentNumber,
       uint256 totalInvestmentNumber,
       uint256 swappedTokenAmount,
       bool isActive
    ) external;
}