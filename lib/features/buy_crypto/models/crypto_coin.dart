enum CryptoCoin {
  bitcoin,
  ethereum,
  tether,
  bnb,
  solana,
  usdCoin;

  int get id {
    switch (this) {
      case CryptoCoin.bitcoin:
        return 0;
      case CryptoCoin.ethereum:
        return 1;
      case CryptoCoin.tether:
        return 2;
      case CryptoCoin.bnb:
        return 3;
      case CryptoCoin.solana:
        return 4;
      case CryptoCoin.usdCoin:
        return 5;
    }
  }

  String get name {
    switch (this) {
      case CryptoCoin.bitcoin:
        return 'Bitcoin';
      case CryptoCoin.ethereum:
        return 'Ethereum';
      case CryptoCoin.tether:
        return 'Tether';
      case CryptoCoin.bnb:
        return 'BNB';
      case CryptoCoin.solana:
        return 'Solana';
      case CryptoCoin.usdCoin:
        return 'USD Coin';
    }
  }

  String get symbol {
    switch (this) {
      case CryptoCoin.bitcoin:
        return 'BTC';
      case CryptoCoin.ethereum:
        return 'ETH';
      case CryptoCoin.tether:
        return 'USDT';
      case CryptoCoin.bnb:
        return 'BNB';
      case CryptoCoin.solana:
        return 'SOL';
      case CryptoCoin.usdCoin:
        return 'USDC';
    }
  }

  static CryptoCoin fromId(int id) {
    return CryptoCoin.values.firstWhere((coin) => coin.id == id);
  }
}