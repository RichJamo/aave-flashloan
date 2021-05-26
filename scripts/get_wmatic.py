from brownie import accounts, config, network, interface


def main():
    """
    Runs the get_wmatic function to get WMATIC
    """
    get_wmatic()


def get_wmatic():
    """
    Mints WMATIC by depositing ETH.
    """
    acct = accounts.add(
        config["wallets"]["from_key"]
    )  # add your keystore ID as an argument to this call
    wmatic = interface.WmaticInterface(config["networks"][network.show_active()]["wmatic"])
    tx = wmatic.deposit({"from": acct, "value": 100000000000000000, "allow_revert": True})
    print("Received 0.1 WMATIC")
    return tx
