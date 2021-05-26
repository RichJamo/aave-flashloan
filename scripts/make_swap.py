from brownie import accounts, config, network, interface


def main():
    """
    Runs the make_swap function on the Uniswap pair address for two particular tokens, wbtc & weth
    """
    make_swap()


def make_swap():
    """
    swap two particular tokens, wbtc and weth 
    """
    usdc = interface.WmaticInterface(config["networks"][network.show_active()]["usdc"])
    weth = interface.WmaticInterface(config["networks"][network.show_active()]["weth"])
    factory = interface.IUniswapV2Factory(config["networks"][network.show_active()]["quickswap_factory"])
    #pair_address = factory.getPair(wbtc,weth)
    pair_address = interface.WmaticInterface(config["networks"][network.show_active()]["usdc_eth_pair"])
    #factory = pair_address.Factory()
    print(pair_address)
    exchange = interface.IUniswapV2Pair(pair_address)
    print(exchange)
    router = interface.IUniswapV2Router02(config["networks"][network.show_active()]["quickswap_router_v2_02"])
    print(exchange.name())
    print(exchange.symbol())
    print(exchange.decimals())
    print("Total supply: ", exchange.totalSupply())
    print("My balance: ", exchange.balanceOf("0x94b93044f635f6E12456374EC1C2EeaE6D8eD945"))
    print("Factory address: ", exchange.factory())
    print("Token0 address: ", exchange.token0())
    print("Token1 address: ", exchange.token1())
    print("Reserves: ", exchange.getReserves())
    print("Price0 cum last: ", exchange.price0CumulativeLast())
    print("Price1 cum last: ", exchange.price1CumulativeLast())
    print("k last: ", exchange.kLast()) #why is this zero?

    acct = accounts.add(
        config["wallets"]["from_key"]
    )  # add your keystore ID as an argument to this call
    print(usdc.decimals())
    amountIn = 0.5*10**usdc.decimals()
    #usdc.approve(router, amountIn, {"from": acct})
    amountOutMin = 0.000383501*0.5*10**weth.decimals() #check this from external source - quickswap
    path = [usdc, weth]
    #path[0]=weth
    #path[1]=wb
    deadline = 3000
    #tx = router.swapExactETHForTokens(amountOutMin, path, acct, deadline, {"from": acct, "value": 1*10**18, "allow_revert": True})
    tx = router.swapExactTokensForTokens(amountIn, amountOutMin, path, acct, deadline, {"from": acct, "allow_revert": True})
    #{"from": acct, "allow_revert": True} , "value": 1000000000000000000
    print("Swap made!")
    return tx
    
