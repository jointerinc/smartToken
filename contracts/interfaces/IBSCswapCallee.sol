// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.1;

interface IBSCswapCallee {
    function BSCswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
