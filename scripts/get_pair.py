from brownie import accounts, config, network, interface


def main():
    """
    Runs the get_pair function to get the Uniswap pair address for two particular tokens, wbtc & weth
    """
    get_pair()


def get_pair():
    """
    get the Uniswap pair address for two particular tokens, wbtc & weth  
    """
    wbtc = interface.WmaticInterface(config["networks"][network.show_active()]["wbtc"])
    weth = interface.WmaticInterface(config["networks"][network.show_active()]["weth"])
    factory = interface.IUniswapV2Factory(config["networks"][network.show_active()]["uniswap_factory"])
    pair_address = factory.getPair(wbtc,weth)
    print(pair_address)
    #return pair_address
