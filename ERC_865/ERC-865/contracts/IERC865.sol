pragma solidity 0.4.25;



 contract IERC865 {
     function cancelPreSigned(
        bytes _signature,
        address _token,
        address _from,
        uint256 _nonce,
        uint256 _reward
     )
        public;

     function transferPreSigned(
        bytes _signature,
        address _token,
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
     )
        public;

    event CancelPreSigned(
        address indexed delegate,
        address indexed from,
        uint256 nonce,
        uint256 reward);

     event TransferPreSigned(
        address indexed delegate,
        address indexed from,
        address indexed to,
        uint256 value,
        uint256 fee);
}
