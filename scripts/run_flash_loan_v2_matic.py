from brownie import FlashloanV2_matic, accounts, config, network, interface

MINIMUM_FLASHLOAN_WMATIC_BALANCE = 50000000000000000 #took one zero out here
MATICVIGIL_TX_URL = "https://explorer-mumbai.maticvigil.com/tx/{}"


def main():
    """
    Executes the funcitonality of the flash loan.
    """
    acct = accounts.add(config["wallets"]["from_key"])
    print("Getting Flashloan contract...")
    flashloan = FlashloanV2_matic[len(FlashloanV2_matic) - 1]
    wmatic = interface.WmaticInterface(config["networks"][network.show_active()]["wmatic"])
    # We need to fund it if it doesn't have any token to fund!
    if wmatic.balanceOf(flashloan) < MINIMUM_FLASHLOAN_WMATIC_BALANCE:
        print("Funding Flashloan contract with WMATIC...")
        wmatic.transfer(flashloan, "0.1 ether", {"from": acct}) #check if 'ether' works here
    print("Executing Flashloan...")
    tx = flashloan.flashloan(wmatic, {"from": acct, "allow_revert": True})
    print("You did it! View your tx here: " + MATICVIGIL_TX_URL.format(tx.txid))
    return flashloan
