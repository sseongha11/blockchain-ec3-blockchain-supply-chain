// Any programming language provides the facility to comment code and so does Solidity.
// With the help of the pragma directive, you can choose the compiler version and target your code accordingly.
pragma solidity ^0.5.0;

// we can define contracts, libraries, and interfaces at the global or top level.
// we will simply define one contract (Asset)
contract Asset {
    
  /* Variables in programming refer to storage location that can contain values. 
  These values can be changed during runtime.*/    

  // Asset name such as steel structures and gas turbine
  string public name;

  /* Accounts are the main building blocks for the Ethereum ecosystem. It is an interaction between accounts that Ethereum wants to store as transactions in its ledger.
  There are two types of accounts available in Ethereum—externally owned accounts and contract accounts.
  Contract accounts are very similar to externally owned accounts. */
  address public custodian; 
  
  STATUSES public status;
  
  /* The enum keyword is used to declare enumerations. 
  Enumerations help in declaring a custom user-defined data type in Solidity */
  
  // enumeration declaraion!
  enum STATUSES {
    CREATED,
    SENT,
    RECEIVED
  }

  /* Solidity supports events. Events in Solidity are just like events in other programming languages. 
  Events are fired from contracts such that anybody interested in them can trap/catch them and execute code in response. */

  event Action(
    string name,
    address account,
    address custodian,
    uint timestamp
  );

  constructor(string memory _name) public {
    // Set name
    name = _name;

    // Make deployer custodian
    custodian = msg.sender;

    // using enum - Update status to "CREATED"
    status = STATUSES.CREATED;

    // Log history
    emit Action("CREATE", msg.sender, msg.sender, now);
  }
  
  /* Functions are the heart of Ethereum and Solidity. (public, internal, private and external)
  Ethereum maintains the current state of state variables and executes transaction to change values in state variables */

  function send(address _to) public {
    // Must be custodian to send - cehck the conditiona
    require(msg.sender == custodian);

    // Cannot send to self
    require(_to != custodian);

    // Can't be in "SENT" status
    // Must be "CREATED" or "RECEIVED"
    require(status != STATUSES.SENT);

    // Update status to "SENT"
    status = STATUSES.SENT;

    // Make _to new custodian
    custodian = _to;

    // Log history
    emit Action("SEND", msg.sender, _to, now);
  }

  function receive() public {
    // Must be custodian to receive
    require(msg.sender == custodian);

    // Must be in "SENT" status
    // Cannot be "CREATED" or "RECEIVED"
    require(status == STATUSES.SENT);

    // Update status to "RECEIVED"
    status = STATUSES.RECEIVED;

    // Log history
    emit Action("RECEIVE", msg.sender, msg.sender, now);
  }
}