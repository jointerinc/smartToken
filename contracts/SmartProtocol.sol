pragma solidity ^0.8.1;

import "./interfaces/IBEP20.sol";
import "./interfaces/IBSCswapRouter02.sol";
import "./interfaces/IBSCswapFactory.sol";
import "./Ownable.sol";


contract SmartProtocol is Ownable{
    
    address public tokenAddress ;
    
    IBSCswapRouter02 public bscV2Router;
    
    constructor(address _bscV2RouterAddress,address _tokenAddress){
        bscV2Router = IBSCswapRouter02(_bscV2RouterAddress);
        tokenAddress = _tokenAddress;
    }
    
    
    function swapAndLiquify() external {
       
        // split the contract balance into halves
        uint256 contractTokenBalance = IBEP20(tokenAddress).balanceOf(address(this));
        
        IBEP20(tokenAddress).approve(address(bscV2Router),contractTokenBalance);
        
        uint256 half = contractTokenBalance / 2;
        
        uint256 otherHalf = contractTokenBalance- half;

        uint256 initialBalance = address(this).balance;
        
        address[] memory path = new address[](2);
        path[0] = address(tokenAddress);
        path[1] = bscV2Router.WBNB();

        bscV2Router.swapExactTokensForBNB(
            half,
            0,
            path,
            address(this),
            block.timestamp
        );
      
        uint256 newBalance = address(this).balance - initialBalance;

        bscV2Router.addLiquidityBNB{ value: newBalance }(
            address(tokenAddress),
            otherHalf,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            IBEP20(tokenAddress).getOwner(),
            block.timestamp
        );
    }
    
    // remove other token and excessive bnb 
    // ownership will be transfer to dao
    function transferFund(address _token, uint256 _value,address payable _to) external onlyOwner returns(bool) {
        if (address(_token) == address(0)) {
            _to.transfer(_value);
        } else {
          IBEP20(_token).transfer(_to, _value);
        }
        return true;
    }


  
    receive() external payable {}

}