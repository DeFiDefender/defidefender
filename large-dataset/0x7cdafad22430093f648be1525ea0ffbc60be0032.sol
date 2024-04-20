pragma solidity ^0.5.17;



interface LendingPool {

    function getUserAccountData(address _user)

        external

        view

        returns (

            uint256 totalLiquidityETH,

            uint256 totalCollateralETH,

            uint256 totalBorrowsETH,

            uint256 totalFeesETH,

            uint256 availableBorrowsETH,

            uint256 currentLiquidationThreshold,

            uint256 ltv,

            uint256 healthFactor

        );

}



contract AaveLiquidations {

    

    function filterLiquidations(LendingPool pool, address[] calldata users) external view returns (address[] memory active) {

        

        address[] memory usersToLiquidate = users;

        

        uint liquidationsCount;

        for (uint i = 0; i < usersToLiquidate.length; i++) {

            (bool ok, bytes memory data) = address(pool).staticcall(abi.encodeWithSelector(

                pool.getUserAccountData.selector,

                usersToLiquidate[i]

            ));

            if (!ok || data.length == 0) {

                usersToLiquidate[i] = address(0);

                continue;

            }

            

            (,,,,,,, uint256 healthFactor) = abi.decode(data, (uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256));

            

            if (healthFactor > 1e18) {

                usersToLiquidate[i] = address(0);

                continue;

            }

            liquidationsCount++;

        }

        

        active = new address[](liquidationsCount);

        uint counter;

          for (uint i = 0; i < usersToLiquidate.length; i++) {

            if (usersToLiquidate[i] == address(0)) {

                continue;

            }

            active[counter] = usersToLiquidate[i];

            counter++;

        }

    }

    

}
