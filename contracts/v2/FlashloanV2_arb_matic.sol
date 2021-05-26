pragma solidity ^0.6.6;

import "./aave/FlashLoanReceiverBaseV2.sol";
import "../../interfaces/v2/ILendingPoolAddressesProviderV2.sol";
import "../../interfaces/v2/ILendingPoolV2.sol";
//import "../../interfaces/v2/IUniswap.sol";

contract FlashloanV2_arb_matic is FlashLoanReceiverBaseV2, Withdrawable {
    
    //address public constant USDC_ADDRESS = "0x2791bca1f2de4661ed88a30c99a7a9449aa84174";
    //address public constant WETH_ADDRESS = "0x7ceb23fd6bc0add59e62ac25578270cff1b9f619";
    //address public constant UNISWAP_FACTORY_A = 0xECc6C0542710a0EF07966D7d1B10fA38bbb86523;
    //address public constant UNISWAP_FACTORY_B = 0x54Ac34e5cE84C501165674782582ADce2FDdc8F4;
    //address public constant QUICKSWAP_USDC_WETH_PAIR = "0x853ee4b2a13f8a742d64c8f088be7ba2131f670d";
    /*
    ILendingPool public lendingPool;
    IUniswapExchange public exchangeA;
    IUniswapExchange public exchangeB;
    IUniswapFactory public uniswapFactoryA;
    IUniswapFactory public uniswapFactoryB;
    */

    constructor(address _addressProvider) FlashLoanReceiverBaseV2(_addressProvider) public {
        /*
        // Instantiate Uniswap Factory A
        uniswapFactoryA = IUniswapFactory(UNISWAP_FACTORY_A);
        // get Exchange A Address
        address exchangeA_address = uniswapFactoryA.getExchange(DAI_ADDRESS);
        // Instantiate Exchange A
        exchangeA = IUniswapExchange(exchangeA_address);

        //Instantiate Uniswap Factory B
        uniswapFactoryB = IUniswapFactory(UNISWAP_FACTORY_B);
        // get Exchange B Address
        address exchangeB_address = uniswapFactoryB.getExchange(BAT_ADDRESS);
        //Instantiate Exchange B
        exchangeB = IUniswapExchange(exchangeB_address);
        */

        // get lendingPoolAddress
        //address lendingPoolAddress = addressesProvider.getLendingPool();
        //Instantiate Aaave Lending Pool B
        //lendingPool = ILendingPool(lendingPoolAddress);
    }
    
    /**
     * @dev This function must be called only by the LENDING_POOL and takes care of repaying
     * active debt positions, migrating collateral and incurring new V2 debt token debt.
     *
     * @param assets The array of flash loaned assets used to repay debts.
     * @param amounts The array of flash loaned asset amounts used to repay debts.
     * @param premiums The array of premiums incurred as additional debts.
     * @param initiator The address that initiated the flash loan, unused.
     * @param params The byte array containing, in this case, the arrays of aTokens and aTokenAmounts.
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
        )
        external
        override
        returns (bool)
        {
        
        //
        // This contract now has the funds requested.
        // Your logic goes here.
        // If transactions are not mined until deadline the transaction is reverted
        /*uint256 deadline = getDeadline();

        ERC20 dai = ERC20(DAI_ADDRESS);
        ERC20 bat = ERC20(BAT_ADDRESS);

        // Buying ETH at Exchange A
        require(
            dai.approve(address(exchangeA), _amount),
            "Could not approve DAI sell"
        );

        uint256 tokenBought = exchangeA.tokenToTokenSwapInput(
            _amount,
            1,
            1,
            deadline,
            BAT_ADDRESS
        );

        require(
            bat.approve(address(exchangeB), tokenBought),
            "Could not approve DAI sell"
        );

        // Selling ETH at Exchange B
        uint256 daiBought = exchangeB.tokenToTokenSwapInput(
            tokenBought,
            1,
            1,
            deadline,
            DAI_ADDRESS
        );

        // Repay loan
        uint256 totalDebt = _amount.add(_fee);

        require(daiBought > totalDebt, "Did not profit");
        */
        // At the end of your logic above, this contract owes
        // the flashloaned amounts + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.
        
        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint i = 0; i < assets.length; i++) {
            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }
        
        return true;
    }

    function _flashloan(address[] memory assets, uint256[] memory amounts) internal {
        address receiverAddress = address(this);

        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        uint256[] memory modes = new uint256[](assets.length);

        // 0 = no debt (flash), 1 = stable, 2 = variable
        for (uint256 i = 0; i < assets.length; i++) {
            modes[i] = 0;
        }

        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }

    /*
     *  Flash multiple assets 
     */
    function flashloan(address[] memory assets, uint256[] memory amounts) public onlyOwner {
        _flashloan(assets, amounts);
    }

    /*
     *  Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */
    function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 0.1 ether; //main difference from ether contract

        address[] memory assets = new address[](1);
        assets[0] = _asset;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        _flashloan(assets, amounts);
    }
}