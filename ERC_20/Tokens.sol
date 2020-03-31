pragma solidity ^0.6.4;

interface TokenRecipient{ function reciveApproval(address _from ,uint256 _value, 
address token ,bytes calldata _extraData) external ; }


contract owned{
    
    address public owner;
    constructor() public 
    {
        owner = msg.sender;
    }
    modifier onlyOwner{
        require (msg.sender== owner);
        _;
        
    }
    function TransferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
}

contract ErcTokens is owned{
    
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint256 decimal = 18;
    
    uint256 public buyPrize;
    uint256 public sellPrize;
    
    uint256  minBalanceForAccounts;
    
    bytes32 public currentChallenge;
    uint256 public timeOfLastProof;
    uint256 difficulty = 10**32;
    
    // _____________________MAPPING_______________________________________________
    
    
    mapping (address=>uint256) public balanceOf;
    mapping(address => mapping(address=>uint256)) public allowance;
    mapping(address => bool ) public frozenAccount;
    
    
    // _________________________ADDING EVENTS___________________________________
    
    event Transfer(address indexed from , address indexed to , uint256 value);
    event approval(address indexed _owner , address indexed _spender , uint256 _value);
    event Burn(address indexed from , uint256 value);
    event frozenFunds(address target , bool frozen);
    event tokenPrize(uint256 newSellPrice , uint256 newBuyPrice);

    
    
    // _____________________________CONSTRUCTORS____________________________________
    
    
    constructor(uint256 initalSupply,string memory TokenName,string memory TokenSymbol) public  {
                    totalSupply = initalSupply*10**uint256(decimal);
                    balanceOf[msg.sender] = totalSupply;
                    name = TokenName;
                    symbol = TokenSymbol;
                    }
                    
                    
    // __________________________TRANSFER & balanceOf_____________________________

    
    
    function _transfer(address _from , address _to , uint256 _value) internal{
        
        // require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        require(!frozenAccount[msg.sender]);
        
        uint256 previousBalance = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        
        
        emit Transfer(_from, _to, _value);
        
        
        assert (balanceOf[_from] +balanceOf[_to] == previousBalance);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        
        
        if (msg.sender.balance < minBalanceForAccounts){
            sell((minBalanceForAccounts - msg.sender.balance) / sellPrize);
        }
        
        _transfer(msg.sender,_to,_value);
        
        return true;
    }
    
    // _____________________________ALLOWANCE_______________________________
    
   
    
    function approve(address _spender , uint256 _value) onlyOwner public returns (bool success) {
         
         allowance [msg.sender][_spender] = _value;
         
         emit approval(msg.sender,_spender,_value);
         
         return true;
        
    } 
    
    
    // ___________________________APPROVE______________________________________
    
    
    function approveAndCall(address _spender ,uint256 _value ,bytes memory _extraData ) 
    public returns (bool success){
        
        TokenRecipient spender = TokenRecipient (_spender);
        
        if(approve(_spender,_value)){
            spender.reciveApproval(msg.sender , _value,address(this), _extraData);
            
            return true;
        }
    }
    
    // ________________________________BURN________________________________
    
    
    function burn (uint256 _value) public returns (bool success){
        
        require (balanceOf[msg.sender]>= _value);
        
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        
        emit  Burn(msg.sender,_value);
        return true;
    }
    
    function burnFrom(address _from ,uint256 _value) public returns (bool success){
                require (balanceOf[_from]>= _value);
                require(_value<=allowance[_from][msg.sender]);
                
                balanceOf[_from] -= _value;
                totalSupply -= _value;
                
            emit  Burn(msg.sender,_value);

                return true;

    }
    
    // ___________________________MINT TOKENS__________________________
    
    
    
    function mintTokens(address target , uint256 mintedAmount) public onlyOwner {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        
    }
    
    // _____________________________Frezzing_________________________________
    
    
    function freezAccount (address target , bool freeze) public onlyOwner {
        frozenAccount[target] = freeze ;
        emit frozenFunds(target , freeze);
        
    }
    
    // ________________________BUY & SELL WITH ETH_______________________________
    
        function setPrice( uint256 newSellPrice , uint256 newBuyPrice) public onlyOwner{
            
           sellPrize  =  newSellPrice;
            buyPrize  = newBuyPrice;
        }
        
        function buy() public payable returns (uint256 amount){
            amount = msg.value / buyPrize;
            _transfer (address(this), msg.sender , amount);
            return amount;
        }
        
        function sell (uint256 amount ) public returns (uint256 revenue){
        require(balanceOf[msg.sender] >= amount);
        balanceOf[address(this)] += amount;
        balanceOf[msg.sender] -= amount;
        revenue = amount * sellPrize;
        msg.sender.transfer(revenue);
        return revenue;
        }
        
        // ___________________________AUTO REFILL________________________________
        
        
        function setMinbalance(uint256 minimumBalanceInfinney) public onlyOwner {
            
            minBalanceForAccounts = minimumBalanceInfinney * 1 finney;
        }
        
        
        // ___________________________PROOF OF WORK____________________________________
        
        
        function proofOfWork(uint nonce)public {
            
        uint256  n = uint256(keccak256(abi.encodePacked(nonce, currentChallenge))); 
        require(n >= uint256(difficulty)); 
    
        uint timeSinceLastProof = (now - timeOfLastProof); 
        require(timeSinceLastProof >=  5 seconds); 
        balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  
    
        difficulty = difficulty * 10 minutes / timeSinceLastProof + 1; 
        timeOfLastProof = now; // Reset the counter
        currentChallenge = keccak256(abi.encodePacked(nonce, currentChallenge,
        blockhash(block.number - 1)));  
        }       
}
























