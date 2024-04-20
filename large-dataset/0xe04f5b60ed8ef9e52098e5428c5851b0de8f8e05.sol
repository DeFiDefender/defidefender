pragma solidity ^0.5.8;



contract CommonInterestModel {

    uint256 constant BASE = 10**18;



    /**

     * @param borrowRatio a decimal with 18 decimals

     */

    function polynomialInterestModel(uint256 borrowRatio) external pure returns(uint256) {

        // 0.05 + 0.4 * r**4 + 0.55 * r**8



        // the valid range of borrowRatio is [0, 1]

        uint256 r = borrowRatio > BASE ? BASE : borrowRatio;

        uint256 r2 = r * r / BASE;

        uint256 r4 = r2 * r2 / BASE;

        uint256 r8 = r4 * r4 / BASE;



        return BASE*5/100 + (40 * r4 / 100) + (55 * r8 / 100);

    }

}
