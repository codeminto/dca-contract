// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
interface IDCA {

    function init(
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

    function calculateExecutionOrderTime()
        external
        view
        returns (uint[] memory timeSlots);

    function currentSlot() external view returns (uint256 slot);

    function isLastSlot() external view returns (bool);

    function deposit() external;

    function cancel() external;

    function calculateInvestmentAmount()
        external
        view
        returns (uint256 orderSellAmount);

    function swap() external;
}